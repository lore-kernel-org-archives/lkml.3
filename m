Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758687Ab3HMR6O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 13:58:14 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47424 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757355Ab3HMR6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 13:58:12 -0400
Date: Tue, 13 Aug 2013 19:58:09 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>, tony.luck@intel.com,
        bhelgaas@google.com, rostedt@goodmis.org, rjw@sisk.pl,
        lance.ortiz@hp.com, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mce: acpi/apei: trace: Enable ghes memory error
 trace event
Message-ID: <20130813175809.GE4077@pd.tnic>
References: <1375986471-27113-1-git-send-email-naveen.n.rao@linux.vnet.ibm.com>
 <1375986471-27113-4-git-send-email-naveen.n.rao@linux.vnet.ibm.com>
 <20130808163822.67e0828a@samsung.com>
 <20130810180322.GC4155@pd.tnic>
 <20130812083355.47c1bae8@samsung.com>
 <5208D80D.5030206@linux.vnet.ibm.com>
 <20130812125343.GE18018@pd.tnic>
 <520A16BD.30201@linux.vnet.ibm.com>
 <20130813124258.GC4077@pd.tnic>
 <520A6D98.9060204@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <520A6D98.9060204@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 11:02:08PM +0530, Naveen N. Rao wrote:
> If I'm not mistaken, even for systems that have EDAC drivers, it looks
> to me like EDAC can't really decode to the DIMM given what is provided
> by the bios in the APEI report currently. If and when ghes_edac gains
> this capability, users will have a choice between raw APEI reports vs.
> edac processed ones.

Which kinda makes that APEI tracepoint not really useful and we can call
the one we have already - trace_mc_event - from APEI...

> I started out with a simpler name, but eventually decided to use the
> name from the CPER record so it is clear what this event carries. I
> think this will be better when adding further ghes events for say,
> processor generic, PCIe and others.

This is exactly my fear: having to add a tracepoint per error type
instead of having a single trace_hw_error or so...

> >Btw 2, if GHES can report other types of errors (I'm pretty sure it can)
> >maybe we can use a single tracepoint called trace_ghes_event for any
> >types of errors coming out of it...
> 
> Two problems with this:
> - One, the record size will be really big since the cper records for
> each type of error is large.

I better go look at that CPER crap....

> - Two, it may be better to filter events based on the type of error
> (memory error, processor, pcie, ...) rather than subscribing for all
> ghes error reports.

You can filter that in userspace too.

> Do you mean conditionally print the cper records based on whether the
> tracepoint is enabled or not? Wouldn't that be confusing if someone is
> monitoring dmesg as well?

Why would you need dmesg if you get your hw errors over the tracepoint?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
