Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231AbaBXTbj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 14:31:39 -0500
Received: from top.free-electrons.com ([176.31.233.9]:55950 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753173AbaBXTbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 14:31:37 -0500
Date: Mon, 24 Feb 2014 20:31:33 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-kernel@vger.kernel.org, b.brezillon@overkiz.com,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv3 4/9] ARM: at91: dt: sam9rl: Device Tree for the
 at91sam9rlek
Message-ID: <20140224193132.GF4436@piout.net>
References: <1393012138-17255-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1393012138-17255-5-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393012138-17255-5-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 21/02/2014 at 20:48:53 +0100, Alexandre Belloni wrote :
> +	ahb {
> +		apb {
> +			mmc0: mmc@fffa4000 {
> +				pinctrl-0 = <
> +					&pinctrl_board_mmc0
> +					&pinctrl_mmc0_clk
> +					&pinctrl_mmc0_slot0_cmd_dat0
> +					&pinctrl_mmc0_slot0_dat1_3>;
> +				status = "okay";
> +				slot@0 {
> +					reg = <0>;
> +					bus-width = <4>;
> +					cd-gpios = <&pioA 15 GPIO_ACTIVE_HIGH>;
> +				};
> +			};
> +
> +			usart0: serial@fffb0000 {
> +				pinctrl-0 = <
> +					&pinctrl_usart0
> +					&pinctrl_usart0_rts
> +					&pinctrl_usart0_cts>;
> +				status = "okay";
> +			};
> +
> +			dbgu: serial@fffff200 {
> +				status = "okay";
> +			};
> +
> +			pinctrl@fffff400 {
> +				mmc0 {
> +					pinctrl_board_mmc0: mmc0-board {
> +						atmel,pins =
> +							<AT91_PIOA 15 AT91_PERIPH_GPIO AT91_PINCTRL_PULL_UP_DEGLITCH>;
> +					};
> +				};
> +			};
> +
> +			watchdog@fffffd40 {
> +				status = "okay";
> +			};
> +		};
> +

I just realised, do you want me to actually put the nand before the apb ?

> +		nand0: nand@40000000 {
> +			nand-bus-width = <8>;
> +			nand-ecc-mode = "soft";
> +			nand-on-flash-bbt = <1>;
> +			status = "okay";
> +
> +			at91bootstrap@0 {
> +				label = "at91bootstrap";
> +				reg = <0x0 0x40000>;
> +			};
> +
> +			bootloader@40000 {
> +				label = "bootloader";
> +				reg = <0x40000 0x80000>;
> +			};
> +
> +			bootloaderenv@c0000 {
> +				label = "bootloader env";
> +				reg = <0xc0000 0xc0000>;
> +			};
> +
> +			dtb@180000 {
> +				label = "device tree";
> +				reg = <0x180000 0x80000>;
> +			};
> +
> +			kernel@200000 {
> +				label = "kernel";
> +				reg = <0x200000 0x600000>;
> +			};
> +
> +			rootfs@800000 {
> +				label = "rootfs";
> +				reg = <0x800000 0x0f800000>;
> +			};
> +		};
> +	};
> +

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
