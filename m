Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634AbaG0UdE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 16:33:04 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35343 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752529AbaG0UdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 16:33:02 -0400
Date: Sun, 27 Jul 2014 22:32:58 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Benoit Masson <yahoo@perenite.com>
Cc: benoitm@perenite.com, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        gregory.clement@free-electrons.com, andrew@lunn.ch,
        sebastian.hesselbarth@googlemail.com, jason@lakedaemon.net
Subject: Re: [PATCH 2/2] V3 ARM: mvebu: Added dts defintion for Lenovo
 Iomega ix4-300d NAS
Message-ID: <20140727223258.36b050b9@free-electrons.com>
In-Reply-To: <1406418490-61502-1-git-send-email-yahoo@perenite.com>
References: <1406418490-61502-1-git-send-email-yahoo@perenite.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Benoit Masson,

On Sat, 26 Jul 2014 16:48:10 -0700, Benoit Masson wrote:

> +	gpio-keys {
> +		compatible = "gpio-keys";
> +		pinctrl-0 = <&power_button_pin &reset_button_pin
> +			&select_button_pin &scroll_button_pin>;
> +		pinctrl-names = "default";
> +
> +		power-button {
> +			label = "Power Button";
> +			linux,code = <KEY_POWER>;
> +			gpios = <&gpio1 12 GPIO_ACTIVE_HIGH>;
> +		};
> +
> +		reset-button {
> +			label = "Reset Button";
> +			linux,code = <KEY_RESTART>;
> +			gpios = <&gpio1 13 GPIO_ACTIVE_LOW>;
> +		};
> +
> +		select-button {
> +			label = "Select Button";
> +			linux,code = <BTN_SELECT>;
> +			gpios = <&gpio1 9 GPIO_ACTIVE_LOW>;
> +		};
> +
> +		scroll-button {
> +			label = "Scroll Button";
> +			linux,code = <KEY_SCROLLDOWN>;
> +			gpios = <&gpio1 10 GPIO_ACTIVE_LOW>;

So you're using the GPIO_ACTIVE_<foo> defines here.

> +		};
> +	};
> +
> +	spi3 {
> +		compatible = "spi-gpio";
> +		status = "okay";
> +		gpio-sck = <&gpio0 25 0>;
> +		gpio-mosi = <&gpio1 15 0>; /*gpio 47*/
> +		cs-gpios = <&gpio0 27 0 >;

But not here. Any reason?

Also, nitpick: unneeded space in <&gpio0 27 0 > (i.e the space right
before the closing >).

> +		num-chipselects = <1>;
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		gpio2: gpio2@0 {
> +			compatible = "fairchild,74hc595";
> +			gpio-controller;
> +			#gpio-cells = <2>;
> +			reg = <0>;
> +			registers-number = <2>;
> +			spi-max-frequency = <100000>;
> +		};

I'm not sure "gpio2" is a good name, as we might think of it as being
the third GPIO controller internal to the SoC.

Thanks,

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
