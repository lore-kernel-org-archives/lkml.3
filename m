Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486Ab3GBLfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 07:35:38 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:45938 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab3GBLfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 07:35:36 -0400
Message-ID: <51D2BB05.9040201@free-electrons.com>
Date: Tue, 02 Jul 2013 13:35:33 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Organization: Free Electrons
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>
CC: Shawn Guo <shawn.guo@linaro.org>, Jonathan Cameron <jic23@cam.ac.uk>,
        brian@crystalfontz.com, linux-doc@vger.kernel.org,
        linux-iio@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        jimwall@q.com, Rob Herring <rob.herring@calxeda.com>,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Lucas Stach <l.stach@pengutronix.de>, Marek Vasut <marex@denx.de>
Subject: Re: [PATCHv3 2/3] ARM: mxs: cfa10049: Switch bus i2c1 to bitbanging
References: <1372094699-3832-1-git-send-email-alexandre.belloni@free-electrons.com> <1372094699-3832-3-git-send-email-alexandre.belloni@free-electrons.com> <CAOMZO5CLcT=OXYd=ggxpDzUqFxoXSaanqUPGugYLT2Og-VgzCA@mail.gmail.com>
In-Reply-To: <CAOMZO5CLcT=OXYd=ggxpDzUqFxoXSaanqUPGugYLT2Og-VgzCA@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 02/07/2013 04:45, Fabio Estevam wrote:
> Are you able to use the mxs i2c controller instead of bitbang if you
> use this patch?
> http://www.spinics.net/lists/stable/msg13202.html
> 

Actually, it gets worse. I'm probably doing something wrong but I get:

mxs-i2c 8005a000.i2c: Failed to get PIO reg. write descriptor.

That is the one line 243. I'm open to any suggestion.

BTW, I also tested PIO mode with and without touchscreen support as that
seemed to toggle the issue on your side. It is also worse than what it
was in 3.9. Trying to read the nau7802 ADC never returns.

The excerpt from my DT:

i2c1: i2c@8005a000 {
	pinctrl-names = "default";
	pinctrl-0 = <&i2c1_pins_a>;
	status = "okay";
};

i2cmux {
	compatible = "i2c-mux-gpio";
	#address-cells = <1>;
	#size-cells = <0>;
	pinctrl-names = "default";
	pinctrl-0 = <&i2cmux_pins_cfa10049>;
	mux-gpios = <&gpio1 22 0 &gpio1 23 0>;
	i2c-parent = <&i2c1>;

	i2c@0 {
		reg = <0>;
		#address-cells = <1>;
		#size-cells = <0>;

		adc0: nau7802@2a {
			compatible = "nuvoton,nau7802";
			reg = <0x2a>;
			nuvoton,vldo = <3000>;
		};
	};

[...]


-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
