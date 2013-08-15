Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758634Ab3HOAPR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 20:15:17 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:54967 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab3HOAPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 20:15:13 -0400
X-AuditID: cbfec373-b7fca6d0000018b9-4b-520c1d90719d
Date: Wed, 14 Aug 2013 21:15:04 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>, "lance.ortiz@hp.com" <lance.ortiz@hp.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski Filho <arozansk@redhat.com>
Subject: Re: [PATCH 3/3] mce: acpi/apei: trace: Enable ghes memory error trace
 event
Message-id: <20130814211504.393cf138@concha.lan>
In-reply-to: <520B603E.3040002@linux.vnet.ibm.com>
References: <1375986471-27113-1-git-send-email-naveen.n.rao@linux.vnet.ibm.com>
 <1375986471-27113-4-git-send-email-naveen.n.rao@linux.vnet.ibm.com>
 <20130808163822.67e0828a@samsung.com> <20130810180322.GC4155@pd.tnic>
 <20130812083355.47c1bae8@samsung.com> <5208D80D.5030206@linux.vnet.ibm.com>
 <20130812114404.3bd64fa0@samsung.com> <520A1B5E.8040105@linux.vnet.ibm.com>
 <20130813094147.062317f8@concha.lan> <520A6A30.1030406@linux.vnet.ibm.com>
 <3908561D78D1C84285E8C5FCA982C28F31CB8DB5@ORSMSX106.amr.corp.intel.com>
 <520B603E.3040002@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.19; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t/hYN0JsjxBBhveiFi0nfjNZrGkKcPi
	84Z/bBYf+q4xWSzf189ocXnXHDaLs/OOs1ncb3nKbtG/sJfJYl/HAyaLNxfusThwe3xv7WPx
	aNl3i91jwaZSj13bdjJ5LN7zksnjwaHNLB7v911l83i0uIXR4/MmuQDOKC6blNSczLLUIn27
	BK6MHR9Xsxc8lao4c/c1SwPjf5EuRk4OCQETicfTXrBB2GISF+6tB7K5OIQEljBKvF/+kB3C
	aWCSmHVrGiNIFYuAqsST+91gHWwCRhKvGltYQWwRAVOJIyuuM4E0MAtcZ5Y4snErO0hCWCBM
	Ys+eZiYQm1fAQGL/vGVgNidQ8+GnX1ghNuxgkdh+5i3QVA6gO5wktk71hagXlPgx+R4LiM0s
	oCWxeVsTK4QtL7F5zVvmCYwCs5CUzUJSNgtJ2QJG5lWMoqXFyQXFSem5RnrFibnFpXnpesn5
	uZsYIVFTvIPxxQarQ4wCHIxKPLwbOriDhFgTy4orcw8xSnAwK4nwngEJ8aYkVlalFuXHF5Xm
	pBYfYmTi4JRqYJzyaHErf8n8C/9au8333t39v3/veq6bv7dZ+7I8VVka0mF+z7HLXyH9iqf5
	wmV2SjJMn/Nvnm6MCdN9Ze9a9+bi9lQx+cJvM8WEfeV5fk7LWvsn7sin/59cjN99UP+4r2Lm
	+odX14Zn1WlVNHC9Xa1fcq2iPv5nyg6uLfvlbngmRH7V2WgsXarEUpyRaKjFXFScCAAmowij
	eAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, 14 Aug 2013 16:17:26 +0530
"Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com> escreveu:

> On 08/13/2013 11:09 PM, Luck, Tony wrote:
> >> In the meantime, like Boris suggests, I think we can have a different
> >> trace event for raw APEI reports - userspace can use it as it pleases.
> >>
> >> Once ghes_edac gets better, users can decide whether they want raw APEI
> >> reports or the EDAC-processed version and choose one or the other trace
> >> event.
> >
> > It's cheap to add as many tracepoints as we like - but may be costly to maintain.
> > Especially if we have to tinker with them later to adjust which things are logged,
> > that puts a burden on user-space tools to be updated to adapt to the changing
> > API.
> 
> Agree. And this is the reason I have been considering mc_event. But, the 
> below issues with ghes_edac made me unsure:
> - One, the logging format for APEI data is a bit verbose and hard to 
> parse. But, I suppose we could work with this if we make a few changes. 
> Is it ok to change how the APEI data is made available through 
> mc_event->driver_detail?

Well, as userspace currently only stores it, doing a few changes at
driver_detail is likely safe, but we need to know what do you intend to do.

> - Two, if ghes_edac is enabled, it prevents other edac drivers from 
> being loaded. It looks like the assumption here is that if ghes/firmware 
> first is enabled, then *all* memory errors are reported through ghes 
> which is not true. We could have (a subset of) corrected errors reported 
> through ghes, some through CMCI and uncorrected errors through MCE. So, 
> if I'm not mistaken, if ghes_edac is enabled, we will only receive ghes 
> error events through mc_event and not the others. Mauro, is this accurate?

Yes, that's the current assumption. It prevents to have both BIOS and a
direct-hardware-access-EDAC-driver to race, as this is known to have
serious issues.

Btw, that's basically the reason why EDAC core should be compiled builtin,
as we need to reserve resources for APEI/GHES before having a chance to
register another EDAC driver.

The current logic doesn't affect error reports via MCE, although I think
we should also try to mask it at kernel, as it is easier to avoid event
duplication in Kernelspace than in userspace (at least for some cases).

We may try to implement a fine graining type of resource locking. Feel free
to propose patches for it.

> 
> >
> > Mauro has written his user-space tool to process the ghes-edac events:
> >    git://git.fedorahosted.org/rasdaemon.git
> >
> > Who is writing the user space tools to process the new apei tracepoints
> > you want to add?
> 
> Enabling rasdaemon itself for the new tracepoint is an option, as long 
> as Mauro doesn't object to it ;)

I don't object to add new tracepoint events there, but I want to prevent
duplicate reports for the very same error. One thing is to have a single
memory corrected error. The other thing is to have a burst of errors at the
same DIMM. If the very same error starts to appear 2, 3, 4 times, then
userspace may take the wrong decision of replacing a good memory just
because of a single random error there.

> 
> >
> > I'm not opposed to these patches - just wondering who is taking the next step
> > to make them useful.
> 
> Sure.
> 
> 
> Regards,
> Naveen
> 


-- 

Cheers,
Mauro
