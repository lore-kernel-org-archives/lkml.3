Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274AbbAMBHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 20:07:41 -0500
Received: from vps0.lunn.ch ([178.209.37.122]:50917 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275AbbAMBHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 20:07:39 -0500
Date: Tue, 13 Jan 2015 02:05:38 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jason Cooper <jason@lakedaemon.net>, gregory.clement@free-electrons.com,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Evgeni Dobrev <evgeni@studio-punkt.com>,
        Peter Robinson <pbrobinson@gmail.com>
Subject: Re: linux-next: manual merge of the mvebu tree with the arm-soc tree
Message-ID: <20150113010538.GA2434@lunn.ch>
References: <20150113112016.2db3f982@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150113112016.2db3f982@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 11:20:16AM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the mvebu tree got a conflict in
> arch/arm/boot/dts/Makefile between commit 6f1650f15bc4 ("ARM: dts: Only
> build dtb if associated Arch and/or SoC is enabled") from the arm-soc
> tree and commit dd7d2be1d2b8 ("Kirkwood: add support for Seagate
> BlackArmor NAS220") from the mvebu tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc arch/arm/boot/dts/Makefile
> index abb810f1fe29,17ee1d6a0ac0..000000000000
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@@ -112,24 -101,18 +112,25 @@@ dtb-$(CONFIG_ARCH_EXYNOS5) += 
>   	exynos5440-sd5v1.dtb \
>   	exynos5440-ssdk5440.dtb \
>   	exynos5800-peach-pi.dtb
>  -dtb-$(CONFIG_ARCH_HI3xxx) += hi3620-hi4511.dtb
>  -dtb-$(CONFIG_ARCH_HIX5HD2) += hisi-x5hd2-dkb.dtb
>  -dtb-$(CONFIG_ARCH_HIGHBANK) += highbank.dtb \
>  +dtb-$(CONFIG_ARCH_HI3xxx) += \
>  +	hi3620-hi4511.dtb
>  +dtb-$(CONFIG_ARCH_HIX5HD2) += \
>  +	hisi-x5hd2-dkb.dtb
>  +dtb-$(CONFIG_ARCH_HIGHBANK) += \
>  +	highbank.dtb \
>   	ecx-2000.dtb
>  -dtb-$(CONFIG_ARCH_HIP04) += hip04-d01.dtb
>  -dtb-$(CONFIG_ARCH_INTEGRATOR) += integratorap.dtb \
>  +dtb-$(CONFIG_ARCH_HIP04) += \
>  +	hip04-d01.dtb
>  +dtb-$(CONFIG_ARCH_INTEGRATOR) += \
>  +	integratorap.dtb \
>   	integratorcp.dtb
>  -dtb-$(CONFIG_ARCH_KEYSTONE) += k2hk-evm.dtb \
>  +dtb-$(CONFIG_ARCH_KEYSTONE) += \
>  +	k2hk-evm.dtb \
>   	k2l-evm.dtb \
>   	k2e-evm.dtb
>  -dtb-$(CONFIG_MACH_KIRKWOOD) += kirkwood-b3.dtb \
>  +dtb-$(CONFIG_MACH_KIRKWOOD) += \
>  +	kirkwood-b3.dtb \
> + 	kirkwood-blackarmor-nas220.dtb \
>   	kirkwood-cloudbox.dtb \
>   	kirkwood-d2net.dtb \
>   	kirkwood-db-88f6281.dtb \

Hi Stephen

Thanks for the fixup.

       Andrew
