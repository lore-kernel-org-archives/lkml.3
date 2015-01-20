Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993AbbATRjy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 12:39:54 -0500
Received: from smtp3.ore.mailhop.org ([54.149.88.251]:41971 "EHLO
	smtp3.ore.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbbATRjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 12:39:37 -0500
X-Greylist: delayed 1517 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Jan 2015 12:39:37 EST
X-Mail-Handler: DuoCircle Outbound SMTP
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@duocircle.com (see https://support.duocircle.com/support/solutions/articles/5000540958-duocircle-standard-smtp-abuse-information for abuse reporting information)
X-MHO-User: U2FsdGVkX1+M5KMPkOX8SiDlRf1j9AHZ
Date: Tue, 20 Jan 2015 09:10:49 -0800
From: Tony Lindgren <tony@atomide.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Robinson <pbrobinson@gmail.com>
Subject: Re: linux-next: manual merge of the omap tree with the arm-soc tree
Message-ID: <20150120171048.GF7718@atomide.com>
References: <20150120110947.1a92a416@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150120110947.1a92a416@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Rothwell <sfr@canb.auug.org.au> [150119 16:12]:
> Hi Tony,
> 
> Today's linux-next merge of the omap tree got a conflict in
> arch/arm/boot/dts/Makefile between commit cb612390e546 ("ARM: dts: Only
> build dtb if associated Arch and/or SoC is enabled") from the arm-soc
> tree and commit ac7452cee743 ("ARM: dts: Add minimal support for
> dm8168-evm") from the omap tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Uhh why is cb612390e546 doing formatting changes all over the place?
That's a sure way to produce merge conflicts..

Anyways the conflict resolution looks good to me thanks.

Regards,

Tony
 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc arch/arm/boot/dts/Makefile
> index a240d2d07b38,a6ace4d57ea5..000000000000
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@@ -392,8 -348,8 +392,9 @@@ dtb-$(CONFIG_ARCH_OMAP3) += 
>   	omap3-sbc-t3730.dtb \
>   	omap3-thunder.dtb \
>   	omap3-zoom3.dtb
> + dtb-$(CONFIG_SOC_TI81XX) += dm8168-evm.dtb
>  -dtb-$(CONFIG_SOC_AM33XX) += am335x-base0033.dtb \
>  +dtb-$(CONFIG_SOC_AM33XX) += \
>  +	am335x-base0033.dtb \
>   	am335x-bone.dtb \
>   	am335x-boneblack.dtb \
>   	am335x-evm.dtb \
> @@@ -410,20 -365,17 +411,21 @@@ dtb-$(CONFIG_ARCH_OMAP4) += 
>   	omap4-sdp-es23plus.dtb \
>   	omap4-var-dvk-om44.dtb \
>   	omap4-var-stk-om44.dtb
>  -dtb-$(CONFIG_SOC_AM43XX) += am43x-epos-evm.dtb \
>  +dtb-$(CONFIG_SOC_AM43XX) += \
>  +	am43x-epos-evm.dtb \
>   	am437x-sk-evm.dtb \
> + 	am437x-idk-evm.dtb \
>   	am437x-gp-evm.dtb
>  -dtb-$(CONFIG_SOC_OMAP5) += omap5-cm-t54.dtb \
>  +dtb-$(CONFIG_SOC_OMAP5) += \
>  +	omap5-cm-t54.dtb \
>   	omap5-sbc-t54.dtb \
>   	omap5-uevm.dtb
>  -dtb-$(CONFIG_SOC_DRA7XX) += dra7-evm.dtb \
>  +dtb-$(CONFIG_SOC_DRA7XX) += \
>  +	dra7-evm.dtb \
>   	am57xx-beagle-x15.dtb \
>   	dra72-evm.dtb
>  -dtb-$(CONFIG_ARCH_ORION5X) += orion5x-lacie-d2-network.dtb \
>  +dtb-$(CONFIG_ARCH_ORION5X) += \
>  +	orion5x-lacie-d2-network.dtb \
>   	orion5x-lacie-ethernet-disk-mini-v2.dtb \
>   	orion5x-maxtor-shared-storage-2.dtb \
>   	orion5x-rd88f5182-nas.dtb


