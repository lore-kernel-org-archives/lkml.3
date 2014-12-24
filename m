Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454AbaLXFYj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 00:24:39 -0500
Received: from mail-bn1on0111.outbound.protection.outlook.com ([157.56.110.111]:56544
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751060AbaLXFYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 00:24:38 -0500
Message-ID: <549A4F19.30201@freescale.com>
Date: Wed, 24 Dec 2014 13:28:57 +0800
From: Liu Ying <Ying.Liu@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Andrzej Hajda <a.hajda@samsung.com>, <dri-devel@lists.freedesktop.org>
CC: <devicetree@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <kernel@pengutronix.de>, <linux-kernel@vger.kernel.org>,
        <mturquette@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <andyshrk@gmail.com>
Subject: Re: [PATCH RFC v3 13/18] drm: panel: Add support for Himax HX8369A
 MIPI DSI panel
References: <1419306399-9387-1-git-send-email-Ying.Liu@freescale.com>
 <1419306399-9387-14-git-send-email-Ying.Liu@freescale.com>
 <54994633.9070007@samsung.com>
In-Reply-To: <54994633.9070007@samsung.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(51704005)(24454002)(377454003)(189002)(479174004)(199003)(99396003)(50986999)(76176999)(65806001)(65956001)(87936001)(64706001)(83506001)(31966008)(20776003)(84676001)(64126003)(6806004)(23676002)(85426001)(47776003)(105606002)(120916001)(77156002)(50466002)(54356999)(36756003)(65816999)(19580395003)(19580405001)(62966003)(4396001)(97736003)(107046002)(106466001)(46102003)(104016003)(2950100001)(77096005)(33656002)(86362001)(575784001)(92566001)(21056001)(68736005)(2004002)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0634;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0634;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:CY1PR0301MB0634;
X-Forefront-PRVS: 04359FAD81
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0634;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2014 05:24:34.0667
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR0301MB0634
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrzej,

On 12/23/2014 06:38 PM, Andrzej Hajda wrote:
> Hi Liu Ying,
>
> On 12/23/2014 04:46 AM, Liu Ying wrote:
>> This patch adds support for Himax HX8369A MIPI DSI panel.
>>
>> Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
>> ---
>> v2->v3:
>>   * Sort the included header files alphabetically.
>>
>> v1->v2:
>>   * Address almost all comments from Thierry Reding.
>>   * Remove several DT properties as they can be implied by the compatible string.
>>   * Add the HIMAX/himax prefixes to the driver's Kconfig name and driver name.
>>   * Move the driver's Makefile entry place to sort the entries alphabetically.
>>   * Reuse several standard DCS functions instead of inventing wheels.
>>   * Move the panel resetting and power logics to the driver probe/remove stages.
>>     This may simplify panel prepare/unprepare hooks. The power consumption should
>>     not change a lot at DPMS since the panel enters sleep mode at that time.
>
> What kind of issues did you have with reset/power logic in
> prepare/unprepare? As I see it should be just a matter of moving
> power on/off functions to prepare/unprepare, am I right?

The issue is that the panel does not work any more if I have the
reset/power logic in prepare/unprepare.  I don't see any valuable
information in dmesg when the system boots up or I unblank/blank
the framebuffer manually via sysfs.  The panel backlight does not
light up.

I think it should be a matter of moving (power-on and reset)/
power-off to prepare/unprepare.

In my system, the power for the panel is always enabled.  So, this
issue is probably caused by the reset operation.

>
>>   * Add the module author.
>>   * Other minor changes, such as coding style issues.
>>
>>   .../devicetree/bindings/panel/himax,hx8369a.txt    |  41 ++
>>   drivers/gpu/drm/panel/Kconfig                      |   5 +
>>   drivers/gpu/drm/panel/Makefile                     |   1 +
>>   drivers/gpu/drm/panel/panel-himax-hx8369a.c        | 573 +++++++++++++++++++++
>>   4 files changed, 620 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/panel/himax,hx8369a.txt
>>   create mode 100644 drivers/gpu/drm/panel/panel-himax-hx8369a.c
>>
>> diff --git a/Documentation/devicetree/bindings/panel/himax,hx8369a.txt b/Documentation/devicetree/bindings/panel/himax,hx8369a.txt
>> new file mode 100644
>> index 0000000..36a2f11
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/panel/himax,hx8369a.txt
>> @@ -0,0 +1,41 @@
>> +Himax HX8369A WVGA 16.7M color TFT single chip driver with internal GRAM
>> +
>> +Himax HX8369A is a WVGA resolution driving controller.
>> +It is designed to provide a single chip solution that combines a source
>> +driver and power supply circuits to drive a TFT dot matrix LCD with
>> +480RGBx864 dots at the maximum.
>> +
>> +The HX8369A supports several interface modes, including MPU MIPI DBI Type
>> +A/B mode, MIPI DPI/DBI Type C mode, MIPI DSI video mode, MIPI DSI command
>> +mode and MDDI mode. The interface mode is selected by the external hardware
>> +pins BS[3:0].
>> +
>> +Currently, only the MIPI DSI video mode is supported.
>> +
>> +Required properties:
>> +  - compatible: should be a panel's compatible string
>> +  - reg: the virtual channel number of a DSI peripheral as described in [1]
>> +  - reset-gpios: a GPIO spec for the reset pin
>> +
>> +Optional properties:
>> +  - vdd1-supply: I/O and interface power supply
>> +  - vdd2-supply: analog power supply
>> +  - vdd3-supply: logic power supply
>> +  - dsi-vcc-supply: DSI and MDDI power supply
>> +  - vpp-supply: OTP programming voltage
>> +  - bs0-gpios: a GPIO spec for the pin BS0
>> +  - bs1-gpios: a GPIO spec for the pin BS1
>> +  - bs2-gpios: a GPIO spec for the pin BS2
>> +  - bs3-gpios: a GPIO spec for the pin BS3
>
> I wonder if it wouldn't be better to replace it by gpio list, sth like:
>       - bs-gpios: list of four GPIO specs for BS0-BS3 pins
>
> At least documentation suggests it [1], it also allows to omit some pins
> if necessary, but it is just suggestion.
>
> [1]: Documentation/devicetree/bindings/gpio/gpio.txt

The suggestion looks good.  I may try to use the gpio list.  Thanks.

>
>> +
>> +[1] Documentation/devicetree/bindings/mipi/dsi/mipi-dsi-bus.txt
>> +
>> +Example:
>> +	panel {
>> +		compatible = "truly,tft480800-16-e-dsi";
>> +		reg = <0>;
>> +		pinctrl-names = "default";
>> +		pinctrl-0 = <&pinctrl_mipi_panel>;
>> +		reset-gpios = <&gpio6 11 GPIO_ACTIVE_LOW>;
>> +		bs2-gpios = <&gpio6 14 GPIO_ACTIVE_HIGH>;
>> +	};
>> diff --git a/drivers/gpu/drm/panel/Kconfig b/drivers/gpu/drm/panel/Kconfig
>> index 024e98e..81b0bf0 100644
>> --- a/drivers/gpu/drm/panel/Kconfig
>> +++ b/drivers/gpu/drm/panel/Kconfig
>> @@ -16,6 +16,11 @@ config DRM_PANEL_SIMPLE
>>   	  that it can be automatically turned off when the panel goes into a
>>   	  low power state.
>>
>> +config DRM_PANEL_HIMAX_HX8369A
>> +	tristate "Himax HX8369A panel"
>> +	depends on OF
>> +	select DRM_MIPI_DSI
>> +
>>   config DRM_PANEL_LD9040
>>   	tristate "LD9040 RGB/SPI panel"
>>   	depends on OF && SPI
>> diff --git a/drivers/gpu/drm/panel/Makefile b/drivers/gpu/drm/panel/Makefile
>> index 4b2a043..d5dbe06 100644
>> --- a/drivers/gpu/drm/panel/Makefile
>> +++ b/drivers/gpu/drm/panel/Makefile
>> @@ -1,4 +1,5 @@
>>   obj-$(CONFIG_DRM_PANEL_SIMPLE) += panel-simple.o
>> +obj-$(CONFIG_DRM_PANEL_HIMAX_HX8369A) += panel-himax-hx8369a.o
>>   obj-$(CONFIG_DRM_PANEL_LD9040) += panel-ld9040.o
>>   obj-$(CONFIG_DRM_PANEL_S6E8AA0) += panel-s6e8aa0.o
>>   obj-$(CONFIG_DRM_PANEL_SHARP_LQ101R1SX01) += panel-sharp-lq101r1sx01.o
>> diff --git a/drivers/gpu/drm/panel/panel-himax-hx8369a.c b/drivers/gpu/drm/panel/panel-himax-hx8369a.c
>> new file mode 100644
>> index 0000000..6efce8e
>> --- /dev/null
>> +++ b/drivers/gpu/drm/panel/panel-himax-hx8369a.c
>> @@ -0,0 +1,573 @@
>> +/*
>> + * Himax HX8369A panel driver.
>> + *
>> + * Copyright (C) 2011-2014 Freescale Semiconductor, Inc.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * This driver is based on Samsung s6e8aa0 panel driver.
>> + */
>> +
>> +#include <drm/drmP.h>
>> +#include <drm/drm_mipi_dsi.h>
>> +#include <drm/drm_panel.h>
>> +
>> +#include <linux/gpio/consumer.h>
>> +#include <linux/of_device.h>
>> +#include <linux/regulator/consumer.h>
>> +
>> +#include <video/mipi_display.h>
>> +#include <video/of_videomode.h>
>> +#include <video/videomode.h>
>> +
>> +#define WRDISBV		0x51
>> +#define WRCTRLD		0x53
>> +#define WRCABC		0x55
>> +#define SETPOWER	0xb1
>> +#define SETDISP		0xb2
>> +#define SETCYC		0xb4
>> +#define SETVCOM		0xb6
>> +#define SETEXTC		0xb9
>> +#define SETMIPI		0xba
>> +#define SETPANEL	0xcc
>> +#define SETGIP		0xd5
>> +#define SETGAMMA	0xe0
>> +
>> +#define HX8369A_MIN_BRIGHTNESS	0x00
>> +#define HX8369A_MAX_BRIGHTNESS	0xff
>> +
>> +enum hx8369a_mpu_interface {
>> +	HX8369A_DBI_TYPE_A_8BIT,
>> +	HX8369A_DBI_TYPE_A_9BIT,
>> +	HX8369A_DBI_TYPE_A_16BIT,
>> +	HX8369A_DBI_TYPE_A_18BIT,
>> +	HX8369A_DBI_TYPE_B_8BIT,
>> +	HX8369A_DBI_TYPE_B_9BIT,
>> +	HX8369A_DBI_TYPE_B_16BIT,
>> +	HX8369A_DBI_TYPE_B_18BIT,
>> +	HX8369A_DSI_CMD_MODE,
>> +	HX8369A_DBI_TYPE_B_24BIT,
>> +	HX8369A_DSI_VIDEO_MODE,
>> +	HX8369A_MDDI,
>> +	HX8369A_DPI_DBI_TYPE_C_OPT1,
>> +	HX8369A_DPI_DBI_TYPE_C_OPT2,
>> +	HX8369A_DPI_DBI_TYPE_C_OPT3
>> +};
>> +
>> +enum hx8369a_resolution {
>> +	HX8369A_RES_480_864,
>> +	HX8369A_RES_480_854,
>> +	HX8369A_RES_480_800,
>> +	HX8369A_RES_480_640,
>> +	HX8369A_RES_360_640,
>> +	HX8369A_RES_480_720,
>> +};
>> +
>> +struct hx8369a_panel_desc {
>> +	const struct drm_display_mode *mode;
>> +
>> +	/* ms */
>> +	unsigned int power_on_delay;
>> +	unsigned int reset_delay;
>> +
>> +	unsigned int dsi_lanes;
>> +};
>> +
>> +struct hx8369a {
>> +	struct device *dev;
>> +	struct drm_panel panel;
>> +
>> +	const struct hx8369a_panel_desc *pd;
>> +
>> +	struct regulator_bulk_data supplies[5];
>> +	struct gpio_desc *reset_gpio;
>> +	struct gpio_desc *bs_gpio[4];
>> +	u8 res_sel;
>> +};
>> +
>> +static inline struct hx8369a *panel_to_hx8369a(struct drm_panel *panel)
>> +{
>> +	return container_of(panel, struct hx8369a, panel);
>> +}
>> +
>> +static void hx8369a_dcs_write(struct hx8369a *ctx, const char *func,
>> +			      const void *data, size_t len)
>> +{
>> +	struct mipi_dsi_device *dsi = to_mipi_dsi_device(ctx->dev);
>> +	ssize_t ret;
>> +
>> +	ret = mipi_dsi_dcs_write_buffer(dsi, data, len);
>> +	if (ret < 0)
>> +		dev_err(ctx->dev, "%s failed: %d\n", func, ret);
>
> Your only reaction to transmission errors is to log error, no error
> propagation. I think it is not the best approach. I suggest to implement
> error propagation either the way I did in s6e8aa0, either the way
> Thierry suggests. Of course I prefer my method as it significantly
> reduces code bloat due to error checking, but it is up to you.

I'll implement error propagation in the next version.

>
>> +}
>> +
>> +#define hx8369a_dcs_write_seq(ctx, seq...) \
>> +({ \
>> +	const u8 d[] = { seq }; \
>> +	BUILD_BUG_ON_MSG(ARRAY_SIZE(d) > 64, "DCS sequence too big for stack"); \
>> +	hx8369a_dcs_write(ctx, __func__, d, ARRAY_SIZE(d)); \
>> +})
>> +
>> +#define hx8369a_dcs_write_seq_static(ctx, seq...) \
>> +({ \
>> +	static const u8 d[] = { seq }; \
>> +	hx8369a_dcs_write(ctx, __func__, d, ARRAY_SIZE(d)); \
>> +})
>> +
>> +static void hx8369a_dsi_set_display_related_register(struct hx8369a *ctx)
>> +{
>> +	u8 sec_p = (ctx->res_sel << 4) | 0x03;
>> +
>> +	hx8369a_dcs_write_seq(ctx, SETDISP, 0x00, sec_p, 0x03,
>> +		0x03, 0x70, 0x00, 0xff, 0x00, 0x00, 0x00, 0x00,
>> +		0x03, 0x03, 0x00, 0x01);
>> +}
>> +
>> +static void hx8369a_dsi_set_display_waveform_cycle(struct hx8369a *ctx)
>> +{
>> +	hx8369a_dcs_write_seq_static(ctx, SETCYC, 0x00, 0x1d, 0x5f, 0x0e, 0x06);
>> +}
>> +
>> +static void hx8369a_dsi_set_gip(struct hx8369a *ctx)
>> +{
>> +	hx8369a_dcs_write_seq_static(ctx, SETGIP, 0x00, 0x04, 0x03, 0x00, 0x01,
>> +				0x05, 0x1c, 0x70, 0x01, 0x03, 0x00, 0x00, 0x40,
>> +				0x06, 0x51, 0x07, 0x00, 0x00, 0x41, 0x06, 0x50,
>> +				0x07, 0x07, 0x0f, 0x04);
>> +}
>> +
>> +static void hx8369a_dsi_set_power(struct hx8369a *ctx)
>> +{
>> +	hx8369a_dcs_write_seq_static(ctx, SETPOWER, 0x01, 0x00, 0x34, 0x06, 0x00,
>> +				0x0f, 0x0f, 0x2a, 0x32, 0x3f, 0x3f, 0x07, 0x3a,
>> +				0x01, 0xe6, 0xe6, 0xe6, 0xe6, 0xe6);
>> +}
>> +
>> +static void hx8369a_dsi_set_vcom_voltage(struct hx8369a *ctx)
>> +{
>> +	hx8369a_dcs_write_seq_static(ctx, SETVCOM, 0x56, 0x56);
>> +}
>> +
>> +static void hx8369a_dsi_set_panel(struct hx8369a *ctx)
>> +{
>> +	hx8369a_dcs_write_seq_static(ctx, SETPANEL, 0x02);
>> +}
>> +
>> +static void hx8369a_dsi_set_gamma_curve(struct hx8369a *ctx)
>> +{
>> +	hx8369a_dcs_write_seq_static(ctx, SETGAMMA, 0x00, 0x1d, 0x22, 0x38, 0x3d,
>> +				0x3f, 0x2e, 0x4a, 0x06, 0x0d, 0x0f, 0x13, 0x15,
>> +				0x13, 0x16, 0x10, 0x19, 0x00, 0x1d, 0x22, 0x38,
>> +				0x3d, 0x3f, 0x2e, 0x4a, 0x06, 0x0d, 0x0f, 0x13,
>> +				0x15, 0x13, 0x16, 0x10, 0x19);
>> +}
>> +
>> +static void hx8369a_dsi_set_mipi(struct hx8369a *ctx)
>> +{
>> +	u8 eleventh_p = ctx->pd->dsi_lanes == 2 ? 0x11 : 0x10;
>> +
>> +	hx8369a_dcs_write_seq(ctx, SETMIPI, 0x00, 0xa0, 0xc6, 0x00, 0x0a, 0x00,
>> +			0x10, 0x30, 0x6f, 0x02, eleventh_p, 0x18, 0x40);
>> +}
>> +
>> +static void hx8369a_dsi_set_interface_pixel_fomat(struct hx8369a *ctx)
>> +{
>> +	struct mipi_dsi_device *dsi = to_mipi_dsi_device(ctx->dev);
>> +	u8 format;
>> +	int ret;
>> +
>> +	if (dsi->format == MIPI_DSI_FMT_RGB888)
>> +		format = 0x77;
>> +	else if (dsi->format == MIPI_DSI_FMT_RGB565)
>> +		format = 0x55;
>> +	else
>> +		format = 0x66;
>
> Just nitpick, switch fits better here.

Accepted.

>
>> +
>> +	ret = mipi_dsi_dcs_set_pixel_format(dsi, format);
>> +	if (ret < 0)
>> +		dev_err(ctx->dev, "%s failed: %d\n", __func__, ret);
>> +}
>> +
>> +static void hx8369a_dsi_set_column_address(struct hx8369a *ctx)
>> +{
>> +	struct mipi_dsi_device *dsi = to_mipi_dsi_device(ctx->dev);
>> +	const struct drm_display_mode *mode = ctx->pd->mode;
>> +	int ret;
>> +
>> +	ret = mipi_dsi_dcs_set_column_address(dsi, 0, mode->hdisplay - 1);
>> +	if (ret < 0)
>> +		dev_err(ctx->dev, "%s failed: %d\n", __func__, ret);
>> +}
>> +
>> +static void hx8369a_dsi_set_page_address(struct hx8369a *ctx)
>> +{
>> +	struct mipi_dsi_device *dsi = to_mipi_dsi_device(ctx->dev);
>> +	const struct drm_display_mode *mode = ctx->pd->mode;
>> +	int ret;
>> +
>> +	ret = mipi_dsi_dcs_set_page_address(dsi, 0, mode->vdisplay - 1);
>> +	if (ret < 0)
>> +		dev_err(ctx->dev, "%s failed: %d\n", __func__, ret);
>> +}
>> +
>> +static void hx8369a_dsi_write_display_brightness(struct hx8369a *ctx, u8 brightness)
>> +{
>> +	hx8369a_dcs_write_seq(ctx, WRDISBV, brightness);
>> +}
>> +
>> +static void hx8369a_dsi_write_cabc(struct hx8369a *ctx)
>> +{
>> +	hx8369a_dcs_write_seq_static(ctx, WRCABC, 0x01);
>> +}
>> +
>> +static void hx8369a_dsi_write_control_display(struct hx8369a *ctx)
>> +{
>> +	hx8369a_dcs_write_seq_static(ctx, WRCTRLD, 0x24);
>> +}
>> +
>> +static void hx8369a_dsi_panel_init(struct hx8369a *ctx)
>> +{
>> +	hx8369a_dsi_set_display_related_register(ctx);
>> +	hx8369a_dsi_set_display_waveform_cycle(ctx);
>> +	hx8369a_dsi_set_gip(ctx);
>> +	hx8369a_dsi_set_power(ctx);
>> +	hx8369a_dsi_set_vcom_voltage(ctx);
>> +	hx8369a_dsi_set_panel(ctx);
>> +	hx8369a_dsi_set_gamma_curve(ctx);
>> +	hx8369a_dsi_set_mipi(ctx);
>> +	hx8369a_dsi_set_interface_pixel_fomat(ctx);
>> +	hx8369a_dsi_set_column_address(ctx);
>> +	hx8369a_dsi_set_page_address(ctx);
>> +	hx8369a_dsi_write_cabc(ctx);
>> +	hx8369a_dsi_write_control_display(ctx);
>> +}
>> +
>> +static void hx8369a_dsi_set_extension_command(struct hx8369a *ctx)
>> +{
>> +	hx8369a_dcs_write_seq_static(ctx, SETEXTC, 0xff, 0x83, 0x69);
>> +}
>> +
>> +static void hx8369a_dsi_set_maximum_return_packet_size(struct hx8369a *ctx,
>> +						       u16 size)
>> +{
>> +	struct mipi_dsi_device *dsi = to_mipi_dsi_device(ctx->dev);
>> +	int ret;
>> +
>> +	ret = mipi_dsi_set_maximum_return_packet_size(dsi, size);
>> +	if (ret < 0)
>> +		dev_err(ctx->dev,
>> +			"error %d setting maximum return packet size to %d\n",
>> +			ret, size);
>> +}
>> +
>> +static int hx8369a_dsi_set_sequence(struct hx8369a *ctx)
>> +{
>> +	struct mipi_dsi_device *dsi = to_mipi_dsi_device(ctx->dev);
>> +	int ret;
>> +
>> +	hx8369a_dsi_set_extension_command(ctx);
>> +	hx8369a_dsi_set_maximum_return_packet_size(ctx, 4);
>> +	hx8369a_dsi_panel_init(ctx);
>> +
>> +	ret = mipi_dsi_dcs_exit_sleep_mode(dsi);
>> +	if (ret < 0) {
>> +		dev_err(ctx->dev, "failed to exit sleep mode: %d\n", ret);
>> +		return ret;
>> +	}
>> +
>> +	ret = mipi_dsi_dcs_set_display_on(dsi);
>> +	if (ret < 0) {
>> +		dev_err(ctx->dev, "failed to set display on: %d\n", ret);
>> +		return ret;
>> +	}
>> +
>> +	/*
>> +	 * It's necessary to wait 120msec after sending the Sleep Out
>> +	 * command before Sleep In command can be sent, according to
>> +	 * the HX8369A data sheet.
>> +	 */
>> +	msleep(120);
>> +
>> +	return 0;
>> +}
>> +
>> +static int hx8369a_dsi_disable(struct drm_panel *panel)
>> +{
>> +	struct hx8369a *ctx = panel_to_hx8369a(panel);
>> +	hx8369a_dsi_write_display_brightness(ctx, HX8369A_MIN_BRIGHTNESS);
>> +	return 0;
>> +}
>> +
>> +static int hx8369a_dsi_unprepare(struct drm_panel *panel)
>> +{
>> +	struct hx8369a *ctx = panel_to_hx8369a(panel);
>> +	struct mipi_dsi_device *dsi = to_mipi_dsi_device(ctx->dev);
>> +	int ret;
>> +
>> +	ret = mipi_dsi_dcs_enter_sleep_mode(dsi);
>> +	if (ret < 0) {
>> +		dev_err(ctx->dev, "failed to enter sleep mode: %d\n", ret);
>> +		return ret;
>> +	}
>> +
>> +	ret = mipi_dsi_dcs_set_display_off(dsi);
>> +	if (ret < 0) {
>> +		dev_err(ctx->dev, "failed to set display off: %d\n", ret);
>> +		return ret;
>> +	}
>> +
>> +	/*
>> +	 * This is to allow time for the supply voltages and clock
>> +	 * circuits to stablize, according to the HX8369A data sheet.
>> +	 */
>> +	msleep(5);
>> +
>> +	return ret;
>> +}
>> +
>> +static int hx8369a_dsi_prepare(struct drm_panel *panel)
>> +{
>> +	struct hx8369a *ctx = panel_to_hx8369a(panel);
>> +	return hx8369a_dsi_set_sequence(ctx);
>> +}
>> +
>> +static int hx8369a_dsi_enable(struct drm_panel *panel)
>> +{
>> +	struct hx8369a *ctx = panel_to_hx8369a(panel);
>> +	hx8369a_dsi_write_display_brightness(ctx, HX8369A_MAX_BRIGHTNESS);
>> +	return 0;
>> +}
>> +
>> +static int hx8369a_get_modes(struct drm_panel *panel)
>> +{
>> +	struct drm_connector *connector = panel->connector;
>> +	struct drm_device *drm = panel->drm;
>> +	struct hx8369a *ctx = panel_to_hx8369a(panel);
>> +	struct drm_display_mode *mode;
>> +	const struct drm_display_mode *m = ctx->pd->mode;
>> +
>> +	mode = drm_mode_duplicate(drm, m);
>> +	if (!mode) {
>> +		dev_err(drm->dev, "failed to add mode %ux%u@%u\n",
>> +			m->hdisplay, m->vdisplay, m->vrefresh);
>> +		return 0;
>> +	}
>> +
>> +	drm_mode_set_name(mode);
>> +	mode->type = DRM_MODE_TYPE_DRIVER | DRM_MODE_TYPE_PREFERRED;
>> +
>> +	connector->display_info.bpc = 8;
>> +	connector->display_info.width_mm = mode->width_mm;
>> +	connector->display_info.height_mm = mode->height_mm;
>> +
>> +	drm_mode_probed_add(connector, mode);
>> +
>> +	return 1;
>> +}
>> +
>> +static const struct drm_panel_funcs hx8369a_dsi_drm_funcs = {
>> +	.disable = hx8369a_dsi_disable,
>> +	.unprepare = hx8369a_dsi_unprepare,
>> +	.prepare = hx8369a_dsi_prepare,
>> +	.enable = hx8369a_dsi_enable,
>> +	.get_modes = hx8369a_get_modes,
>> +};
>> +
>> +static int hx8369a_power_on(struct hx8369a *ctx)
>> +{
>> +	int ret;
>> +
>> +	ret = regulator_bulk_enable(ARRAY_SIZE(ctx->supplies), ctx->supplies);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	msleep(ctx->pd->power_on_delay);
>> +
>> +	gpiod_set_value(ctx->reset_gpio, 1);
>> +	usleep_range(50, 60);
>> +	gpiod_set_value(ctx->reset_gpio, 0);
>> +
>> +	msleep(ctx->pd->reset_delay);
>> +
>> +	return 0;
>> +}
>> +
>> +static int hx8369a_power_off(struct hx8369a *ctx)
>> +{
>> +	return regulator_bulk_disable(ARRAY_SIZE(ctx->supplies), ctx->supplies);;
>> +}
>> +
>> +static int hx8369a_vm_to_res_sel(struct hx8369a *ctx)
>> +{
>> +	const struct drm_display_mode *mode = ctx->pd->mode;
>> +
>> +	switch (mode->hdisplay) {
>> +	case 480:
>> +		switch (mode->vdisplay) {
>> +		case 864:
>> +			ctx->res_sel = HX8369A_RES_480_864;
>> +			break;
>> +		case 854:
>> +			ctx->res_sel = HX8369A_RES_480_854;
>> +			break;
>> +		case 800:
>> +			ctx->res_sel = HX8369A_RES_480_800;
>> +			break;
>> +		case 640:
>> +			ctx->res_sel = HX8369A_RES_480_640;
>> +			break;
>> +		case 720:
>> +			ctx->res_sel = HX8369A_RES_480_720;
>> +			break;
>> +		default:
>> +			break;
>> +		}
>> +		break;
>> +	case 360:
>> +		if (mode->vdisplay == 640)
>> +			ctx->res_sel = HX8369A_RES_360_640;
>> +		break;
>> +	default:
>> +		break;
>> +	}
>> +
>> +	return 0;
>> +}
>
> Function always returns 0, you can make it void, or return error
> in case mode is not supported. As I see the mode is hardcoded in the
> driver so the 1st solutions fits here better.

I'll take the 1st solution.

>
>> +
>> +static const struct drm_display_mode truly_tft480800_16_e_mode = {
>> +	.clock = 26400,
>> +	.hdisplay = 480,
>> +	.hsync_start = 480 + 8,
>> +	.hsync_end = 480 + 8 + 8,
>> +	.htotal = 480 + 8 + 8 + 8,
>> +	.vdisplay = 800,
>> +	.vsync_start = 800 + 6,
>> +	.vsync_end = 800 + 6 + 6,
>> +	.vtotal = 800 + 6 + 6 + 6,
>> +	.vrefresh = 60,
>> +	.width_mm = 45,
>> +	.height_mm = 76,
>> +};
>> +
>> +static const struct hx8369a_panel_desc truly_tft480800_16_e_dsi = {
>> +	.mode = &truly_tft480800_16_e_mode,
>> +	.power_on_delay = 10,
>> +	.reset_delay = 10,
>> +	.dsi_lanes = 2,
>> +};
>> +
>> +static const struct of_device_id hx8369a_dsi_of_match[] = {
>> +	{
>> +		.compatible = "truly,tft480800-16-e-dsi",
>> +		.data = &truly_tft480800_16_e_dsi,
>> +	}, {
>> +		/* sentinel */
>> +	},
>> +};
>> +MODULE_DEVICE_TABLE(of, hx8369a_dsi_of_match);
>> +
>> +static int hx8369a_dsi_probe(struct mipi_dsi_device *dsi)
>> +{
>> +	struct device *dev = &dsi->dev;
>> +	const struct of_device_id *of_id =
>> +			of_match_device(hx8369a_dsi_of_match, dev);
>> +	struct hx8369a *ctx;
>> +	int ret, i;
>> +	char bs[4];
>> +
>> +	ctx = devm_kzalloc(dev, sizeof(*ctx), GFP_KERNEL);
>> +	if (!ctx)
>> +		return -ENOMEM;
>> +
>> +	ctx->dev = dev;
>> +
>> +	if (of_id) {
>> +		ctx->pd = of_id->data;
>> +	} else {
>> +		dev_err(dev, "cannot find compatible device\n");
>> +		return -ENODEV;
>> +	}
>> +
>> +	ret = hx8369a_vm_to_res_sel(ctx);
>> +	if (ret < 0)
>> +		return ret;
>
> We know it will always succeed, don't we?

Yes. I'll modify the function to return void.

>
>> +
>> +	ctx->supplies[0].supply = "vdd1";
>> +	ctx->supplies[1].supply = "vdd2";
>> +	ctx->supplies[2].supply = "vdd3";
>> +	ctx->supplies[3].supply = "dsi-vcc";
>> +	ctx->supplies[4].supply = "vpp";
>> +	ret = devm_regulator_bulk_get(dev, ARRAY_SIZE(ctx->supplies),
>> +				      ctx->supplies);
>> +	if (ret < 0) {
>> +		dev_err(dev, "failed to get regulators: %d\n", ret);
>
> Just nitpicking, here and later, in case of deferred probing you will
> have error logged, but it should be at most dev_info.

I'll change to use dev_info.

>
>> +		return ret;
>> +	}
>> +
>> +	ctx->reset_gpio = devm_gpiod_get(dev, "reset", GPIOD_OUT_LOW);
>> +	if (IS_ERR(ctx->reset_gpio)) {
>> +		dev_err(dev, "cannot get reset-gpios %ld\n",
>> +			PTR_ERR(ctx->reset_gpio));
>> +		return PTR_ERR(ctx->reset_gpio);
>> +	}
>> +
>> +	for (i = 0; i < 4; i++) {
>> +		snprintf(bs, sizeof(bs), "bs%d", i);
>> +		ctx->bs_gpio[i] = devm_gpiod_get(dev, bs, GPIOD_OUT_HIGH);
>> +
>> +		dev_dbg(dev, "bs%d-gpio is configured\n", i);
>> +	}
>> +
>> +	ret = hx8369a_power_on(ctx);
>> +	if (ret < 0) {
>> +		dev_err(dev, "cannot power on\n");
>> +		return ret;
>> +	}
>> +
>> +	drm_panel_init(&ctx->panel);
>> +	ctx->panel.dev = dev;
>> +	ctx->panel.funcs = &hx8369a_dsi_drm_funcs;
>> +
>> +	ret = drm_panel_add(&ctx->panel);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	mipi_dsi_set_drvdata(dsi, ctx);
>> +
>> +	dsi->channel = 0;
>> +	dsi->lanes = ctx->pd->dsi_lanes;
>> +	dsi->format = MIPI_DSI_FMT_RGB888;
>> +	dsi->mode_flags = MIPI_DSI_MODE_VIDEO |
>> +			  MIPI_DSI_MODE_VIDEO_BURST |
>> +			  MIPI_DSI_MODE_VIDEO_SYNC_PULSE;
>> +	ret = mipi_dsi_attach(dsi);
>> +	if (ret < 0)
>> +		drm_panel_remove(&ctx->panel);
>> +
>> +	return ret;
>> +}
>> +
>> +static int hx8369a_dsi_remove(struct mipi_dsi_device *dsi)
>> +{
>> +	struct hx8369a *ctx = mipi_dsi_get_drvdata(dsi);
>> +
>> +	mipi_dsi_detach(dsi);
>> +	drm_panel_remove(&ctx->panel);
>> +	return hx8369a_power_off(ctx);
>
> The sequence here is OK, but as I lurked into dsi host code[1]
> it seems dsi host lacks synchronization with drm in
> dw_mipi_dsi_host_detach before removing the panel, but it should
> be fixed in the host controller.
>
> [1]: [PATCH RFC v4 12/21] drm/bridge: Add Synopsys DesignWare MIPI DSI
> host controller driver

Indeed, I need to remove 'dsi->panel = NULL;' in
dw_mipi_dsi_host_detach().

Regards,
Liu Ying

>
>
> Regards
> Andrzej
>
>
>> +}
>> +
>> +static struct mipi_dsi_driver hx8369a_dsi_driver = {
>> +	.probe = hx8369a_dsi_probe,
>> +	.remove = hx8369a_dsi_remove,
>> +	.driver = {
>> +		.name = "panel-hx8369a-dsi",
>> +		.of_match_table = hx8369a_dsi_of_match,
>> +	},
>> +};
>> +module_mipi_dsi_driver(hx8369a_dsi_driver);
>> +
>> +MODULE_DESCRIPTION("Himax HX8369A panel driver");
>> +MODULE_AUTHOR("Liu Ying <Ying.Liu@freescale.com>");
>> +MODULE_LICENSE("GPL v2");
>>
>
