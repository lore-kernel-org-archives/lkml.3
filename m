Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933988AbaDIRv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 13:51:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:18592 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933143AbaDIRv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 13:51:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,827,1389772800"; 
   d="scan'208";a="510291837"
Date: Wed, 9 Apr 2014 10:48:54 -0700
From: David Cohen <david.a.cohen@linux.intel.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: wim@iguana.be, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk,
        Eric Ernst <eric.ernst@intel.com>
Subject: Re: [PATCH 1/2] watchdog: add Intel MID watchdog driver support
Message-ID: <20140409174854.GC23274@psi-dev26.jf.intel.com>
References: <1396990744-10695-1-git-send-email-david.a.cohen@linux.intel.com>
 <1396990744-10695-2-git-send-email-david.a.cohen@linux.intel.com>
 <53448CB4.6050705@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53448CB4.6050705@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 04:56:36PM -0700, Randy Dunlap wrote:
> On 04/08/2014 01:59 PM, David Cohen wrote:
> > Add initial Intel MID watchdog driver support.
> > 
> > This driver is an initial implementation of generic Intel MID watchdog
> > driver. Currently it supports Intel Merrifield platform.
> > 
> > Signed-off-by: Eric Ernst <eric.ernst@intel.com>
> > Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> > ---
> >  drivers/watchdog/Kconfig         |  12 +++
> >  drivers/watchdog/Makefile        |   1 +
> >  drivers/watchdog/intel-mid_wdt.c | 209 +++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 222 insertions(+)
> >  create mode 100644 drivers/watchdog/intel-mid_wdt.c
> > 
> > diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> > index 79d25894343a..4da09b8b2f11 100644
> > --- a/drivers/watchdog/Kconfig
> > +++ b/drivers/watchdog/Kconfig
> > @@ -643,6 +643,18 @@ config INTEL_SCU_WATCHDOG
> >  
> >  	  To compile this driver as a module, choose M here.
> >  
> > +config INTEL_MID_WATCHDOG
> > +	bool "Intel MID SCU Watchdog Mobile Platforms"
> > +	depends on X86_INTEL_MID && WATCHDOG_CORE
> > +	---help---
> > +	  Watchdog timer driver built into the Intel SCU for Intel MID
> > +	  Platforms.
> > +
> > +	  This driver currently supports only the watchdog evolution
> > +	  implementation in SCU, available for Merrifield generation.
> > +
> > +	  To compile this driver as a module, choose M here.
> 
> Does choosing M work when INTEL_MID_WATCHDOG is a bool?
> and why is INTEL_MID_WATCHDOG a bool?

The error here is the left over line from the template I used. There
should be no mention about choosing M.
It's bool because the watchdog is started by default on fw. We need this
driver probed during boot to pet/kick/ping asap. IMHO It makes not much
sense to compile it as module.

Br, David

> 
> > +
> >  config ITCO_WDT
> >  	tristate "Intel TCO Timer/Watchdog"
> >  	depends on (X86 || IA64) && PCI
> 
> 
> -- 
> ~Randy
