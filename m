Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbbAFRom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 12:44:42 -0500
Received: from gloria.sntech.de ([95.129.55.99]:52101 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755513AbbAFRok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 12:44:40 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Doug Anderson <dianders@chromium.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>, Mark Brown <broonie@kernel.org>,
        Alexandru Stan <amstan@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] ARM: dts: Specify VMMC and VQMMC on rk3288-evb
Date: Tue, 06 Jan 2015 18:44:13 +0100
Message-ID: <1798568.RumoICfKOO@phil>
User-Agent: KMail/4.14.2 (Linux/3.16-3-amd64; KDE/4.14.1; x86_64; ; )
In-Reply-To: <1418689340-29517-3-git-send-email-dianders@chromium.org>
References: <1418689340-29517-1-git-send-email-dianders@chromium.org> <1418689340-29517-3-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

Am Montag, 15. Dezember 2014, 16:22:20 schrieb Doug Anderson:
> Specifying these rails should eventually let us do UHS.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
> Changes in v3: None
> Changes in v2:
> - Fix subject line
> 
>  arch/arm/boot/dts/rk3288-evb.dtsi | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/rk3288-evb.dtsi
> b/arch/arm/boot/dts/rk3288-evb.dtsi index 3e067dd..d660fe6 100644
> --- a/arch/arm/boot/dts/rk3288-evb.dtsi
> +++ b/arch/arm/boot/dts/rk3288-evb.dtsi
> @@ -114,6 +114,8 @@
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&sdmmc_clk &sdmmc_cmd &sdmmc_cd &sdmmc_bus4>;
>  	status = "okay";
> +	vmmc-supply = <&vcc_io>;

according to the schematics there is a switch between the card and vcc_io with 
a controlling pin called SDMMC_PWR providing a supply called vcc_sd.

So there should probably be a fixed-regulator get introduced for this, like the 
older rockchip boards do.


Heiko
