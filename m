Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758346Ab3HOAAr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 20:00:47 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:16219 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab3HOAAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 20:00:44 -0400
X-AuditID: cbfec373-b7fca6d0000018b9-5d-520c1a2b2a18
Date: Wed, 14 Aug 2013 21:00:35 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: Borislav Petkov <bp@alien8.de>, tony.luck@intel.com, bhelgaas@google.com,
        rostedt@goodmis.org, rjw@sisk.pl, lance.ortiz@hp.com,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mce: acpi/apei: trace: Enable ghes memory error trace
 event
Message-id: <20130814210035.57096048@concha.lan>
In-reply-to: <520A6D98.9060204@linux.vnet.ibm.com>
References: <1375986471-27113-1-git-send-email-naveen.n.rao@linux.vnet.ibm.com>
 <1375986471-27113-4-git-send-email-naveen.n.rao@linux.vnet.ibm.com>
 <20130808163822.67e0828a@samsung.com> <20130810180322.GC4155@pd.tnic>
 <20130812083355.47c1bae8@samsung.com> <5208D80D.5030206@linux.vnet.ibm.com>
 <20130812125343.GE18018@pd.tnic> <520A16BD.30201@linux.vnet.ibm.com>
 <20130813124258.GC4077@pd.tnic> <520A6D98.9060204@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.19; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t/hYF1tKZ4gg62/tC2WNGVYfN7wj83i
	Q981Jovl+/oZLS7vmsNmcXbecTaL+y1P2S36F/YyWezreMBk8ebCPRYHLo/vrX0sHi37brF7
	LNhU6rFr204mj8V7XjJ5PDi0mcXj0eIWRo/Pm+QCOKK4bFJSczLLUov07RK4Mhpvv2It2Cda
	sWzBBrYGxhsCXYycHBICJhLdN96yQNhiEhfurWfrYuTiEBJYwijRNHMbC4TTwCQxsWcRkMPB
	wSKgKvFlmQ5IA5uAkcSrxhZWEFtEwFTiyIrrTCD1zAJ3GSVal65jA0kIC4RJ7NnTzARi8woY
	SLx9NYEdxOYEaj64djLUtl3MEmcbj4EtkBBwktg61ReiXlDix+R7YNcxC2hJbN7WxAphy0ts
	XvOWeQKjwCwkZbOQlM1CUraAkXkVo2hpcXJBcVJ6rpFecWJucWleul5yfu4mRkh8FO9gfLHB
	6hCjAAejEg/vhg7uICHWxLLiytxDjBIczEoivGdAQrwpiZVVqUX58UWlOanFhxiZODilGhht
	fn69tpznyt22L70M+xQnPyj1Xqyymqlo+4Tal+Fav2KWZZi3flmy1ebJ60KVHTUdp9/OTTt9
	P9FH0q2p5m3U6unF+34tMrgirK8ZHDxDqpJ9UrbEEi529fRtYhlMzdEd994ybLQK0rhofsS5
	Lb12ccaM3TeyH+wSjQtUDtxy5kfzh8LZl+KUWIozEg21mIuKEwGd3qrrbQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, 13 Aug 2013 23:02:08 +0530
"Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com> escreveu:

> On 08/13/2013 06:12 PM, Borislav Petkov wrote:
> > On Tue, Aug 13, 2013 at 04:51:33PM +0530, Naveen N. Rao wrote:
> >> You're right - my trace point makes all the data provided by apei
> >> as-is to userspace. However, ghes_edac seems to squash some of this
> >> data into a string when reporting through mc_event.
> >
> > Right, for systems which don't need EDAC to decode to the DIMM or for
> > which there are no EDAC drivers written, they could use a tracepoint
> > which carries APEI info as-is. Others, which need EDAC, should probably
> > use trace_mc_event and disable the APEI tracepoint.
> 
> If I'm not mistaken, even for systems that have EDAC drivers, it looks 
> to me like EDAC can't really decode to the DIMM given what is provided 
> by the bios in the APEI report currently.

Yes, the current APEI events, reported via EDAC, can't be decoded currently.

> If and when ghes_edac gains 
> this capability, users will have a choice between raw APEI reports vs. 
> edac processed ones.

An APEI-specific tracing won't fix it, as, AFAIKT, we don't have any way
to map it, even on userspace.

> 
> >
> > I think this should address Tony's concerns...
> >
> > Btw, you could call your TP something simpler like
> > trace_ghes_memory_event or so.
> 
> I started out with a simpler name, but eventually decided to use the 
> name from the CPER record so it is clear what this event carries. I 
> think this will be better when adding further ghes events for say, 
> processor generic, PCIe and others.
> 
> >
> > Btw 2, if GHES can report other types of errors (I'm pretty sure it can)
> > maybe we can use a single tracepoint called trace_ghes_event for any
> > types of errors coming out of it...
> 
> Two problems with this:
> - One, the record size will be really big since the cper records for 
> each type of error is large.
> - Two, it may be better to filter events based on the type of error 
> (memory error, processor, pcie, ...) rather than subscribing for all 
> ghes error reports.

I agree: per-type of error events is better than a big generic one.
> 
> >
> > Oh, and while at it, we probably need to start thinking of a mechanism
> > to disable all the error printing, i.e. cper_print_mem() and such,
> > if a userspace agent is listening in on the tracepoint and the error
> > information is carried through it to userspace.
> 
> Do you mean conditionally print the cper records based on whether the 
> tracepoint is enabled or not? Wouldn't that be confusing if someone is 
> monitoring dmesg as well?
> 
> 
> Thanks,
> Naveen
> 


-- 

Cheers,
Mauro
