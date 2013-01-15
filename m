Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab3AOMdw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 07:33:52 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:40214 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750777Ab3AOMdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 07:33:51 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19IjsZCP3t0fXxS21NXFxTNEG9f7sPsLPo=
Date: Tue, 15 Jan 2013 07:33:07 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Stefan Peter <s.peter@mpl.ch>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, andrew@lunn.ch, dwmw2@infradead.org,
        jm@lentin.co.uk, arnd@arndb.de, sebastian.hesselbarth@googlemail.com,
        iwamatsu@nigauri.org, artem.bityutskiy@linux.intel.com,
        wfp5p@virginia.edu, gregkh@linuxfoundation.org,
        broonie@opensource.wolfsonmicro.com, mchehab@redhat.com,
        nico@linaro.org
Subject: Re: [PATCH 3/4] Enable ecc-mode selection in the driver
Message-ID: <20130115123307.GA13433@titan.lakedaemon.net>
References: <cover.1358242644.git.s.peter@mpl.ch>
 <2d08c4c072fd4922a6056362adb96a455307d583.1358242644.git.s.peter@mpl.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d08c4c072fd4922a6056362adb96a455307d583.1358242644.git.s.peter@mpl.ch>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan,

This is a good-looking patch series, nice and small!  A few comments:

On Tue, Jan 15, 2013 at 01:13:12PM +0100, Stefan Peter wrote:
> In order to be able to use the ecc-mode, add the bch module to the default
> settings for the kirwood boards and enable the activation in orin-nand.c

s/orin-nand/orion-nand/

> 
> Signed-off-by: Stefan Peter <s.peter@mpl.ch>
> ---
> diff --git a/arch/arm/configs/kirkwood_defconfig b/arch/arm/configs/kirkwood_defconfig
> index 93f3794..4a9d3f7 100644
> --- a/arch/arm/configs/kirkwood_defconfig
> +++ b/arch/arm/configs/kirkwood_defconfig
> @@ -84,6 +84,7 @@ CONFIG_MTD_CFI_STAA=y
>  CONFIG_MTD_PHYSMAP=y
>  CONFIG_MTD_M25P80=y
>  CONFIG_MTD_NAND=y
> +CONFIG_MTD_NAND_ECC_BCH=y
>  CONFIG_MTD_NAND_ORION=y
>  CONFIG_BLK_DEV_LOOP=y
>  # CONFIG_SCSI_PROC_FS is not set

Please make the defconfig change a separate patch.

As a general note (this series shouldn't be a problem), please sort the
series so that you add the driver feature first, then enable it in
defconfig, then use it in DT.  This way, a future bisection won't run
into any nasty surprises, other than what they're looking for. ;-)

thx,

Jason.
