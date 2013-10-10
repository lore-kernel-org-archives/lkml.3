Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659Ab3JJOUn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 10:20:43 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:37704 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755605Ab3JJOUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 10:20:41 -0400
Date: Thu, 10 Oct 2013 09:19:50 -0500
From: Nishanth Menon <nm@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <bcousson@baylibre.com>, <mark.rutland@arm.com>,
        <devicetree@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <pawel.moll@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <tony@atomide.com>, <swarren@wwwdotorg.org>,
        <linux-kernel@vger.kernel.org>, <rob.herring@calxeda.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] ARM: dts: omap5-uevm: remove always_on, boot_on from
 smps10_out1
Message-ID: <20131010141949.GA13277@kahuna>
References: <1381402195-29257-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1381402195-29257-1-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16:19-20131010, Kishon Vijay Abraham I wrote:
> smps10 should be enabled only in the case of host mode. So stop
> doing always_on, boot_on from smps10_out1. The driver will enable it in host
> mode.
> 
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  arch/arm/boot/dts/omap5-uevm.dts |    2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/omap5-uevm.dts b/arch/arm/boot/dts/omap5-uevm.dts
> index d784b3a..e06a04a 100644
> --- a/arch/arm/boot/dts/omap5-uevm.dts
> +++ b/arch/arm/boot/dts/omap5-uevm.dts
> @@ -334,8 +334,6 @@
>  					regulator-name = "smps10_out1";
>  					regulator-min-microvolt = <5000000>;
>  					regulator-max-microvolt = <5000000>;
> -					regulator-always-on;
> -					regulator-boot-on;
>  				};
>  
>  				ldo1_reg: ldo1 {
> -- 
Always good to get rid of regulator-always-on. Thanks for it.

regulator-boot-on indicates that PMIC enables it by default as part of
OTP or some internal behavior -> Looking at the measurements done on
uEVM and OTP information -> regulator-boot-on should be kept here.

Hence Nak.
-- 
Regards,
Nishanth Menon
