Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935172Ab3FSVlz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 17:41:55 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50532 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934987Ab3FSVlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 17:41:53 -0400
Date: Wed, 19 Jun 2013 23:41:45 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "ananth@in.ibm.com" <ananth@in.ibm.com>,
        "masbock@linux.vnet.ibm.com" <masbock@linux.vnet.ibm.com>,
        "lcm@linux.vnet.ibm.com" <lcm@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Robert Richter <rric@kernel.org>
Subject: Re: [PATCH v2 2/2] mce: acpi/apei: Add a boot option to disable ff
 mode for corrected errors
Message-ID: <20130619214145.GS28300@pd.tnic>
References: <20130619175438.2852.93449.stgit@localhost.localdomain>
 <20130619175728.2852.73156.stgit@localhost.localdomain>
 <20130619180441.GK28300@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F2DA88106@ORSMSX106.amr.corp.intel.com>
 <20130619183640.GL28300@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F2DA881C2@ORSMSX106.amr.corp.intel.com>
 <20130619201438.GM28300@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F2DA8838B@ORSMSX106.amr.corp.intel.com>
 <20130619210706.GP28300@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F2DA884F0@ORSMSX106.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F2DA884F0@ORSMSX106.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 09:28:50PM +0000, Luck, Tony wrote:
> > Ok, where is that semantics? What in a CPER record does say "this error
> > should tell you that you need to offline the containing page and I'm
> > telling you this exactly only once"? Error Severity 0, i.e. Recoverable?
> 
> Naveen - this one is for you (or for your BIOS team).  Can you get us a sample
> CPER that you plan to provide when the BIOS decides that its threshold has
> been exceeded?  How will it be different from what old WSM-EX platforms
> were sending to us?  Hopefully the answer is encoded in the CPER record
> and not in some code we have to put in Linux to say "if (IBMplatform) do_thing_1(); else ... "

If we're going to be vendor-specific (which I'm pretty sure we will),
we'd gonna have to export knobs to userspace which each vendor can tweak
for themselves. Otherwise we'd get the DMI quirks ugliness all over
again and we better nip it in the bud, while we can.

> > Ok, we're talking about the S in RAS now. Do we have error recovery
> > strategies specified anywhere? Are they per-platform or generic? Is this
> > CPER strategy above, for example, only valid for some platforms or for
> > all APEI-using hardware?
> 
> mcelog(8) daemon has been doing this for years ... but it used the "predictive
> failure analysis" buzzwords that were popular way back then (today the
> marketing people seem to prefer "self healing" ). Whatever the name, the
> concept is the same ... take some set of corrected event reports and infer
> from them that something worse may happen soon, and use that information
> to try to avoid the (possibly) impending crash.

Ok, so some sort of userspace is enforcing policy based on collected
data/heuristics.

The above question about what to do *without* going to userspace and
back is maybe more interesting and we'd need a clean design there...
we'll see.

> > Questions over questions...
> 
> Questions are good - they help fill out gaps

I know - that's why I'm trying to poke holes early...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
