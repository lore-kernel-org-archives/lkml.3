Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297Ab3GCLqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 07:46:43 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:54564 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756282Ab3GCLql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 07:46:41 -0400
MIME-Version: 1.0
In-Reply-To: <1372072858-6559-4-git-send-email-yadi.brar@samsung.com>
References: <1372072858-6559-1-git-send-email-yadi.brar@samsung.com>
	<1372072858-6559-4-git-send-email-yadi.brar@samsung.com>
Date: Wed, 3 Jul 2013 17:16:41 +0530
Message-ID: <CAK9yfHwvkZsARpWyZYu7+1_nap_Px8TMYCm+hyubA_peobdQMw@mail.gmail.com>
Subject: Re: [PATCH 3/4] mfd: s2mps11: Add device tree support
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Yadwinder Singh Brar <yadi.brar@samsung.com>
Cc: linux-kernel@vger.kernel.org, yadi.brar01@gmail.com, sbkim73@samsung.com,
        broonie@kernel.org, lgirdwood@gmail.com, sameo@linux.intel.com,
        rob.herring@calxeda.com, grant.likely@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 June 2013 16:50, Yadwinder Singh Brar <yadi.brar@samsung.com> wrote:
> This patch adds DT compatible string for s2mps11 and binding documentation.
>
> Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
> ---
>  Documentation/devicetree/bindings/mfd/s2mps11.txt |   98 +++++++++++++++++++++
>  drivers/mfd/sec-core.c                            |    3 +
>  2 files changed, 101 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/mfd/s2mps11.txt
>
> diff --git a/Documentation/devicetree/bindings/mfd/s2mps11.txt b/Documentation/devicetree/bindings/mfd/s2mps11.txt
> new file mode 100644
> index 0000000..7984625
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/s2mps11.txt
> @@ -0,0 +1,98 @@
> +
> +* Samsung S2MPS11 Voltage and Current Regulator
> +
> +The Samsung S2MP211 is a multi-function device which includes volatage and

s/volatage/voltage

> +current regulators, rtc, charger controller and other sub-blocks. It is

s/rtc/RTC

> +interfaced to the host controller using a i2c interface. Each sub-block is
> +addressed by the host system using different i2c slave address.

s/i2c/I2C -> also elsewhere

> +
> +Required properties:
> +- compatible: Should be "samsung,s2mps11-pmic".
> +- reg: Specifies the i2c slave address of the pmic block. It should be 0x66.
> +
> +Optional properties:
> +- interrupt-parent: Specifies the phandle of the interrupt controller to which
> +  the interrupts from s2mps11 are delivered to.
> +- interrupts: Interrupt specifiers for interrupt sources.
> +
> +Optional nodes:
> +- regulators: The regulators of s2mps11 that have to be instantiated should be
> +included in a sub-node named 'regulators'. Regulator nodes included in this
> +sub-node should be of the format as listed below.
> +
> +       regulator_name {
> +               [standard regulator constraints....];
> +               [regulator-ramp-disable];
> +       };
> +
> + regulator-ramp-delay for BUCKs = [6250/12500/25000(default)/50000] uV/us
> +
> + Optional property for BUCK[2/3/4/6] only:
> + regulator-ramp-disable: boolean, disables ramp delay on hardware.
> +
> +NOTE: Some BUCKs shares the ramp rate setting i.e. same ramp value will be set

s/shares/share

-- 
With warm regards,
Sachin
