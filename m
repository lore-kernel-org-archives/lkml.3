Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663AbaIKJVz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 05:21:55 -0400
Received: from gloria.sntech.de ([95.129.55.99]:38912 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753612AbaIKJVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 05:21:52 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Doug Anderson <dianders@chromium.org>
Cc: Chris Zhong <zyw@rock-chips.com>, Addy Ke <addy.ke@rock-chips.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: Switch i2c0 to 400kHz on rk3288-evb-rk808
Date: Thu, 11 Sep 2014 11:23:47 +0200
Message-ID: <14543621.jVTOtFDFto@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1410409815-22200-1-git-send-email-dianders@chromium.org>
References: <1410409815-22200-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 10. September 2014, 21:30:15 schrieb Doug Anderson:
> We should be able to talk to the PMIC at 400kHz.  No need to talk at
> the slow 100kHz.
> 
> As measured by ftrace (with a bunch of extra patches, since cpufreq
> for rk808 hasn't landed yet):
>   before this change: cpu0_set_target() => ~500us
>   after this change:  cpu0_set_target() => ~300us
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>

looks harmless :-)

I've added it to my v3.18-next/dts branch with Addy's tags


> ---
>  arch/arm/boot/dts/rk3288-evb-rk808.dts | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/boot/dts/rk3288-evb-rk808.dts
> b/arch/arm/boot/dts/rk3288-evb-rk808.dts index 36db177..ff522f8 100644
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

