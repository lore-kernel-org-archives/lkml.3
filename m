Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935241Ab3FSVHR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 17:07:17 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53531 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935060Ab3FSVHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 17:07:15 -0400
Date: Wed, 19 Jun 2013 23:07:06 +0200
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
Message-ID: <20130619210706.GP28300@pd.tnic>
References: <20130619175438.2852.93449.stgit@localhost.localdomain>
 <20130619175728.2852.73156.stgit@localhost.localdomain>
 <20130619180441.GK28300@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F2DA88106@ORSMSX106.amr.corp.intel.com>
 <20130619183640.GL28300@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F2DA881C2@ORSMSX106.amr.corp.intel.com>
 <20130619201438.GM28300@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F2DA8838B@ORSMSX106.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F2DA8838B@ORSMSX106.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 08:33:49PM +0000, Luck, Tony wrote:
> >> There is (or should be)
> >
> > Ha!
> 
> Oh ye of little faith - I'm sure the BIOS will get this right this time :-)
> 
> 
> > Ok, seriously: so the situation should still be fine, FF reported errors
> > get the CPER format while the rest, the "old" MCE format.
> >
> > cper.c is doing printk so I'm guessing it would need to get its own
> > tracepoint and carry that to userspace.
> 
> Yes - a tracepoint is the right answer here for all the new stuff.
> 
> > Concerning the RAS daemon, Robert and I are making good progress so once
> > we have the persistent events in perf, we can read that tracepoint in
> > userspace and do whatever we want with the error info.
> 
> Mauro has a rasdaemon in progress
>        git://git.fedorahosted.org/rasdaemon.git
> just picks up perf/events and logs to a sqlite database.

Actually it uses ftrace's facilities but it is a tracepoint in the end.

And I asked him nicely not to call it rasdaemon because I already have a
RAS daemon but hey, whatever. The more confusion, the better.

> Because Linux can do runtime things that the BIOS can't - like offline
> a 4K page. Idea here is that BIOS does whatever the OEM thinks is the
> right level of threshholding - not bothering the OS with petty details
> of random corrected erorrs that mean nothing. But if there is some
> repeated error (like a stuck bit) then the BIOS can provide a CPER
> to the OS telling it that it would be a good idea to stop using that
> page.

Ok, where is that semantics? What in a CPER record does say "this error
should tell you that you need to offline the containing page and I'm
telling you this exactly only once"? Error Severity 0, i.e. Recoverable?

> And this is where the semantics of a CPER change between the original
> WSM-EX implementation ... where Linux expects to see all the errors
> and do its own thresholding only taking a page offline if it sees a
> lot of CPER refer to the same page; and now - where the BIOS does the
> counting and tells Linux just once to take the page offline.

Ok, we're talking about the S in RAS now. Do we have error recovery
strategies specified anywhere? Are they per-platform or generic? Is this
CPER strategy above, for example, only valid for some platforms or for
all APEI-using hardware?

Questions over questions...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
