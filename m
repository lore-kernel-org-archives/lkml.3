Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbaHSSht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 14:37:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58608 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576AbaHSShs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 14:37:48 -0400
Message-ID: <53F39978.3080901@suse.de>
Date: Tue, 19 Aug 2014 20:37:44 +0200
From: =?ISO-8859-15?Q?Andreas_F=E4rber?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
CC: Kukjin Kim <kgene.kim@samsung.com>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>, Mark Brown <broonie@kernel.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] ARM: dts: Add vmmc and vqmmc supplies for Peach Pit
 and Pi boards
References: <1408460913-13863-1-git-send-email-javier.martinez@collabora.co.uk> <1408460913-13863-6-git-send-email-javier.martinez@collabora.co.uk>
In-Reply-To: <1408460913-13863-6-git-send-email-javier.martinez@collabora.co.uk>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Javier,

Am 19.08.2014 17:08, schrieb Javier Martinez Canillas:
> diff --git a/arch/arm/boot/dts/exynos5420-peach-pit.dts b/arch/arm/boot/dts/exynos5420-peach-pit.dts
> index 8e50042..5b9dbb9 100644
> --- a/arch/arm/boot/dts/exynos5420-peach-pit.dts
> +++ b/arch/arm/boot/dts/exynos5420-peach-pit.dts
> @@ -547,6 +547,8 @@
>  };
>  
>  &mmc_2 {
> +	vmmc-supply = <&tps65090_fet4>;
> +	vqmmc-supply = <&vqmmc_sdcard>;
>  	status = "okay";
>  	num-slots = <1>;
>  	supports-highspeed;
> diff --git a/arch/arm/boot/dts/exynos5800-peach-pi.dts b/arch/arm/boot/dts/exynos5800-peach-pi.dts
> index 939f91c..dcac443 100644
> --- a/arch/arm/boot/dts/exynos5800-peach-pi.dts
> +++ b/arch/arm/boot/dts/exynos5800-peach-pi.dts
> @@ -545,6 +545,8 @@
>  };
>  
>  &mmc_2 {
> +	vmmc-supply = <&tps65090_fet4>;
> +	vqmmc-supply = <&vqmmc_sdcard>;
>  	status = "okay";
>  	num-slots = <1>;
>  	supports-highspeed;

A convention that I picked up was to place overridden status property
first. Do your new properties really need to go before that?

Also, if you look at today's for-next, then supports-highspeed should be
cap-{sd,mmc}-highspeed, so it may be worth to rebase.

Regards,
Andreas

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
