Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757751Ab3FTKhA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 06:37:00 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:34386 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757636Ab3FTKg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 06:36:58 -0400
Message-ID: <51C2DB23.9070705@ti.com>
Date: Thu, 20 Jun 2013 16:06:19 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Philip Avinash <avinashphilipk@gmail.com>
CC: <linux@arm.linux.org.uk>, <grant.likely@secretlab.ca>,
        <linus.walleij@linaro.org>, <rob.herring@calxeda.com>,
        <rob@landley.net>, <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <avinashphilip@ti.com>
Subject: Re: [PATCH v2 2/4] gpio: davinci: DT changes for driver
References: <1371203020-15092-1-git-send-email-avinashphilip@ti.com> <1371205241-17205-3-git-send-email-avinashphilipk@gmail.com>
In-Reply-To: <1371205241-17205-3-git-send-email-avinashphilipk@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/14/2013 3:50 PM, Philip Avinash wrote:
> From: KV Sujith <sujithkv@ti.com>
> 
> - Add of_device_id for Davinci GPIO driver.
> - Add function to populate data from DT.
> - Modify the probe to read from DT if DT match is found.
> - Add DT binding documentation for Davinci GPIO properties in a new file
>   gpio-davinci.txt located at Documentation/devicetree/bindings/gpio/.
> 
> Signed-off-by: KV Sujith <sujithkv@ti.com>
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> ---
> Changes since v1:
> 	- description for interrupts changed to reflecti
> 	   interrupt array usage.
> 
>  .../devicetree/bindings/gpio/gpio-davinci.txt      |   32 +++++++++++
>  drivers/gpio/gpio-davinci.c                        |   57 ++++++++++++++++++--
>  2 files changed, 86 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/gpio/gpio-davinci.txt b/Documentation/devicetree/bindings/gpio/gpio-davinci.txt
> new file mode 100644
> index 0000000..1c31638
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/gpio/gpio-davinci.txt
> @@ -0,0 +1,32 @@
> +Davinci GPIO controller bindings
> +
> +Required Properties:
> +- compatible:"ti,da830-gpio"

"ti,dm6441-gpio" instead since this came first on DM6441?

> +
> +- reg: Physical base address of the controller and length of memory mapped
> +	region.
> +
> +- interrupts: Array of GPIO interrupt number.
> +
> +- ngpio: The number of GPIO pins supported

Is this a generic GPIO property? I could not find it in documentation.
Looks like Marvell GPIO uses a similar property too, but even there it
is not marked as Marvell specific. Should this be added as a generic
GPIO property?

> +- intc_irq_num: The number of IRQs supported by the Interrupt Controller

You are not actually looking at the number of IRQs interrupt controller
on the SoC supports (which is quite unrelated to GPIO module). What you
are actually looking for is the base from where GPIO interrupt numbering
can start. So "ti,davinci-gpio-irq-base" is more meaningful.

That said, this property is probably not required if irqdomains are used
(I myself have to read about that). Not sure if it is okay to add this
property now waiting for irqdomain conversion. I will let Linus take a call.

> +
> +- gpio_unbanked: The number of GPIOs that have an individual interrupt
> +		line to processor.

This is also a TI specific property so it should be
"ti,davinci-gpio-unbanked".

Thanks,
Sekhar
