Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757801Ab3HNXyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 19:54:45 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:18995 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab3HNXyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 19:54:43 -0400
X-AuditID: cbfec373-b7fca6d0000018b9-de-520c18c1cdfc
Date: Wed, 14 Aug 2013 20:54:33 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: Borislav Petkov <bp@alien8.de>, tony.luck@intel.com, bhelgaas@google.com,
        rostedt@goodmis.org, rjw@sisk.pl, lance.ortiz@hp.com,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Aristeu Rozanski Filho <arozansk@redhat.com>
Subject: Re: [PATCH 3/3] mce: acpi/apei: trace: Enable ghes memory error trace
 event
Message-id: <20130814205433.452ef58d@concha.lan>
In-reply-to: <520A651E.3050604@linux.vnet.ibm.com>
References: <1375986471-27113-1-git-send-email-naveen.n.rao@linux.vnet.ibm.com>
 <1375986471-27113-4-git-send-email-naveen.n.rao@linux.vnet.ibm.com>
 <20130808163822.67e0828a@samsung.com> <20130810180322.GC4155@pd.tnic>
 <20130812083355.47c1bae8@samsung.com> <20130812123813.GD18018@pd.tnic>
 <20130812114932.52bb0314@samsung.com> <20130812150424.GH18018@pd.tnic>
 <20130812142557.2a43f155@samsung.com> <20130812175631.GI18018@pd.tnic>
 <520A1A2E.9080500@linux.vnet.ibm.com> <20130813092154.1e17385f@concha.lan>
 <520A651E.3050604@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.19; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t/hIN2DEjxBBi1LZSzaTvxms1jSlGHx
	ecM/NosPfdeYLJbv62e0uLxrDpvF2XnH2Szutzxlt+hf2Mtksa/jAZPFmwv3WBy4Pb639rF4
	tOy7xe6xYFOpx65tO5k8Fu95yeTx4NBmFo/3+66yeTxa3MLo8XmTXABnFJdNSmpOZllqkb5d
	AldG142sgt9CFRMndbM2MP7h62Lk5JAQMJGY3riGFcIWk7hwbz1bFyMXh5DAEkaJy1sugyWE
	BBqYJI6t4gGxWQRUJa78f8kOYrMJGEm8amwBqxERMJU4suI6E0gzs0A3k8TzfzfZQBLCAmES
	e/Y0M4HYvAIGEquenmAGsTmBmm+fmAO1bS2LxMMbl4CmcgCd4SSxdaovRL2gxI/J91hAbGYB
	LYnN25pYIWx5ic1r3jJPYBSYhaRsFpKyWUjKFjAyr2IULS1OLihOSs810itOzC0uzUvXS87P
	3cQIiZjiHYwvNlgdYhTgYFTi4d3QwR0kxJpYVlyZe4hRgoNZSYT3DEiINyWxsiq1KD++qDQn
	tfgQIxMHp1QD40wmR+8XThPC/7RK+p3f7dtzXi5/Ee+tMpfnObErygLjzXW+3PlT21vexfju
	osyZsDadY0a7tgoWqnFV64ksjFM//kreaLrbe8s1wmef53j93OxofzmE9aFGDteZ5tj65w+c
	J1pUHDzns730VnXKrgnCvb0XcjetO+N5SiVD/0XYlxXHmxN3KrEUZyQaajEXFScCAE+b3692	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, 13 Aug 2013 22:25:58 +0530
"Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com> escreveu:

(sorry for a late answer, I had to do a small travel yesterday)

> On 08/13/2013 05:51 PM, Mauro Carvalho Chehab wrote:
> > Em Tue, 13 Aug 2013 17:06:14 +0530
> > "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com> escreveu:
> >
> >> On 08/12/2013 11:26 PM, Borislav Petkov wrote:
> >>> On Mon, Aug 12, 2013 at 02:25:57PM -0300, Mauro Carvalho Chehab wrote:
> >>>> Userspace still needs the EDAC sysfs, in order to identify how the
> >>>> memory is organized, and do the proper memory labels association.
> >>>>
> >>>> What edac_ghes does is to fill those sysfs nodes, and to call the
> >>>> existing tracing to report errors.
> >>
> >> I suppose you're referring to the entries under /sys/devices/system/edac/mc?
> >
> > Yes.
> >
> >>
> >> I'm not sure I understand how this helps. ghes_edac seems to just be
> >> populating this based on dmi, which if I'm not mistaken, can be obtained
> >> in userspace (mcelog as an example).
> >>
> >> Also, on my system, all DIMMs are being reported under mc0. I doubt if
> >> the labels there are accurate.
> >
> > Yes, this is the current status of ghes_edac, where BIOS doesn't provide any
> > reliable way to associate a given APEI report to a physical DIMM slot label.
> >
> > The plan is to add more logic there as BIOSes start to provide some reliable
> > way to do such association. I discussed this subject with a few vendors
> > while I was working at Red Hat.
> 
> Hmm... is there anything specific in the APEI report that could help? 

I didn't see anything at APEI spec that would allow to describe how the
memory is organized. So, it is hard for the ghes_edac driver to discover
how many memory controllers, channels and slots are available. This data
is needed, in order to allow userspace to pass the labels for each DIMM,
or for the Kernel to auto-discover.

> More importantly, is there a need to do this in-kernel rather than in 
> user-space?

Yes, due to 2 aspects:

On a critical error, the machine will die. The EDAC core will print the
error at dmesg, but no other record to be latter parsed will be available;

With hot pluggable memories, dynamic channel rerouting, memory poisoning
and other funny things, it could not be possible to point to a DIMM, 
if the parsing is done on a latter time.

Regards,
Mauro
