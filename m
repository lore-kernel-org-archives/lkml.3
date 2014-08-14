Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbaHNB5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 21:57:31 -0400
Received: from regular1.263xmail.com ([211.150.99.137]:38064 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbaHNB53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 21:57:29 -0400
X-263anti-spam: BIG:0;KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 1
X-KSVirus-check: 0
X-RL-SENDER: addy.ke@rock-chips.com
X-FST-TO: dianders@chromium.org
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: addy.ke@rock-chips.com
X-UNIQUE-TAG: <f404ab8a33624a60438d2279ab4a694e>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <53EC177B.1080706@rock-chips.com>
Date: Thu, 14 Aug 2014 09:57:15 +0800
From: Addy <addy.ke@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>, Heiko Stuebner <heiko@sntech.de>,
        Sonny Rao <sonnyrao@chromium.org>
CC: stefan@agner.ch, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: Add mmc0 and mmc1 aliases for rk3288
References: <1407974880-30626-1-git-send-email-dianders@chromium.org>
In-Reply-To: <1407974880-30626-1-git-send-email-dianders@chromium.org>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> It's convenient (and less confusing to people reading logs) if the
> eMMC port on rk3288 is consistenly marked with mmc0 and the sdmmc port
> on rk3288 is consistently marked with mmc1.  Add the appropriate
> aliases.
>
> These aliases only actually do something if a patch like
> (https://patchwork.kernel.org/patch/3925551/) lands, but they don't
> hurt even before that patch.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Reviewed-by: Sonny Rao <sonnyrao@chromium.org>
> ---
>  arch/arm/boot/dts/rk3288.dtsi | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
> index 36be7bb..0b54b0d 100644
> --- a/arch/arm/boot/dts/rk3288.dtsi
> +++ b/arch/arm/boot/dts/rk3288.dtsi
> @@ -29,6 +29,8 @@
>  		i2c3 = &i2c3;
>  		i2c4 = &i2c4;
>  		i2c5 = &i2c5;
> +		mmc0 = &emmc;
> +		mmc1 = &sdmmc;
There are 8 registers can be configured for clock tunning(see chapter 3,
page 133):
sdmmc: CRU_SDMMC_CON0(offset: 0x200)
CRU_SDMMC_CON1(offset: 0x204)
sdio0: CRU_SDMMC_CON2(offset: 0x208)
CRU_SDMMC_CON3(offset: 0x20c)
sdio1: CRU_SDMMC_CON4(offset: 0x210)
CRU_SDMMC_CON5(offset: 0x214)
emmc: CRU_SDMMC_CON6(offset: 0x218)
CRU_SDMMC_CON7(offset: 0x21c)

I think maybe it is suitable as follows:
mmc0 = &sdmmc
mmc1 = &sdio0
mmc2 = &sdio1
mmc3 = &emmc

So we can get ctrl_id:
ctrl_id = of_alias_get_id(host->dev->of_node, "mshc");

and can get offset of registers:
offset = 0x200 + ctrl_id * 8 + 4 * drive_or_sample

>  		serial0 = &uart0;
>  		serial1 = &uart1;
>  		serial2 = &uart2;


