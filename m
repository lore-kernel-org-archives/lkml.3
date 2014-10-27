Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020AbaJ0AYT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 20:24:19 -0400
Received: from gloria.sntech.de ([95.129.55.99]:44965 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754AbaJ0AYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 20:24:16 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "moderated list:ARM/Rockchip SoC..." 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: rockchip: use internal pull-up resistors on I2C busses
Date: Mon, 27 Oct 2014 01:27:15 +0100
Message-ID: <8843018.dv9ckEkBvo@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1413556830-27854-1-git-send-email-julien.chauveau@neo-technologies.fr>
References: <1413556830-27854-1-git-send-email-julien.chauveau@neo-technologies.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julien,

Am Freitag, 17. Oktober 2014, 16:40:30 schrieb Julien CHAUVEAU:
> According to the I2C bus specification, it is required to use pull-up
> resistors on the clock and data lines. Probing the I2C busses with
> i2cdetect results in bad results when no devices are connected and no
> external resistors are used.
> 
> This patch configures the I2C busses to use the internal pull-up resistors
> on the RK3066, RK3188 and RK3288 Rockchip processors. It should also be
> noted that these default pull settings match the original configuration on
> these SoCs.
> 
> Below is the results of using i2cdetect on a I2C bus with no devices
> connected before (1) and after (2) applying this patch.
> 
> (1) root@localhost:~# i2cdetect 3
> 
> WARNING! This program can confuse your I2C bus, cause data loss and worse!
> I will probe file /dev/i2c-3.
> I will probe address range 0x03-0x77.
> Continue? [Y/n]
>      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
> 00:          03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f
> 10: 10 11 12 13 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f
> 20: 20 21 22 23 24 25 26 27 28 29 2a 2b 2c 2d 2e 2f
> 30: -- -- -- -- -- rk3x-i2c 2005a000.i2c: timeout, ipd: 0x81, state: 2
> -- rk3x-i2c 2005a000.i2c: timeout, ipd: 0x80, state: 2
> -- rk3x-i2c 2005a000.i2c: timeout, ipd: 0x80, state: 2
> -- rk3x-i2c 2005a000.i2c: timeout, ipd: 0x80, state: 3
> -- rk3x-i2c 2005a000.i2c: timeout, ipd: 0x80, state: 3
> -- rk3x-i2c 2005a000.i2c: timeout, ipd: 0x80, state: 3
> -- rk3x-i2c 2005a000.i2c: timeout, ipd: 0x80, state: 3
> ...
> 
> (2) root@localhost:~# i2cdetect 3
> 
> WARNING! This program can confuse your I2C bus, cause data loss and worse!
> I will probe file /dev/i2c-3.
> I will probe address range 0x03-0x77.
> Continue? [Y/n]
>      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
> 00:          -- -- -- -- -- -- -- -- -- -- -- -- --
> 10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
> 20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
> 30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
> 40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
> 50: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
> 60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
> 70: -- -- -- -- -- -- -- --
> 
> Signed-off-by: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
> ---
>  arch/arm/boot/dts/rk3066a.dtsi | 20 ++++++++++----------
>  arch/arm/boot/dts/rk3188.dtsi  | 20 ++++++++++----------
>  arch/arm/boot/dts/rk3288.dtsi  | 24 ++++++++++++------------
>  3 files changed, 32 insertions(+), 32 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/rk3066a.dtsi b/arch/arm/boot/dts/rk3066a.dtsi
> index ad9c2db..c5cdf55 100644
> --- a/arch/arm/boot/dts/rk3066a.dtsi
> +++ b/arch/arm/boot/dts/rk3066a.dtsi
> @@ -202,36 +202,36 @@
> 
>  		i2c0 {
>  			i2c0_xfer: i2c0-xfer {
> -				rockchip,pins = <RK_GPIO2 28 RK_FUNC_1 &pcfg_pull_none>,
> -						<RK_GPIO2 29 RK_FUNC_1 &pcfg_pull_none>;
> +				rockchip,pins = <RK_GPIO2 28 RK_FUNC_1 &pcfg_pull_up>,
> +						<RK_GPIO2 29 RK_FUNC_1 &pcfg_pull_up>;

The rk3066a does not support distinguishing between up and down pulls. On it 
only &pcfg_pull_default is possible that configures the pull to a pin-specific 
pull direction. For the i2c pins the direction is (of course) "up".



Heiko

