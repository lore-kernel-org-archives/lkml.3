Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbaLQKWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 05:22:53 -0500
Received: from mail-bn1bn0102.outbound.protection.outlook.com ([157.56.110.102]:45120
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751911AbaLQKWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 05:22:50 -0500
Message-ID: <54915A78.9040904@freescale.com>
Date: Wed, 17 Dec 2014 18:27:04 +0800
From: Liu Ying <Ying.Liu@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: <dri-devel@lists.freedesktop.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <p.zabel@pengutronix.de>, <shawn.guo@linaro.org>,
        <kernel@pengutronix.de>, <linux@arm.linux.org.uk>,
        <mturquette@linaro.org>, <airlied@linux.ie>
Subject: Re: [PATCH RFC 10/15] drm: panel: Add support for Himax HX8369A MIPI
 DSI panel
References: <1418200648-32656-1-git-send-email-Ying.Liu@freescale.com>
 <1418200648-32656-11-git-send-email-Ying.Liu@freescale.com>
 <20141210140334.GE23558@ulmo.nvidia.com>
In-Reply-To: <20141210140334.GE23558@ulmo.nvidia.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(51704005)(189002)(164054003)(24454002)(479174004)(377454003)(83506001)(65956001)(4396001)(50466002)(99396003)(46102003)(77096005)(23746002)(110136001)(104016003)(105606002)(62966003)(64706001)(65806001)(20776003)(36756003)(92566001)(77156002)(47776003)(19580405001)(21056001)(107046002)(59896002)(87936001)(65816999)(6806004)(31966008)(84676001)(64126003)(19580395003)(97736003)(50986999)(120916001)(99136001)(33656002)(106466001)(68736005)(80316001)(85426001)(2950100001)(54356999)(86362001)(76176999)(87266999)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0627;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0627;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1PR0301MB0627;
X-Forefront-PRVS: 042857DBB5
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0627;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/10/2014 10:03 PM, Thierry Reding wrote:
> On Wed, Dec 10, 2014 at 04:37:23PM +0800, Liu Ying wrote:
>> This patch adds support for Himax HX8369A MIPI DSI panel.
>>
>> Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
>> ---
>>   .../devicetree/bindings/panel/himax,hx8369a.txt    |  86 +++
>>   drivers/gpu/drm/panel/Kconfig                      |   6 +
>>   drivers/gpu/drm/panel/Makefile                     |   1 +
>>   drivers/gpu/drm/panel/panel-hx8369a.c              | 627 +++++++++++++++++++++
>>   4 files changed, 720 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/panel/himax,hx8369a.txt
>>   create mode 100644 drivers/gpu/drm/panel/panel-hx8369a.c
>>
>> diff --git a/Documentation/devicetree/bindings/panel/himax,hx8369a.txt b/Documentation/devicetree/bindings/panel/himax,hx8369a.txt
>> new file mode 100644
>> index 0000000..6fe251e
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/panel/himax,hx8369a.txt
>> @@ -0,0 +1,86 @@
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
>> +  - compatible: "himax,hx8369a-dsi"
>> +  - reg: the virtual channel number of a DSI peripheral
>> +  - reset-gpios: a GPIO spec for the reset pin
>> +  - data-lanes: the data lane number of a DSI peripheral
>
> This is implied by the compatible already.

Accepted.

>
>> +  - display-timings: timings for the connected panel as described by [1]
>
> Also implied by the compatible value.

Accepted.

>
>> +  - bs: the interface mode number described by the following table
>> +        --------------------------
>> +       | DBI_TYPE_A_8BIT     |  0 |
>> +       | DBI_TYPE_A_9BIT     |  1 |
>> +       | DBI_TYPE_A_16BIT    |  2 |
>> +       | DBI_TYPE_A_18BIT    |  3 |
>> +       | DBI_TYPE_B_8BIT     |  4 |
>> +       | DBI_TYPE_B_9BIT     |  5 |
>> +       | DBI_TYPE_B_16BIT    |  6 |
>> +       | DBI_TYPE_B_18BIT    |  7 |
>> +       | DSI_CMD_MODE        |  8 |
>> +       | DBI_TYPE_B_24BIT    |  9 |
>> +       | DSI_VIDEO_MODE      | 10 |
>> +       | MDDI                | 11 |
>> +       | DPI_DBI_TYPE_C_OPT1 | 12 |
>> +       | DPI_DBI_TYPE_C_OPT2 | 13 |
>> +       | DPI_DBI_TYPE_C_OPT3 | 14 |
>> +        --------------------------
>
> Can this not be inferred by the driver? If it's a DSI driver can't it
> select between DSI_VIDEO_MODE or DSI_CMD_MODE based on its capabilities?
> That is, if the panel driver can setup command mode, shouldn't it be
> using command mode in that case? And use DSI_VIDEO_MODE otherwise?

I may remove this property.
But, I choose not to add any logic in the host and slave drivers to
handle the interface mode selection at present, since I only support
the DSI_VIDEO_MODE now. Is this acceptable?

>
>> +Optional properties:
>> +  - power-on-delay: delay after turning regulators on [ms]
>> +  - reset-delay: delay after reset sequence [ms]
>
> Surely these are constant for this panel?

Accepted.

>
>> +  - panel-width-mm: physical panel width [mm]
>> +  - panel-height-mm: physical panel height [mm]
>
> These are also implied by compatible.
>

Accepted.

>> +Example:
>> +	panel@0 {
>> +		compatible = "himax,hx8369a-dsi";
>> +		reg = <0>;
>> +		pinctrl-names = "default";
>> +		pinctrl-0 = <&pinctrl_mipi_panel>;
>> +		reset-gpios = <&gpio6 11 GPIO_ACTIVE_LOW>;
>> +		reset-delay = <120>;
>> +		bs2-gpios = <&gpio6 14 GPIO_ACTIVE_HIGH>;
>> +		data-lanes = <2>;
>> +		panel-width-mm = <45>;
>> +		panel-height-mm = <76>;
>> +		bs = <10>;
>> +		status = "okay";
>
> status = "okay" is the default, so it probably shouldn't be in this
> example.
>

Accepted.

>> diff --git a/drivers/gpu/drm/panel/Kconfig b/drivers/gpu/drm/panel/Kconfig
>> index 024e98e..f1a5b58 100644
>> --- a/drivers/gpu/drm/panel/Kconfig
>> +++ b/drivers/gpu/drm/panel/Kconfig
>> @@ -40,4 +40,10 @@ config DRM_PANEL_SHARP_LQ101R1SX01
>>   	  To compile this driver as a module, choose M here: the module
>>   	  will be called panel-sharp-lq101r1sx01.
>>
>> +config DRM_PANEL_HX8369A
>> +	tristate "HX8369A panel"
>> +	depends on OF
>> +	select DRM_MIPI_DSI
>> +	select VIDEOMODE_HELPERS
>> +
>
> This should be sorted alphabetically. I think it would also be a good
> idea to use a HIMAX prefix here, just to reduce the potential for name
> clashes.

Accepted.

>
>> diff --git a/drivers/gpu/drm/panel/Makefile b/drivers/gpu/drm/panel/Makefile
>> index 4b2a043..d6768ca 100644
>> --- a/drivers/gpu/drm/panel/Makefile
>> +++ b/drivers/gpu/drm/panel/Makefile
>> @@ -2,3 +2,4 @@ obj-$(CONFIG_DRM_PANEL_SIMPLE) += panel-simple.o
>>   obj-$(CONFIG_DRM_PANEL_LD9040) += panel-ld9040.o
>>   obj-$(CONFIG_DRM_PANEL_S6E8AA0) += panel-s6e8aa0.o
>>   obj-$(CONFIG_DRM_PANEL_SHARP_LQ101R1SX01) += panel-sharp-lq101r1sx01.o
>> +obj-$(CONFIG_DRM_PANEL_HX8369A) += panel-hx8369a.o
>
> Needs to be sorted alphabetically, too.

Accepted.

>
>> diff --git a/drivers/gpu/drm/panel/panel-hx8369a.c b/drivers/gpu/drm/panel/panel-hx8369a.c
> [...]
>> +#include <drm/drmP.h>
>> +#include <drm/drm_mipi_dsi.h>
>> +#include <drm/drm_panel.h>
>> +
>> +#include <linux/gpio/consumer.h>
>> +#include <linux/regulator/consumer.h>
>> +
>> +#include <video/mipi_display.h>
>> +#include <video/of_videomode.h>
>> +#include <video/videomode.h>
>> +
>> +#define SETCLUMN_ADDR	0x2a
>> +#define SETPAGE_ADDR 	0x2b
>> +#define SETPIXEL_FMT 	0x3a
>
> There are standard DCS functions for these now.

Accepted.

>
>> +#define WRDISBV	     	0x51
>> +#define WRCTRLD	     	0x53
>> +#define WRCABC	     	0x55
>> +#define SETPOWER     	0xb1
>> +#define SETDISP	     	0xb2
>> +#define SETCYC	     	0xb4
>> +#define SETVCOM	     	0xb6
>> +#define SETEXTC	     	0xb9
>> +#define SETMIPI	     	0xba
>> +#define SETPANEL     	0xcc
>> +#define SETGIP	     	0xd5
>> +#define SETGAMMA     	0xe0
>
> Watch your indentation here and above. Use tabs and spaces more
> consistently.

Accepted.

>
>> +static bool hx8369a_is_dsi_interface(struct hx8369a *ctx) {
>
> Coding style: opening { goes on a line by itself.

Accepted.

>
>> +	if (ctx->mpu_interface == HX8369A_DSI_VIDEO_MODE ||
>> +	    ctx->mpu_interface == HX8369A_DSI_CMD_MODE)
>> +		return true;
>> +
>> +	return false;
>> +}
>> +
>> +static void hx8369a_dcs_write(struct hx8369a *ctx, const void *data, size_t len)
>> +{
>> +	struct mipi_dsi_device *dsi = to_mipi_dsi_device(ctx->dev);
>> +	ssize_t ret;
>> +
>> +	ret = mipi_dsi_dcs_write_buffer(dsi, data, len);
>> +	if (ret < 0)
>> +		dev_err(ctx->dev, "error %zd writing dcs seq: %*ph\n", ret, len,
>> +			data);
>> +}
>
> You really shouldn't have based this on the Samsung drivers. You really
> should do proper error handling here. These error messages are going to
> be completely cryptic and very hard for people to look up in the driver
> as opposed to a simple specific error message like:
>
> 	dev_err(ctx->dev, "failed to do XYZ: %d\n", err);
>
> which will immediately let you look up the right location without a need
> to decode the hexdump and look for the correct array.

Accepted.

>
>> +#define hx8369a_dcs_write_seq(ctx, seq...) \
>> +({\
>> +	const u8 d[] = { seq };\
>> +	BUILD_BUG_ON_MSG(ARRAY_SIZE(d) > 64, "DCS sequence too big for stack");\
>> +	hx8369a_dcs_write(ctx, d, ARRAY_SIZE(d));\
>> +})
>> +
>> +#define hx8369a_dcs_write_seq_static(ctx, seq...) \
>> +({\
>> +	static const u8 d[] = { seq };\
>> +	hx8369a_dcs_write(ctx, d, ARRAY_SIZE(d));\
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
>
> This and all of the other initialization functions below completely
> ignore any errors. Other than spamming the kernel log the user won't get
> any indication of anything going wrong.
>
>> +static void hx8369a_dsi_set_interface_pixel_fomat(struct hx8369a *ctx)
>> +{
> [...]
>> +}
>> +
>> +static void hx8369a_dsi_set_column_address(struct hx8369a *ctx)
>> +{
> [...]
>> +}
>> +
>> +static void hx8369a_dsi_set_page_address(struct hx8369a *ctx)
>> +{
> [...]
>> +}
>
> We have standard functions for these, please use them.
>
>> +static void hx8369a_dsi_set_extension_command(struct hx8369a *ctx)
>> +{
>> +	hx8369a_dcs_write_seq_static(ctx, SETEXTC, 0xff, 0x83, 0x69);
>> +}
>
> What does this do exactly? It seems to be more than setting an extension
> command.

The panel data sheet tells that several commands rely on the SETEXTC,
such as SETMIPI, SETPANEL and SETCYC ..., which are used in this driver.

>
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
>> +	return 0;
>> +}
>> +
>
>> +static int hx8369a_dsi_disable(struct drm_panel *panel)
>> +{
>> +	return 0;
>> +}
> [...]
>> +static int hx8369a_dsi_enable(struct drm_panel *panel)
>> +{
>> +	return 0;
>> +}
>
> Doesn't this usually come with a backlight attached that you want to
> control here?

Accepted.

>
>> +static int hx8369a_get_modes(struct drm_panel *panel)
>> +{
>> +	struct drm_connector *connector = panel->connector;
>> +	struct hx8369a *ctx = panel_to_hx8369a(panel);
>> +	struct drm_display_mode *mode;
>> +
>> +	mode = drm_mode_create(connector->dev);
>> +	if (!mode) {
>> +		DRM_ERROR("failed to create a new display mode\n");
>> +		return 0;
>> +	}
>> +
>> +	drm_display_mode_from_videomode(&ctx->vm, mode);
>
> Like I've said before, the driver should hardcode the mode because it is
> implied by the compatible value.

Accepted.

>
>> +	mode->width_mm = ctx->width_mm;
>> +	mode->height_mm = ctx->height_mm;
>> +	connector->display_info.width_mm = mode->width_mm;
>> +	connector->display_info.height_mm = mode->height_mm;
>> +
>> +	mode->type = DRM_MODE_TYPE_DRIVER | DRM_MODE_TYPE_PREFERRED;
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
>
>> +static int hx8369a_dsi_probe(struct mipi_dsi_device *dsi)
>> +{
>> +	struct device *dev = &dsi->dev;
>> +	struct hx8369a *ctx;
>> +	int ret, i;
>> +	char bs[4];
>> +
>> +	ctx = devm_kzalloc(dev, sizeof(struct hx8369a), GFP_KERNEL);
>
> I'd prefer sizeof(*ctx).

Accepted.

>
>> +	ctx->reset_gpio = devm_gpiod_get(dev, "reset");
>> +	if (IS_ERR(ctx->reset_gpio)) {
>> +		dev_err(dev, "cannot get reset-gpios %ld\n",
>> +			PTR_ERR(ctx->reset_gpio));
>> +		return PTR_ERR(ctx->reset_gpio);
>> +	}
>> +	ret = gpiod_direction_output(ctx->reset_gpio, 0);
>> +	if (ret < 0) {
>> +		dev_err(dev, "cannot configure reset-gpios %d\n", ret);
>> +		return ret;
>> +	}
>
> I think you're supposed to combine this into something like:
>
> 	ret = devm_gpiod_get(dev, "reset", GPIOD_OUT_LOW);
>
> nowadays.

Accepted.

>
>> +
>> +	for (i = 0; i < 4; i++) {
>> +		snprintf(bs, sizeof(bs), "bs%d", i);
>> +		ctx->bs_gpio[i] = devm_gpiod_get(dev, bs);
>> +		if (IS_ERR(ctx->bs_gpio[i]))
>> +			continue;
>> +
>> +		ret = gpiod_direction_output(ctx->bs_gpio[i], 1);
>> +		if (ret < 0) {
>> +			dev_err(dev, "cannot configure bs%d-gpio %d\n", i, ret);
>> +			return ret;
>> +		}
>
> Similarly to the above:
>
> 	ret = devm_gpiod_get(dev, bs, GPIOD_OUT_HIGH);
>
>> +static int __init hx8369a_init(void)
>> +{
>> +	int err;
>> +
>> +	err = mipi_dsi_driver_register(&hx8369a_dsi_driver);
>> +	if (err < 0)
>> +		return err;
>> +
>> +	return 0;
>> +}
>> +module_init(hx8369a_init);
>> +
>> +static void __exit hx8369a_exit(void)
>> +{
>> +	mipi_dsi_driver_unregister(&hx8369a_dsi_driver);
>> +}
>> +module_exit(hx8369a_exit);
>
> Why can't this be module_mipi_dsi_driver(&hx8369a_dsi_driver)?

Like the panel-simple driver. I thought that we probably may add other
driver registers here. But, since the driver only supports DSI now,
I may change to use module_mipi_dsi_driver().

>
>> +
>> +MODULE_DESCRIPTION("Himax HX8369A panel driver");
>> +MODULE_LICENSE("GPL v2");
>
> Missing MODULE_AUTHOR()?

I'll add it.


Thanks,

Liu Ying

>
> Thierry
>
