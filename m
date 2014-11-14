Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161835AbaKNSva (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 13:51:30 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:27944 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161184AbaKNSv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 13:51:27 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+1wmBe9ZAUG0TgkVxqkakV
Date: Fri, 14 Nov 2014 10:50:49 -0800
From: Tony Lindgren <tony@atomide.com>
To: Vignesh R <vigneshr@ti.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH v2 0/3] Add support for ADC on am437x-gp and
 am43x-epos-evm
Message-ID: <20141114185049.GB7046@atomide.com>
References: <1415099728-10959-1-git-send-email-vigneshr@ti.com>
 <54657FFA.1070200@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54657FFA.1070200@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vignesh R <vigneshr@ti.com> [141113 20:09]:
> 
> On Tuesday 04 November 2014 04:45 PM, Vignesh R wrote:
> > This series of patches enable ADC on am437x-gp-evm and am43x-epos-evm.
> > The ADC clock hwmod data of am33xx has been moved to commom place so that
> > both am43xx and am33xx can reuse them.
> > tscadc DT node has been adided to am437x-gp and am43x-epos dt files.
> > With these patches, ADC functionalities are now available on am43xx.
> > 
> > Changelog:
> > 
> > v2:
> > Removed phy addresses in hwmod. Using DT instead.
> > Removed unused "ti,am4372" compatible string.
> > Use macro to set clk domain name.
> > Fixed subject format of all patches
> > 
> 
> Please accept these patches.

Adding Paul to Cc, I don't think Paul has seen these, probably because
get_maintainer.pl did not catch these hwmod files?

Regards,

Tony
 
> > Vignesh R (3):
> >   ARM: OMAP2+: hwmod: AM335x/AM43x: Move am33xx_l4_hs_hwmod to
> >     ipblock_data
> >   ARM: OMAP2+: hwmod: AM335x/AM43x: add hwmod support for tscadc on
> >     am43x-evm
> >   ARM: dts: AM43xx: add tscadc DT entries for am437x-evm and
> >     am43x-epos-evm
> > 
> >  arch/arm/boot/dts/am4372.dtsi                      | 20 ++++++
> >  arch/arm/boot/dts/am437x-gp-evm.dts                |  8 +++
> >  arch/arm/boot/dts/am43x-epos-evm.dts               |  8 +++
> >  .../mach-omap2/omap_hwmod_33xx_43xx_common_data.h  |  2 +
> >  .../mach-omap2/omap_hwmod_33xx_43xx_ipblock_data.c | 71 ++++++++++++++++++++++
> >  arch/arm/mach-omap2/omap_hwmod_33xx_data.c         | 64 -------------------
> >  arch/arm/mach-omap2/omap_hwmod_43xx_data.c         |  1 +
> >  7 files changed, 110 insertions(+), 64 deletions(-)
> > 
