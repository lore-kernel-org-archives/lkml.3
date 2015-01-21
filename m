Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231AbbAUKmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 05:42:22 -0500
Received: from down.free-electrons.com ([37.187.137.238]:35604 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750840AbbAUKmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 05:42:13 -0500
Message-ID: <54BF827D.8090607@free-electrons.com>
Date: Wed, 21 Jan 2015 11:42:05 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Valentin Rothberg <valentinrothberg@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] ARM: mvebu: remove two selects of ARM_ERRATA_753970
References: <1421659937.9655.16.camel@x220>
In-Reply-To: <1421659937.9655.16.camel@x220>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On 19/01/2015 10:32, Paul Bolle wrote:
> ARM_ERRATA_753970 was renamed to PL310_ERRATA_753970 in v3.2, through
> commit fa0ce4035d48 ("ARM: 7162/1: errata: tidy up Kconfig options for
> PL310 errata workarounds"). Still, two selects were added in v3.15 that
> used the previous name. So these selects have always been nops.
> 
> It is clear that the intention here was to select PL310_ERRATA_753970.
> But as, apparently, nothing broke for four releases we can assume
> PL310_ERRATA_753970 isn't actually needed. So let's not rename these two
> selects but just drop them instead.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> v4: Do no bother anymore to rename these selects. I've tried to do that
> a few times ever since v3.15-rc1 was released. Last time, v3, was in
> https://lkml.org/lkml/2014/9/12/231 . And since the people who
> intruduced this issue apparently aren't bothered by it, neither should
> I. So just do the safe and easy thing, which is removing these two
> selects, as they are nops now.
> 
> Done on top of next-20150119.

I think you're right, however I am still going to ask the hardware designers
if we need PL310_ERRATA_753970.

Thanks,

Gregory


> 
>  arch/arm/mach-mvebu/Kconfig | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arch/arm/mach-mvebu/Kconfig b/arch/arm/mach-mvebu/Kconfig
> index c1e4567a5ab3..e8e5fa25121c 100644
> --- a/arch/arm/mach-mvebu/Kconfig
> +++ b/arch/arm/mach-mvebu/Kconfig
> @@ -37,7 +37,6 @@ config MACH_ARMADA_370
>  config MACH_ARMADA_375
>  	bool "Marvell Armada 375 boards" if ARCH_MULTI_V7
>  	select ARM_ERRATA_720789
> -	select ARM_ERRATA_753970
>  	select ARM_GIC
>  	select ARMADA_375_CLK
>  	select HAVE_ARM_SCU
> @@ -52,7 +51,6 @@ config MACH_ARMADA_375
>  config MACH_ARMADA_38X
>  	bool "Marvell Armada 380/385 boards" if ARCH_MULTI_V7
>  	select ARM_ERRATA_720789
> -	select ARM_ERRATA_753970
>  	select ARM_GIC
>  	select ARMADA_38X_CLK
>  	select HAVE_ARM_SCU
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
