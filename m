Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbaDPIth (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 04:49:37 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:51829 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbaDPItb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 04:49:31 -0400
MIME-Version: 1.0
In-Reply-To: <20140413051050.GA7267@core.coreip.homeip.net>
References: <1397228856-9218-1-git-send-email-gabriel.fernandez@linaro.org>
	<1397228856-9218-2-git-send-email-gabriel.fernandez@linaro.org>
	<20140413051050.GA7267@core.coreip.homeip.net>
Date: Wed, 16 Apr 2014 10:49:29 +0200
Message-ID: <CAG374jCT78wkxwzn9qMsBD2bGiEXr=spu+cF7C45+nr8C6gRRQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/7] drivers: input: keyboard: st-keyscan: add keyscan driver
From: Gabriel Fernandez <gabriel.fernandez@linaro.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>,
        Giuseppe Condorelli <giuseppe.condorelli@st.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 April 2014 07:10, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> Hi Gabriel,
>
> On Fri, Apr 11, 2014 at 05:07:30PM +0200, Gabriel FERNANDEZ wrote:
>> This patch adds ST Keyscan driver to use the keypad hw a subset
>> of ST boards provide. Specific board setup will be put in the
>> given dt.
>>
>> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
>> Signed-off-by: Giuseppe Condorelli <giuseppe.condorelli@st.com>
>> ---
>>  .../devicetree/bindings/input/st-keyscan.txt       |  60 +++++
>>  drivers/input/keyboard/Kconfig                     |  12 +
>>  drivers/input/keyboard/Makefile                    |   1 +
>>  drivers/input/keyboard/st-keyscan.c                | 260 +++++++++++++++++++++
>>  4 files changed, 333 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/input/st-keyscan.txt
>>  create mode 100644 drivers/input/keyboard/st-keyscan.c
>>
>> diff --git a/Documentation/devicetree/bindings/input/st-keyscan.txt b/Documentation/devicetree/bindings/input/st-keyscan.txt
>> new file mode 100644
>> index 0000000..51eb428
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/input/st-keyscan.txt
>> @@ -0,0 +1,60 @@
>> +* ST Keyscan controller Device Tree bindings
>> +
>> +The ST keyscan controller Device Tree binding is based on the
>> +matrix-keymap.
>> +
>> +Required properties:
>> +- compatible: "st,sti-keyscan"
>> +
>> +- reg: Register base address and size of st-keyscan controller.
>> +
>> +- interrupts: Interrupt number for the st-keyscan controller.
>> +
>> +- clocks: Must contain one entry, for the module clock.
>> +  See ../clocks/clock-bindings.txt for details.
>> +
>> +- pinctrl: Should specify pin control groups used for this controller.
>> +  See ../pinctrl/pinctrl-bindings.txt for details.
>> +
>> +- linux,keymap: The keymap for keys as described in the binding document
>> +  devicetree/bindings/input/matrix-keymap.txt.
>> +
>> +- keypad,num-rows: Number of row lines connected to the keypad controller.
>> +
>> +- keypad,num-columns: Number of column lines connected to the keypad
>> +  controller.
>> +
>> +Optional property:
>> +- st,debounce_us: Debouncing interval time in microseconds
>> +
>> +Example:
>> +
>> +keyscan: keyscan@fe4b0000 {
>> +     compatible = "st,sti-keyscan";
>> +     reg = <0xfe4b0000 0x2000>;
>> +     interrupts = <GIC_SPI 212 IRQ_TYPE_NONE>;
>> +     clocks  = <&CLK_SYSIN>;
>> +     pinctrl-names = "default";
>> +     pinctrl-0 = <&pinctrl_keyscan>;
>> +
>> +     keypad,num-rows = <4>;
>> +     keypad,num-columns = <4>;
>> +     st,debounce_us = <5000>;
>> +
>> +     linux,keymap = < MATRIX_KEY(0x00, 0x00, KEY_F13)
>> +                      MATRIX_KEY(0x00, 0x01, KEY_F9)
>> +                      MATRIX_KEY(0x00, 0x02, KEY_F5)
>> +                      MATRIX_KEY(0x00, 0x03, KEY_F1)
>> +                      MATRIX_KEY(0x01, 0x00, KEY_F14)
>> +                      MATRIX_KEY(0x01, 0x01, KEY_F10)
>> +                      MATRIX_KEY(0x01, 0x02, KEY_F6)
>> +                      MATRIX_KEY(0x01, 0x03, KEY_F2)
>> +                      MATRIX_KEY(0x02, 0x00, KEY_F15)
>> +                      MATRIX_KEY(0x02, 0x01, KEY_F11)
>> +                      MATRIX_KEY(0x02, 0x02, KEY_F7)
>> +                      MATRIX_KEY(0x02, 0x03, KEY_F3)
>> +                      MATRIX_KEY(0x03, 0x00, KEY_F16)
>> +                      MATRIX_KEY(0x03, 0x01, KEY_F12)
>> +                      MATRIX_KEY(0x03, 0x02, KEY_F8)
>> +                      MATRIX_KEY(0x03, 0x03, KEY_F4) >;
>> +     };
>> diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
>> index 76842d7..40a377c 100644
>> --- a/drivers/input/keyboard/Kconfig
>> +++ b/drivers/input/keyboard/Kconfig
>> @@ -524,6 +524,18 @@ config KEYBOARD_STOWAWAY
>>         To compile this driver as a module, choose M here: the
>>         module will be called stowaway.
>>
>> +config KEYBOARD_ST_KEYSCAN
>> +     tristate "STMicroelectronics keyscan support"
>> +     depends on ARCH_STI
>> +     select INPUT_EVDEV
>
> Why are you selecting evdev? Its presence is not essential for the
> driver.
it's historic..
i agree no reason to keep it.

