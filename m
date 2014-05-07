Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbaEGSDp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 14:03:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:7669 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900AbaEGSDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 14:03:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1004,1389772800"; 
   d="scan'208";a="536539854"
Date: Wed, 7 May 2014 10:52:08 -0700
From: "David E. Box" <david.e.box@linux.intel.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, rafael.j.wysocki@intel.com,
        linux-kernel@vger.kernel.org, kristen.c.accardi@intel.com,
        jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH v3] x86/iosf: Make IOSF driver modular and usable by more
 drivers
Message-ID: <20140507175208.GA9534@linux.intel.com>
References: <1398810789-2301-1-git-send-email-david.e.box@linux.intel.com>
 <1399052199-8703-1-git-send-email-david.e.box@linux.intel.com>
 <20140507174801.20fc0d67@alan.etchedpixels.co.uk>
 <536A67B8.1080805@zytor.com>
 <20140507181042.7b4dff18@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140507181042.7b4dff18@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 06:10:42PM +0100, One Thousand Gnomes wrote:
> On Wed, 07 May 2014 10:04:56 -0700
> "H. Peter Anvin" <hpa@zytor.com> wrote:
> 
> > On 05/07/2014 09:48 AM, One Thousand Gnomes wrote:
> > > On Fri,  2 May 2014 10:36:39 -0700
> > >> +bool iosf_mbi_available(void)
> > >> +{
> > >> +	return mbi_pdev;
> > >> +}
> > >> +EXPORT_SYMBOL(iosf_mbi_available);
> > > 
> > > Probably worth a follow up patch that comments this so the assumption
> > > that iosf can never be unloaded or hot-unplugged is clear.
> > > 
> > 
> > When you say unloaded you mean the module or the hardware?
> 
> Both. Currently the hardware isn't removable (but could be virtually
> removed by playing with unplugging) and the module can't be unloaded so
> the assumption is fine.
>

Actually it can be explictly unloaded with rmmod, something I left in while
testing use of the driver on non-iosf systems.

Speaking of non-iosf systems (Core/Xeon), having the iosf driver configured as
default m will cause it to be loaded on non-iosf systems by drivers that work
on both. Not a huge problem. I already tested that attempts to use the driver
result in proper warnings with ill affect to those systems. But it is a waste of
memory. I looked at doing a probe and unload in module_init but that would
cause these drivers, like RAPL for example, to fail due to the missing iosf
symbols, which the driver would still be looking for because default m means
that CONFIG_IOSF is always true so they aren't compiled out out in exchange for
the dummy ones.

Imo, this stems from not exposing the iosf in Kconfig. I understand the
reasoning but maybe there should be a separate Kconfig option that is exposed
indicating that the hardware is an x86 SOC. The iosf could have just depended on
that, avoiding this situation.

Dave Box 
