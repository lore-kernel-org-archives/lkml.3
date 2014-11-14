Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161638AbaKNSHY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 13:07:24 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:40483 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161175AbaKNSHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 13:07:22 -0500
Date: Fri, 14 Nov 2014 18:07:07 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Felipe Balbi <balbi@ti.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, devicetree@vger.kernel.org,
        ulf.hansson@linaro.org, tony@atomide.com, linux-mmc@vger.kernel.org,
        afenkart@gmail.com, nsekhar@ti.com, chris@printf.net,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 2/3] mmc: omap_hsmmc: add tuning support
Message-ID: <20141114180707.GC4047@n2100.arm.linux.org.uk>
References: <1415883379-19654-1-git-send-email-kishon@ti.com>
 <1415883379-19654-3-git-send-email-kishon@ti.com>
 <20141114174152.GM11538@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141114174152.GM11538@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 11:41:52AM -0600, Felipe Balbi wrote:
> Hi,
> 
> On Thu, Nov 13, 2014 at 06:26:18PM +0530, Kishon Vijay Abraham I wrote:
> > @@ -233,6 +263,48 @@ struct omap_mmc_of_data {
> >  	u8 controller_flags;
> >  };
> >  
> > +static const u32 ref_tuning_4bits[] = {
> > +	0x00FF0FFF, 0xCCC3CCFF, 0xFFCC3CC3, 0xEFFEFFFE,
> > +	0xDDFFDFFF, 0xFBFFFBFF, 0xFF7FFFBF, 0xEFBDF777,
> > +	0xF0FFF0FF, 0x3CCCFC0F, 0xCFCC33CC, 0xEEFFEFFF,
> > +	0xFDFFFDFF, 0xFFBFFFDF, 0xFFF7FFBB, 0xDE7B7FF7
> > +};
> > +
> > +static const u32 ref_tuning_8bits[] = {
> > +	0xFF00FFFF, 0x0000FFFF, 0xCCCCFFFF, 0xCCCC33CC,
> > +	0xCC3333CC, 0xFFFFCCCC, 0xFFFFEEFF, 0xFFEEEEFF,
> > +	0xFFDDFFFF, 0xDDDDFFFF, 0xBBFFFFFF, 0xBBFFFFFF,
> > +	0xFFFFFFBB, 0XFFFFFF77, 0x77FF7777, 0xFFEEDDBB,
> > +	0x00FFFFFF, 0x00FFFFFF, 0xCCFFFF00, 0xCC33CCCC,
> > +	0x3333CCCC, 0xFFCCCCCC, 0xFFEEFFFF, 0xEEEEFFFF,
> > +	0xDDFFFFFF, 0xDDFFFFFF, 0xFFFFFFDD, 0XFFFFFFBB,
> > +	0xFFFFBBBB, 0xFFFF77FF, 0xFF7777FF, 0xEEDDBB77
> > +};
> 
> yet another feature we would've gotten for free if we were already using
> sdhci. This is just a copy of what's on sdhci-msm.c, probably because
> they license the same IP we do.
> 
> It would be much better to just convert omap-hsmmc.c into sdhci-omap.c
> much like it was done for 8250-omap.c, with the added benefit that this
> will incur no userland regressions due to devnode names.

If someone does do that, sdhci needs more of the quirks killing - sdhci.c
/really/ needs to become a library which all these drivers use, rather
than interposing itself between the MMC core and the actual driver, and
the more that can be done the better.  All the time that people expand
on the current disaster, that job is just going to get harder and harder
(because there'll be more and more sub-drivers, with more and more
sub-driver specific quirks.)

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
