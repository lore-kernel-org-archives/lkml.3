Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab3JYD1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 23:27:37 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:41304 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415Ab3JYD1e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 23:27:34 -0400
Subject: Re: [PATCH 03/03] GPIO: Add TB10x GPIO driver
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1381235122-23730-3-git-send-email-christian.ruppert@abilis.com>
Date: Thu, 24 Oct 2013 22:27:43 -0500
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <C89F2E38-4428-4AA9-B032-630F3BEA4C1D@codeaurora.org>
References: <20131008122145.GA21985@ab42.lan> <1381235122-23730-3-git-send-email-christian.ruppert@abilis.com>
To: Christian Ruppert <christian.ruppert@abilis.com>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 8, 2013, at 7:25 AM, Christian Ruppert wrote:

> The GPIO driver for the Abilis Systems TB10x series of SOCs based on ARC700
> CPUs. It supports GPIO control and GPIO interrupt generation. This driver
> works in conjunction with the TB10x pinctrl driver.
> 
> Signed-off-by: Sascha Leuenberger <sascha.leuenberger@abilis.com>
> Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
> ---
> .../devicetree/bindings/gpio/abilis,tb10x-gpio.txt |   36 ++
> drivers/gpio/Kconfig                               |    4 +
> drivers/gpio/Makefile                              |    1 +
> drivers/gpio/gpio-tb10x.c                          |  341 ++++++++++++++++++++
> 4 files changed, 382 insertions(+), 0 deletions(-)
> create mode 100644 Documentation/devicetree/bindings/gpio/abilis,tb10x-gpio.txt
> create mode 100644 drivers/gpio/gpio-tb10x.c
> 
> diff --git a/Documentation/devicetree/bindings/gpio/abilis,tb10x-gpio.txt b/Documentation/devicetree/bindings/gpio/abilis,tb10x-gpio.txt
> new file mode 100644
> index 0000000..00611ac
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/gpio/abilis,tb10x-gpio.txt
> @@ -0,0 +1,36 @@
> +* Abilis TB10x GPIO controller
> +
> +Required Properties:
> +- compatible: Should be "abilis,tb10x-gpio"
> +- reg: Address and length of the register set for the device
> +- gpio-controller: Marks the device node as a gpio controller.
> +- #gpio-cells: Should be <2>. The first cell is the pin number and the
> +  second cell is used to specify optional parameters:
> +   - bit 0 specifies polarity (0 for normal, 1 for inverted).
> +- abilis,ngpio: the number of GPIO pins this driver controls.
> +
> +Optional Properties:
> +- interrupt-controller: Marks the device node as an interrupt controller.
> +- #interrupt-cells: Should be <1>. Interrupts are triggered on both edges.
> +- interrupts: Defines the interrupt line connecting this GPIO controller to
> +  its parent interrupt controller.
> +- interrupt-parent: Defines the parent interrupt controller.
> +
> +GPIO ranges are specified as described in
> +Documentation/devicetree/bindings/gpio/gpio.txt
> +
> +Example:
> +
> +	gpioa: gpio@FF140000 {
> +		compatible = "abilis,tb10x-gpio";
> +		interrupt-controller;
> +		#interrupt-cells = <1>;
> +		interrupt-parent = <&tb10x_ictl>;
> +		interrupts = <27 2>;
> +		reg = <0xFF140000 0x1000>;
> +		gpio-controller;
> +		#gpio-cells = <2>;
> +		abilis,ngpio = <3>;
> +		gpio-ranges = <&iomux 0 0 0>;
> +		gpio-ranges-group-names = "gpioa_pins";
> +	};

For the Binding part:

Acked-by: Kumar Gala <galak@codeaurora.org>

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

