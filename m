Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbaIKJSM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 05:18:12 -0400
Received: from regular1.263xmail.com ([211.150.99.140]:52240 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaIKJSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 05:18:09 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: addy.ke@rock-chips.com
X-FST-TO: dianders@chromium.org
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: addy.ke@rock-chips.com
X-UNIQUE-TAG: <c124a94f587fd6607670d1a88cb3bf20>
X-DNS-TYPE: 0
Message-ID: <541168C6.2090603@rock-chips.com>
Date: Thu, 11 Sep 2014 17:17:58 +0800
From: Addy <addy.ke@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>, Heiko Stuebner <heiko@sntech.de>
CC: Chris Zhong <zyw@rock-chips.com>, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: Switch i2c0 to 400kHz on rk3288-evb-rk808
References: <1410409815-22200-1-git-send-email-dianders@chromium.org>
In-Reply-To: <1410409815-22200-1-git-send-email-dianders@chromium.org>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11 Sep 2014 12:30, Doug Anderson writes:
> We should be able to talk to the PMIC at 400kHz.  No need to talk at
> the slow 100kHz.
>
> As measured by ftrace (with a bunch of extra patches, since cpufreq
> for rk808 hasn't landed yet):
>   before this change: cpu0_set_target() => ~500us
>   after this change:  cpu0_set_target() => ~300us
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  arch/arm/boot/dts/rk3288-evb-rk808.dts | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm/boot/dts/rk3288-evb-rk808.dts b/arch/arm/boot/dts/rk3288-evb-rk808.dts
> index 36db177..ff522f8 100644
> --- a/arch/arm/boot/dts/rk3288-evb-rk808.dts
> +++ b/arch/arm/boot/dts/rk3288-evb-rk808.dts
> @@ -18,6 +18,7 @@
>  };
>  
>  &i2c0 {
> +	clock-frequency = <400000>;
>  	status = "okay";
>  
>  	rk808: pmic@1b {
I have tested on rk3288-pinky board, it work well. so

Reviewed-by Addy Ke <addy.ke@rock-chips.com>
Tested-by Addy Ke <addy.ke@rock-chips.com>