>
>> +     select INPUT_MATRIXKMAP
>> +     help
>> +       Say Y here if you want to use a keypad attached to the keyscan block
>> +       on some STMicroelectronics SoC devices.
>> +
>> +       To compile this driver as a module, choose M here: the
>> +       module will be called st-keyscan.
>> +
>>  config KEYBOARD_SUNKBD
>>       tristate "Sun Type 4 and Type 5 keyboard"
>>       select SERIO
>> diff --git a/drivers/input/keyboard/Makefile b/drivers/input/keyboard/Makefile
>> index 11cff7b..7504ae1 100644
>> --- a/drivers/input/keyboard/Makefile
>> +++ b/drivers/input/keyboard/Makefile
>> @@ -51,6 +51,7 @@ obj-$(CONFIG_KEYBOARD_SH_KEYSC)             += sh_keysc.o
>>  obj-$(CONFIG_KEYBOARD_SPEAR)         += spear-keyboard.o
>>  obj-$(CONFIG_KEYBOARD_STMPE)         += stmpe-keypad.o
>>  obj-$(CONFIG_KEYBOARD_STOWAWAY)              += stowaway.o
>> +obj-$(CONFIG_KEYBOARD_ST_KEYSCAN)    += st-keyscan.o
>>  obj-$(CONFIG_KEYBOARD_SUNKBD)                += sunkbd.o
>>  obj-$(CONFIG_KEYBOARD_TC3589X)               += tc3589x-keypad.o
>>  obj-$(CONFIG_KEYBOARD_TEGRA)         += tegra-kbc.o
>> diff --git a/drivers/input/keyboard/st-keyscan.c b/drivers/input/keyboard/st-keyscan.c
>> new file mode 100644
>> index 0000000..7ed3b3e
>> --- /dev/null
>> +++ b/drivers/input/keyboard/st-keyscan.c
>> @@ -0,0 +1,260 @@
>> +/*
>> + * STMicroelectronics Key Scanning driver
>> + *
>> + * Copyright (c) 2014 STMicroelectonics Ltd.
>> + * Author: Stuart Menefy <stuart.menefy@st.com>
>> + *
>> + * Based on sh_keysc.c, copyright 2008 Magnus Damm
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/clk.h>
>> +#include <linux/io.h>
>> +#include <linux/input/matrix_keypad.h>
>> +
>> +#define ST_KEYSCAN_MAXKEYS 16
>> +
>> +#define KEYSCAN_CONFIG_OFF           0x0
>> +#define KEYSCAN_CONFIG_ENABLE                0x1
>> +#define KEYSCAN_DEBOUNCE_TIME_OFF    0x4
>> +#define KEYSCAN_MATRIX_STATE_OFF     0x8
>> +#define KEYSCAN_MATRIX_DIM_OFF               0xc
>> +#define KEYSCAN_MATRIX_DIM_X_SHIFT   0x0
>> +#define KEYSCAN_MATRIX_DIM_Y_SHIFT   0x2
>> +
>> +struct st_keyscan {
>> +     void __iomem *base;
>> +     int irq;
>> +     struct clk *clk;
>> +     struct input_dev *input_dev;
>> +     unsigned int last_state;
>> +     unsigned int n_rows;
>> +     unsigned int n_cols;
>> +     unsigned int debounce_us;
>> +};
>> +
>> +static irqreturn_t keyscan_isr(int irq, void *dev_id)
>> +{
>> +     struct platform_device *pdev = dev_id;
>> +     struct st_keyscan *keypad = platform_get_drvdata(pdev);
>
> This is not safe, you are assigning platform data at the very end of
> probe; input device may get opened before probe is completed and IRS
> may come early causing OOPS.
>
>> +     unsigned short *keycode = keypad->input_dev->keycode;
>> +     int state;
>> +     int change;
>> +
>> +     state = readl(keypad->base + KEYSCAN_MATRIX_STATE_OFF) & 0xffff;
>> +     change = keypad->last_state ^ state;
>> +
>> +     while (change) {
>> +             int scancode = __ffs(change);
>> +             int down = state & BIT(scancode);
>> +
>> +             input_report_key(keypad->input_dev, keycode[scancode], down);
>> +
>> +             change ^= BIT(scancode);
>> +     };
>> +     input_sync(keypad->input_dev);
>> +
>> +     keypad->last_state = state;
>> +
>> +     return IRQ_HANDLED;
>> +}
>> +
>> +static int keyscan_start(struct st_keyscan *keypad)
>> +{
>> +     clk_enable(keypad->clk);
>
> Should handle clk_enable() failures.
>
ok

>> +
>> +     writel(keypad->debounce_us * (clk_get_rate(keypad->clk) / 1000000),
>> +            keypad->base + KEYSCAN_DEBOUNCE_TIME_OFF);
>> +
>> +     writel(((keypad->n_cols - 1) << KEYSCAN_MATRIX_DIM_X_SHIFT) |
>> +            ((keypad->n_rows - 1) << KEYSCAN_MATRIX_DIM_Y_SHIFT),
>> +            keypad->base + KEYSCAN_MATRIX_DIM_OFF);
>> +
>> +     writel(KEYSCAN_CONFIG_ENABLE, keypad->base + KEYSCAN_CONFIG_OFF);
>> +
>> +     return 0;
>> +}
>> +
>> +static void keyscan_stop(struct st_keyscan *keypad)
>> +{
>> +     writel(0, keypad->base + KEYSCAN_CONFIG_OFF);
>> +
>> +     clk_disable(keypad->clk);
>> +}
>> +
>> +static int keyscan_open(struct input_dev *dev)
>> +{
>> +     struct st_keyscan *keypad = input_get_drvdata(dev);
>> +
>> +     return keyscan_start(keypad);
>> +}
>> +
>> +static void keyscan_close(struct input_dev *dev)
>> +{
>> +     struct st_keyscan *keypad = input_get_drvdata(dev);
>> +
>> +     keyscan_stop(keypad);
>> +}
>> +
>> +static int keypad_matrix_key_parse_dt(struct st_keyscan *keypad_data)
>> +{
>> +     struct device *dev = keypad_data->input_dev->dev.parent;
>> +     struct device_node *np = dev->of_node;
>> +     int error;
>> +
>> +     error = matrix_keypad_parse_of_params(dev, &keypad_data->n_rows,
>> +                     &keypad_data->n_cols);
>> +     if (error) {
>> +             dev_err(dev, "failed to parse keypad params\n");
>> +             return error;
>> +     }
>> +
>> +     of_property_read_u32(np, "st,debounce-us", &keypad_data->debounce_us);
>> +
>> +     dev_info(dev, "n_rows=%d n_col=%d debounce=%d\n",
>> +                     keypad_data->n_rows,
>> +                     keypad_data->n_cols,
>> +                     keypad_data->debounce_us);
>> +
>> +     return 0;
>> +}
>> +
>> +static int __init keyscan_probe(struct platform_device *pdev)
>
> keyscan_probe() should not be marked __init as it may be needed again if
> one were to unbind and rebind the driver to the device through sysfs.
>
ok

>> +{
>> +     struct st_keyscan *keypad_data;
>> +     struct input_dev *input_dev;
>> +     struct resource *res;
>> +     int error;
>> +
>> +     if (!pdev->dev.of_node) {
>> +             dev_err(&pdev->dev, "no keymap defined\n");
>> +             return -EINVAL;
>> +     }
>> +
>> +     keypad_data = devm_kzalloc(&pdev->dev,
>> +                     sizeof(*keypad_data), GFP_KERNEL);
>> +     if (!keypad_data)
>> +             return -ENOMEM;
>> +
>> +     res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +     keypad_data->base = devm_ioremap_resource(&pdev->dev, res);
>> +     if (IS_ERR(keypad_data->base))
>> +             return PTR_ERR(keypad_data->base);
>> +
>> +     keypad_data->irq = platform_get_irq(pdev, 0);
>> +     if (keypad_data->irq < 0) {
>> +             dev_err(&pdev->dev, "no IRQ specified\n");
>> +             return -EINVAL;
>> +     }
>> +
>> +     error = devm_request_irq(&pdev->dev, keypad_data->irq, keyscan_isr, 0,
>> +                              pdev->name, pdev);
>> +     if (error) {
>> +             dev_err(&pdev->dev, "failed to request IRQ\n");
>> +             return error;
>> +     }
>> +
>> +     input_dev = devm_input_allocate_device(&pdev->dev);
>> +
>> +     if (!input_dev) {
>> +             dev_err(&pdev->dev, "failed to allocate the input device\n");
>> +             return -ENOMEM;
>> +     }
>> +
>> +     keypad_data->clk = devm_clk_get(&pdev->dev, NULL);
>> +     if (IS_ERR(keypad_data->clk)) {
>> +             dev_err(&pdev->dev, "cannot get clock");
>> +             return PTR_ERR(keypad_data->clk);
>> +     }
>> +
>> +     keypad_data->input_dev = input_dev;
>> +
>> +     input_dev->name = pdev->name;
>> +     input_dev->phys = "keyscan-keys/input0";
>> +     input_dev->dev.parent = &pdev->dev;
>> +     input_dev->open = keyscan_open;
>> +     input_dev->close = keyscan_close;
>> +
>> +     input_dev->id.bustype = BUS_HOST;
>> +
>> +     error = keypad_matrix_key_parse_dt(keypad_data);
>> +     if (error)
>> +             return error;
>> +
>> +     error = matrix_keypad_build_keymap(NULL, NULL,
>> +                     keypad_data->n_rows, keypad_data->n_cols,
>> +                     NULL, input_dev);
>> +     if (error) {
>> +             dev_err(&pdev->dev, "failed to build keymap\n");
>> +             return error;
>> +     }
>> +
>> +     input_set_drvdata(input_dev, keypad_data);
>> +
>> +     error = input_register_device(input_dev);
>> +     if (error) {
>> +             dev_err(&pdev->dev, "failed to register input device\n");
>> +             return error;
>> +     }
>> +
>> +     platform_set_drvdata(pdev, keypad_data);
>> +
>> +     device_set_wakeup_capable(&pdev->dev, 1);
>> +
>> +     return 0;
>> +}
>> +
>> +static int keyscan_suspend(struct device *dev)
>> +{
>> +     struct platform_device *pdev = to_platform_device(dev);
>> +     struct st_keyscan *keypad = platform_get_drvdata(pdev);
>> +
>> +     if (device_may_wakeup(dev))
>> +             enable_irq_wake(keypad->irq);
>> +     else
>> +             keyscan_stop(keypad);
>> +
>> +     return 0;
>> +}
>> +
>> +static int keyscan_resume(struct device *dev)
>> +{
>> +     struct platform_device *pdev = to_platform_device(dev);
>> +     struct st_keyscan *keypad = platform_get_drvdata(pdev);
>> +
>> +     if (device_may_wakeup(dev))
>> +             disable_irq_wake(keypad->irq);
>> +     else
>> +             keyscan_start(keypad);
>
> If devoice has not been opened you should not try to stop it otherwise
> clk counter will be imbalanced.
>
Right

>> +
>> +     return 0;
>> +}
>> +
>> +static SIMPLE_DEV_PM_OPS(keyscan_dev_pm_ops, keyscan_suspend, keyscan_resume);
>> +
>> +static const struct of_device_id keyscan_of_match[] = {
>> +     { .compatible = "st,sti-keyscan" },
>> +     { },
>> +};
>> +MODULE_DEVICE_TABLE(of, keyscan_of_match);
>> +
>> +struct platform_driver keyscan_device_driver = {
>> +     .probe          = keyscan_probe,
>> +     .driver         = {
>> +             .name   = "st-keyscan",
>> +             .pm     = &keyscan_dev_pm_ops,
>> +             .of_match_table = of_match_ptr(keyscan_of_match),
>> +     }
>> +};
>> +
>> +module_platform_driver(keyscan_device_driver);
>> +
>> +MODULE_AUTHOR("Stuart Menefy <stuart.menefy@st.com>");
>> +MODULE_DESCRIPTION("STMicroelectronics keyscan device driver");
>> +MODULE_LICENSE("GPL");
>> --
>> 1.9.1
>>
>
> Does the version of the patch below still work for you?
>
Yes it's was tested on b2000 and b2089 sti boards.

> Thanks.
>
> --
> Dmitry
>
Thanks for yours remarks, i will prepare a v5 versions.
Regards

> Input: add st-keyscan driver
>
> From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
>
> This patch adds ST Keyscan driver to use the keypad hw a subset of ST
> boards provide. Specific board setup will be put in the given dt.
>
> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
> Signed-off-by: Giuseppe Condorelli <giuseppe.condorelli@st.com>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>  .../devicetree/bindings/input/st-keyscan.txt       |   60 ++++
>  drivers/input/keyboard/Kconfig                     |   11 +
>  drivers/input/keyboard/Makefile                    |    1
>  drivers/input/keyboard/st-keyscan.c                |  274 ++++++++++++++++++++
>  4 files changed, 346 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/input/st-keyscan.txt
>  create mode 100644 drivers/input/keyboard/st-keyscan.c
>
> diff --git a/Documentation/devicetree/bindings/input/st-keyscan.txt b/Documentation/devicetree/bindings/input/st-keyscan.txt
> new file mode 100644
> index 0000000..51eb428
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/input/st-keyscan.txt
> @@ -0,0 +1,60 @@
> +* ST Keyscan controller Device Tree bindings
> +
> +The ST keyscan controller Device Tree binding is based on the
> +matrix-keymap.
> +
> +Required properties:
> +- compatible: "st,sti-keyscan"
> +
> +- reg: Register base address and size of st-keyscan controller.
> +
> +- interrupts: Interrupt number for the st-keyscan controller.
> +
> +- clocks: Must contain one entry, for the module clock.
> +  See ../clocks/clock-bindings.txt for details.
> +
> +- pinctrl: Should specify pin control groups used for this controller.
> +  See ../pinctrl/pinctrl-bindings.txt for details.
> +
> +- linux,keymap: The keymap for keys as described in the binding document
> +  devicetree/bindings/input/matrix-keymap.txt.
> +
> +- keypad,num-rows: Number of row lines connected to the keypad controller.
> +
> +- keypad,num-columns: Number of column lines connected to the keypad
> +  controller.
> +
> +Optional property:
> +- st,debounce_us: Debouncing interval time in microseconds
> +
> +Example:
> +
> +keyscan: keyscan@fe4b0000 {
> +       compatible = "st,sti-keyscan";
> +       reg = <0xfe4b0000 0x2000>;
> +       interrupts = <GIC_SPI 212 IRQ_TYPE_NONE>;
> +       clocks  = <&CLK_SYSIN>;
> +       pinctrl-names = "default";
> +       pinctrl-0 = <&pinctrl_keyscan>;
> +
> +       keypad,num-rows = <4>;
> +       keypad,num-columns = <4>;
> +       st,debounce_us = <5000>;
> +
> +       linux,keymap = < MATRIX_KEY(0x00, 0x00, KEY_F13)
> +                        MATRIX_KEY(0x00, 0x01, KEY_F9)
> +                        MATRIX_KEY(0x00, 0x02, KEY_F5)
> +                        MATRIX_KEY(0x00, 0x03, KEY_F1)
> +                        MATRIX_KEY(0x01, 0x00, KEY_F14)
> +                        MATRIX_KEY(0x01, 0x01, KEY_F10)
> +                        MATRIX_KEY(0x01, 0x02, KEY_F6)
> +                        MATRIX_KEY(0x01, 0x03, KEY_F2)
> +                        MATRIX_KEY(0x02, 0x00, KEY_F15)
> +                        MATRIX_KEY(0x02, 0x01, KEY_F11)
> +                        MATRIX_KEY(0x02, 0x02, KEY_F7)
> +                        MATRIX_KEY(0x02, 0x03, KEY_F3)
> +                        MATRIX_KEY(0x03, 0x00, KEY_F16)
> +                        MATRIX_KEY(0x03, 0x01, KEY_F12)
> +                        MATRIX_KEY(0x03, 0x02, KEY_F8)
> +                        MATRIX_KEY(0x03, 0x03, KEY_F4) >;
> +       };
> diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
> index 76842d7..948a303 100644
> --- a/drivers/input/keyboard/Kconfig
> +++ b/drivers/input/keyboard/Kconfig
> @@ -524,6 +524,17 @@ config KEYBOARD_STOWAWAY
>           To compile this driver as a module, choose M here: the
>           module will be called stowaway.
>
> +config KEYBOARD_ST_KEYSCAN
> +       tristate "STMicroelectronics keyscan support"
> +       depends on ARCH_STI || COMPILE_TEST
> +       select INPUT_MATRIXKMAP
> +       help
> +         Say Y here if you want to use a keypad attached to the keyscan block
> +         on some STMicroelectronics SoC devices.
> +
> +         To compile this driver as a module, choose M here: the
> +         module will be called st-keyscan.
> +
>  config KEYBOARD_SUNKBD
>         tristate "Sun Type 4 and Type 5 keyboard"
>         select SERIO
> diff --git a/drivers/input/keyboard/Makefile b/drivers/input/keyboard/Makefile
> index 11cff7b..7504ae1 100644
> --- a/drivers/input/keyboard/Makefile
> +++ b/drivers/input/keyboard/Makefile
> @@ -51,6 +51,7 @@ obj-$(CONFIG_KEYBOARD_SH_KEYSC)               += sh_keysc.o
>  obj-$(CONFIG_KEYBOARD_SPEAR)           += spear-keyboard.o
>  obj-$(CONFIG_KEYBOARD_STMPE)           += stmpe-keypad.o
>  obj-$(CONFIG_KEYBOARD_STOWAWAY)                += stowaway.o
> +obj-$(CONFIG_KEYBOARD_ST_KEYSCAN)      += st-keyscan.o
>  obj-$(CONFIG_KEYBOARD_SUNKBD)          += sunkbd.o
>  obj-$(CONFIG_KEYBOARD_TC3589X)         += tc3589x-keypad.o
>  obj-$(CONFIG_KEYBOARD_TEGRA)           += tegra-kbc.o
> diff --git a/drivers/input/keyboard/st-keyscan.c b/drivers/input/keyboard/st-keyscan.c
> new file mode 100644
> index 0000000..758b487
> --- /dev/null
> +++ b/drivers/input/keyboard/st-keyscan.c
> @@ -0,0 +1,274 @@
> +/*
> + * STMicroelectronics Key Scanning driver
> + *
> + * Copyright (c) 2014 STMicroelectonics Ltd.
> + * Author: Stuart Menefy <stuart.menefy@st.com>
> + *
> + * Based on sh_keysc.c, copyright 2008 Magnus Damm
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/interrupt.h>
> +#include <linux/platform_device.h>
> +#include <linux/clk.h>
> +#include <linux/io.h>
> +#include <linux/input/matrix_keypad.h>
> +
> +#define ST_KEYSCAN_MAXKEYS 16
> +
> +#define KEYSCAN_CONFIG_OFF             0x0
> +#define KEYSCAN_CONFIG_ENABLE          0x1
> +#define KEYSCAN_DEBOUNCE_TIME_OFF      0x4
> +#define KEYSCAN_MATRIX_STATE_OFF       0x8
> +#define KEYSCAN_MATRIX_DIM_OFF         0xc
> +#define KEYSCAN_MATRIX_DIM_X_SHIFT     0x0
> +#define KEYSCAN_MATRIX_DIM_Y_SHIFT     0x2
> +
> +struct st_keyscan {
> +       void __iomem *base;
> +       int irq;
> +       struct clk *clk;
> +       struct input_dev *input_dev;
> +       unsigned long last_state;
> +       unsigned int n_rows;
> +       unsigned int n_cols;
> +       unsigned int debounce_us;
> +};
> +
> +static irqreturn_t keyscan_isr(int irq, void *dev_id)
> +{
> +       struct st_keyscan *keypad = dev_id;
> +       unsigned short *keycode = keypad->input_dev->keycode;
> +       unsigned long state, change;
> +       int bit_nr;
> +
> +       state = readl(keypad->base + KEYSCAN_MATRIX_STATE_OFF) & 0xffff;
> +       change = keypad->last_state ^ state;
> +       keypad->last_state = state;
> +
> +       for_each_set_bit(bit_nr, &change, BITS_PER_LONG)
> +               input_report_key(keypad->input_dev,
> +                                keycode[bit_nr], state & BIT(bit_nr));
> +
> +       input_sync(keypad->input_dev);
> +
> +       return IRQ_HANDLED;
> +}
> +
> +static int keyscan_start(struct st_keyscan *keypad)
> +{
> +       int error;
> +
> +       error = clk_enable(keypad->clk);
> +       if (error)
> +               return error;
> +
> +       writel(keypad->debounce_us * (clk_get_rate(keypad->clk) / 1000000),
> +              keypad->base + KEYSCAN_DEBOUNCE_TIME_OFF);
> +
> +       writel(((keypad->n_cols - 1) << KEYSCAN_MATRIX_DIM_X_SHIFT) |
> +              ((keypad->n_rows - 1) << KEYSCAN_MATRIX_DIM_Y_SHIFT),
> +              keypad->base + KEYSCAN_MATRIX_DIM_OFF);
> +
> +       writel(KEYSCAN_CONFIG_ENABLE, keypad->base + KEYSCAN_CONFIG_OFF);
> +
> +       return 0;
> +}
> +
> +static void keyscan_stop(struct st_keyscan *keypad)
> +{
> +       writel(0, keypad->base + KEYSCAN_CONFIG_OFF);
> +
> +       clk_disable(keypad->clk);
> +}
> +
> +static int keyscan_open(struct input_dev *dev)
> +{
> +       struct st_keyscan *keypad = input_get_drvdata(dev);
> +
> +       return keyscan_start(keypad);
> +}
> +
> +static void keyscan_close(struct input_dev *dev)
> +{
> +       struct st_keyscan *keypad = input_get_drvdata(dev);
> +
> +       keyscan_stop(keypad);
> +}
> +
> +static int keypad_matrix_key_parse_dt(struct st_keyscan *keypad_data)
> +{
> +       struct device *dev = keypad_data->input_dev->dev.parent;
> +       struct device_node *np = dev->of_node;
> +       int error;
> +
> +       error = matrix_keypad_parse_of_params(dev, &keypad_data->n_rows,
> +                                             &keypad_data->n_cols);
> +       if (error) {
> +               dev_err(dev, "failed to parse keypad params\n");
> +               return error;
> +       }
> +
> +       of_property_read_u32(np, "st,debounce-us", &keypad_data->debounce_us);
> +
> +       dev_dbg(dev, "n_rows=%d n_col=%d debounce=%d\n",
> +               keypad_data->n_rows, keypad_data->n_cols,
> +               keypad_data->debounce_us);
> +
> +       return 0;
> +}
> +
> +static int keyscan_probe(struct platform_device *pdev)
> +{
> +       struct st_keyscan *keypad_data;
> +       struct input_dev *input_dev;
> +       struct resource *res;
> +       int error;
> +
> +       if (!pdev->dev.of_node) {
> +               dev_err(&pdev->dev, "no DT data present\n");
> +               return -EINVAL;
> +       }
> +
> +       keypad_data = devm_kzalloc(&pdev->dev, sizeof(*keypad_data),
> +                                  GFP_KERNEL);
> +       if (!keypad_data)
> +               return -ENOMEM;
> +
> +       input_dev = devm_input_allocate_device(&pdev->dev);
> +       if (!input_dev) {
> +               dev_err(&pdev->dev, "failed to allocate the input device\n");
> +               return -ENOMEM;
> +       }
> +
> +       input_dev->name = pdev->name;
> +       input_dev->phys = "keyscan-keys/input0";
> +       input_dev->dev.parent = &pdev->dev;
> +       input_dev->open = keyscan_open;
> +       input_dev->close = keyscan_close;
> +
> +       input_dev->id.bustype = BUS_HOST;
> +
> +       error = keypad_matrix_key_parse_dt(keypad_data);
> +       if (error)
> +               return error;
> +
> +       error = matrix_keypad_build_keymap(NULL, NULL,
> +                                          keypad_data->n_rows,
> +                                          keypad_data->n_cols,
> +                                          NULL, input_dev);
> +       if (error) {
> +               dev_err(&pdev->dev, "failed to build keymap\n");
> +               return error;
> +       }
> +
> +       input_set_drvdata(input_dev, keypad_data);
> +
> +       keypad_data->input_dev = input_dev;
> +
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       keypad_data->base = devm_ioremap_resource(&pdev->dev, res);
> +       if (IS_ERR(keypad_data->base))
> +               return PTR_ERR(keypad_data->base);
> +
> +       keypad_data->clk = devm_clk_get(&pdev->dev, NULL);
> +       if (IS_ERR(keypad_data->clk)) {
> +               dev_err(&pdev->dev, "cannot get clock\n");
> +               return PTR_ERR(keypad_data->clk);
> +       }
> +
> +       error = clk_enable(keypad_data->clk);
> +       if (error) {
> +               dev_err(&pdev->dev, "failed to enable clock\n");
> +               return error;
> +       }
> +
> +       keyscan_stop(keypad_data);
> +
> +       keypad_data->irq = platform_get_irq(pdev, 0);
> +       if (keypad_data->irq < 0) {
> +               dev_err(&pdev->dev, "no IRQ specified\n");
> +               return -EINVAL;
> +       }
> +
> +       error = devm_request_irq(&pdev->dev, keypad_data->irq, keyscan_isr, 0,
> +                                pdev->name, keypad_data);
> +       if (error) {
> +               dev_err(&pdev->dev, "failed to request IRQ\n");
> +               return error;
> +       }
> +
> +       error = input_register_device(input_dev);
> +       if (error) {
> +               dev_err(&pdev->dev, "failed to register input device\n");
> +               return error;
> +       }
> +
> +       platform_set_drvdata(pdev, keypad_data);
> +
> +       device_set_wakeup_capable(&pdev->dev, 1);
> +
> +       return 0;
> +}
> +
> +static int keyscan_suspend(struct device *dev)
> +{
> +       struct platform_device *pdev = to_platform_device(dev);
> +       struct st_keyscan *keypad = platform_get_drvdata(pdev);
> +       struct input_dev *input = keypad->input_dev;
> +
> +       mutex_lock(&input->mutex);
> +
> +       if (device_may_wakeup(dev))
> +               enable_irq_wake(keypad->irq);
> +       else if (input->users)
> +               keyscan_stop(keypad);
> +
> +       mutex_unlock(&input->mutex);
> +       return 0;
> +}
> +
> +static int keyscan_resume(struct device *dev)
> +{
> +       struct platform_device *pdev = to_platform_device(dev);
> +       struct st_keyscan *keypad = platform_get_drvdata(pdev);
> +       struct input_dev *input = keypad->input_dev;
> +       int retval = 0;
> +
> +       mutex_lock(&input->mutex);
> +
> +       if (device_may_wakeup(dev))
> +               disable_irq_wake(keypad->irq);
> +       else if (input->users)
> +               retval = keyscan_start(keypad);
> +
> +       mutex_unlock(&input->mutex);
> +       return retval;
> +}
> +
> +static SIMPLE_DEV_PM_OPS(keyscan_dev_pm_ops, keyscan_suspend, keyscan_resume);
> +
> +static const struct of_device_id keyscan_of_match[] = {
> +       { .compatible = "st,sti-keyscan" },
> +       { },
> +};
> +MODULE_DEVICE_TABLE(of, keyscan_of_match);
> +
> +static struct platform_driver keyscan_device_driver = {
> +       .probe          = keyscan_probe,
> +       .driver         = {
> +               .name   = "st-keyscan",
> +               .pm     = &keyscan_dev_pm_ops,
> +               .of_match_table = of_match_ptr(keyscan_of_match),
> +       }
> +};
> +
> +module_platform_driver(keyscan_device_driver);
> +
> +MODULE_AUTHOR("Stuart Menefy <stuart.menefy@st.com>");
> +MODULE_DESCRIPTION("STMicroelectronics keyscan device driver");
> +MODULE_LICENSE("GPL");
