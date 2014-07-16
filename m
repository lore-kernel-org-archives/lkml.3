Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932580AbaGPKHH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 06:07:07 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:39651 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025AbaGPKHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 06:07:02 -0400
Message-ID: <53C64E78.4030506@gmail.com>
Date: Wed, 16 Jul 2014 15:35:44 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
Organization: CDAC-HYD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Grygorii Strashko <grygorii.strashko@ti.com>, santosh.shilimkar@ti.com,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, linux-gpio@vger.kernel.org
CC: ivan.khoronzhuk@ti.com, m-karicheri2@ti.com,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] gpio: keystone: add dsp gpio controller driver
References: <1405507426-18992-1-git-send-email-grygorii.strashko@ti.com>
In-Reply-To: <1405507426-18992-1-git-send-email-grygorii.strashko@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 04:13 PM, Grygorii Strashko wrote:
> From: Murali Karicheri <m-karicheri2@ti.com>
>
> On Keystone SOCs, ARM host can send interrupts to DSP cores using the
> DSP GPIO controller IP. Each DSP GPIO controller provides 28 IRQ signals for
> each DSP core. This is one of the component used by the IPC mechanism used
> on Keystone SOCs.
>
> Keystone 2 DSP GPIO controller has specific features:
> - each GPIO can be configured only as output pin;
> - setting GPIO value to 1 causes IRQ generation on target DSP core;
> - reading pin value returns 0 - if IRQ was handled or 1 - IRQ is still
>    pending.
>
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
>   .../devicetree/bindings/gpio/gpio-keystone.txt     |   43 ++++++
>   drivers/gpio/Kconfig                               |    8 ++
>   drivers/gpio/Makefile                              |    1 +
>   drivers/gpio/gpio-keystone.c                       |  138 ++++++++++++++++++++
>   4 files changed, 190 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/gpio/gpio-keystone.txt
>   create mode 100644 drivers/gpio/gpio-keystone.c
>
> diff --git a/Documentation/devicetree/bindings/gpio/gpio-keystone.txt b/Documentation/devicetree/bindings/gpio/gpio-keystone.txt
> new file mode 100644
> index 0000000..4f92af4
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/gpio/gpio-keystone.txt
> @@ -0,0 +1,43 @@
> +Keystone 2 DSP GPIO controller bindings
> +
> +HOST OS userland running on ARM can send interrupts to DSP cores using
> +the DSP GPIO controller IP. It provides 28 IRQ signals per each DSP core.
> +This is one of the component used by the IPC mechanism used on Keystone SOCs.
> +
> +For example TCI6638K2K SoC has 8 DSP GPIO controllers:
> + - 8 for C66x CorePacx CPUs 0-7
> +
> +Keystone 2 DSP GPIO controller has specific features:
> +- each GPIO can be configured only as output pin;
> +- setting GPIO value to 1 causes IRQ generation on target DSP core;
> +- reading pin value returns 0 - if IRQ was handled or 1 - IRQ is still
> +  pending.
> +
> +Required Properties:
> +- compatible: should be "ti,keystone-dsp-gpio"
> +
> +- ti,syscon-dev:	phandle/offset pair. The phandle to syscon used to
> +			access device state control registers and the offset
> +			in order to use block of device's specific registers.
> +
> +- gpio-controller : Marks the device node as a gpio controller.
> +
> +- #gpio-cells : Should be one.
> +				See gpio.txt in this directory for a of the cells format

All the properties not properly aligned. It would be more readable if

Required Properties:
- compatible		: should be "ti,keystone-dsp-gpio"
- ti,syscon-dev		: phandle/offset pair. The phandle to syscon used to
			  access device state control registers and the offset
			  in order to use block of device's specific registers.
- gpio-controller	: Marks the device node as a gpio controller.
- #gpio-cells		: Should be one.
			  See gpio.txt in this directory for a of the cells format

> +
> +Please refer to gpio.txt in this directory for details of the common GPIO
> +bindings used by client devices.
> +

(...)

> +static struct platform_driver keystone_gpio_driver = {
> +	.probe		= keystone_gpio_probe,
> +	.remove		= keystone_gpio_remove,
> +	.driver		= {
> +		.name	= "keystone-dsp-gpio",
> +		.owner	= THIS_MODULE,

We can drop owner field...  :-)  .It will update by module_platform_driver


-- 
Regards,
Varka Bhadram.

