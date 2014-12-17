Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904AbaLQJk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 04:40:26 -0500
Received: from mail-bn1on0142.outbound.protection.outlook.com ([157.56.110.142]:9865
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750829AbaLQJkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 04:40:20 -0500
Message-ID: <54915081.6020508@freescale.com>
Date: Wed, 17 Dec 2014 17:44:33 +0800
From: Liu Ying <Ying.Liu@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: <dri-devel@lists.freedesktop.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <p.zabel@pengutronix.de>, <shawn.guo@linaro.org>,
        <kernel@pengutronix.de>, <linux@arm.linux.org.uk>,
        <mturquette@linaro.org>, <airlied@linux.ie>
Subject: Re: [PATCH RFC 09/15] drm: imx: Add MIPI DSI host controller driver
References: <1418200648-32656-1-git-send-email-Ying.Liu@freescale.com>
 <1418200648-32656-10-git-send-email-Ying.Liu@freescale.com>
 <20141210131640.GD23558@ulmo.nvidia.com>
In-Reply-To: <20141210131640.GD23558@ulmo.nvidia.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(51704005)(377454003)(24454002)(164054003)(479174004)(189002)(20776003)(83506001)(64706001)(107046002)(6806004)(85426001)(65816999)(92566001)(99396003)(106466001)(23746002)(65956001)(2950100001)(59896002)(68736005)(110136001)(62966003)(117636001)(50466002)(87936001)(64126003)(104016003)(19580405001)(77096005)(4396001)(54356999)(47776003)(31966008)(120916001)(21056001)(19580395003)(86362001)(50986999)(87266999)(77156002)(99136001)(65806001)(76176999)(84676001)(97736003)(46102003)(105606002)(575784001)(36756003)(2004002)(217873001)(62816006);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0636;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0636;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:CY1PR0301MB0636;
X-Forefront-PRVS: 042857DBB5
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0636;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

Sorry for the late response.
I tried to address almost all your comments locally first.
More feedback below.

On 12/10/2014 09:16 PM, Thierry Reding wrote:
> On Wed, Dec 10, 2014 at 04:37:22PM +0800, Liu Ying wrote:
>> This patch adds i.MX MIPI DSI host controller driver support.
>> Currently, the driver supports the burst with sync pulses mode only.
>>
>> Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
>> ---
>>   .../devicetree/bindings/drm/imx/mipi_dsi.txt       |   81 ++
>>   drivers/gpu/drm/imx/Kconfig                        |    6 +
>>   drivers/gpu/drm/imx/Makefile                       |    1 +
>>   drivers/gpu/drm/imx/imx-mipi-dsi.c                 | 1017 ++++++++++++++++++++
>>   4 files changed, 1105 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/drm/imx/mipi_dsi.txt
>>   create mode 100644 drivers/gpu/drm/imx/imx-mipi-dsi.c
>>
>> diff --git a/Documentation/devicetree/bindings/drm/imx/mipi_dsi.txt b/Documentation/devicetree/bindings/drm/imx/mipi_dsi.txt
>> new file mode 100644
>> index 0000000..3d07fd7
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/drm/imx/mipi_dsi.txt
>> @@ -0,0 +1,81 @@
>> +Device-Tree bindings for MIPI DSI host controller
>> +
>> +MIPI DSI host controller
>> +========================
>> +
>> +The MIPI DSI host controller is a Synopsys DesignWare IP.
>> +It is a digital core that implements all protocol functions defined
>> +in the MIPI DSI specification, providing an interface between the
>> +system and the MIPI DPHY, and allowing communication with a MIPI DSI
>> +compliant display.
>> +
>> +Required properties:
>> + - #address-cells : Should be <1>.
>> + - #size-cells : Should be <0>.
>> + - compatible : Should be "fsl,imx6q-mipi-dsi" for i.MX6q/sdl SoCs.
>> + - reg : Physical base address of the controller and length of memory
>> +         mapped region.
>> + - interrupts : The controller's interrupt number to the CPU(s).
>> + - gpr : Should be <&gpr>.
>> +         The phandle points to the iomuxc-gpr region containing the
>> +         multiplexer control register for the controller.
>
> Side-note: Shouldn't this really be a pinmux, then?

No. The muxing is inside the i.MX SoC.
There is a DT binding documentation for the system controller node(gpr)
at [1]. And, for i.MX DT sources, there are several existing use cases 
in which the gpr node is referred by other nodes.

[1] Documentation/devicetree/bindings/mfd/syscon.txt.

>
>> + - clocks, clock-names : Phandles to the controller pllref, pllref_gate
>> +           and core_cfg clocks, as described in [1] and [2].
>> + - panel@0 : A panel node which contains a display-timings child node as
>> +             defined in [3].
>
> There's no need for these to be named panel@*. They could be bridges for
> example. And no, they shouldn't contain a display-timings child node
> either. Panels should have a proper driver and the driver being device
> specific it should have the timings embedded.

Ok, I'll move the timing to the panel driver.

>
>> + - port@[0-4] : Up to four port nodes with endpoint definitions as defined
>> +   in [4], corresponding to the four inputs to the controller multiplexer.
>> +   Note that each port node should contain the input-port property to
>> +   distinguish it from the panel node, as described in [5].
>
> [4] says that you can group all port nodes under a ports parent node. I
> think this is really what you want to do here to make it clear that the
> ports aren't part of the DSI host binding part of the device.
>

Accepted.

>> diff --git a/drivers/gpu/drm/imx/imx-mipi-dsi.c b/drivers/gpu/drm/imx/imx-mipi-dsi.c
> [...]
>> +/*
>> + * i.MX drm driver - MIPI DSI Host Controller
>> + *
>> + * Copyright (C) 2011-2014 Freescale Semiconductor, Inc.
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License
>> + * as published by the Free Software Foundation; either version 2
>> + * of the License, or (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <linux/clk.h>
>> +#include <linux/component.h>
>> +#include <linux/mfd/syscon.h>
>> +#include <linux/mfd/syscon/imx6q-iomuxc-gpr.h>
>> +#include <linux/module.h>
>> +#include <linux/of_address.h>
>> +#include <linux/of_device.h>
>> +#include <linux/regmap.h>
>> +#include <linux/videodev2.h>
>> +#include <asm/div64.h>
>
> Don't you want the more generic linux/math64.h here?

I'll use linux/math64.h.

>
>> +#include <drm/drmP.h>
>> +#include <drm/drm_crtc_helper.h>
>> +#include <drm/drm_fb_helper.h>
>
> I don't see any of the functions defined in that header used here.

I'll remove this.

>
>> +#include <drm/drm_mipi_dsi.h>
>> +#include <drm/drm_panel.h>
>> +#include <video/mipi_display.h>
>> +#include <video/of_videomode.h>
>> +#include <video/videomode.h>
>> +
>> +#include "imx-drm.h"
>> +
>> +#define DRIVER_NAME 			"imx-mipi-dsi"
>> +
>> +#define	DSI_VERSION			0x00
>> +
>> +#define	DSI_PWR_UP			0x04
>> +#define	RESET				0
>> +#define	POWERUP				BIT(0)
>> +
>> +#define	DSI_CLKMGR_CFG			0x08
>> +#define TO_CLK_DIVIDSION(div)		(((div) & 0xff) << 8)
>> +#define TX_ESC_CLK_DIVIDSION(div)	(((div) & 0xff) << 0)
>
> Your indentation here is... weird.

I'll fix this.

>
>> +#define IMX_MIPI_DSI_MAX_DATA_LANES	2
>> +
>> +#define PHY_STATUS_TIMEOUT		10
>> +#define CMD_PKT_STATUS_TIMEOUT		20
>> +
>> +#define IMX_MIPI_DSI_PLD_DATA_BUF_SIZE	4
>> +
>> +#define MHZ				1000000
>
> Why not reuse the existing USEC_PER_SEC?

Accepted.

>
>> +#define host_to_dsi(host) container_of(host, struct imx_mipi_dsi, dsi_host)
>> +#define con_to_dsi(x) container_of(x, struct imx_mipi_dsi, connector)
>> +#define enc_to_dsi(x) container_of(x, struct imx_mipi_dsi, encoder)
>
> These should really be static inline functions for proper type safety.

Ok, I'll change to use functions.

>
>> +struct imx_mipi_dsi {
>> +	struct mipi_dsi_host dsi_host;
>> +	struct drm_connector connector;
>> +	struct drm_encoder encoder;
>> +	struct device_node *panel_node;
>> +	struct drm_panel *panel;
>> +	struct device *dev;
>> +
>> +	struct regmap *regmap;
>> +	void __iomem *base;
>> +
>> +	struct clk *pllref_clk;
>> +	struct clk *pllref_gate_clk;
>> +	struct clk *cfg_clk;
>> +
>> +	unsigned int lane_mbps; /* per lane */
>> +	u32 channel;
>> +	u32 lanes;
>> +	u32 format;
>> +	struct videomode vm;
>> +
>> +	bool enabled;
>
> Do you really need this flag?

I'll remove this flag.

>
>> +};
>> +
>> +enum {
>> +	STATUS_TO_CLEAR,
>> +	STATUS_TO_SET,
>> +};
>> +
>> +struct dphy_pll_testdin_map {
>> +	int max_mbps;
>
> unsigned?

Accepted.

>
>> +	u8 testdin;
>> +};
>> +
>> +/* The table is based on 27MHz DPHY pll reference clock. */
>> +static const struct dphy_pll_testdin_map dptdin_map[] = {
>> +	{160, 0x04}, {180, 0x24}, {200, 0x44}, {210, 0x06},
>> +	{240, 0x26}, {250, 0x46}, {270, 0x08}, {300, 0x28},
>> +	{330, 0x48}, {360, 0x2a}, {400, 0x4a}, {450, 0x0c},
>> +	{500, 0x2c}, {550, 0x0e}, {600, 0x2e}, {650, 0x10},
>> +	{700, 0x30}, {750, 0x12}, {800, 0x32}, {850, 0x14},
>> +	{900, 0x34}, {950, 0x54}, {1000, 0x74}
>> +};
>> +
>> +static int max_mbps_to_testdin(unsigned int max_mbps)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(dptdin_map); i++)
>> +		if (dptdin_map[i].max_mbps == max_mbps)
>> +			return dptdin_map[i].testdin;
>> +
>> +	return -EINVAL;
>> +}
>> +
>> +static int format_to_bpp(struct imx_mipi_dsi *dsi)
>> +{
>> +	switch (dsi->format) {
>> +	case MIPI_DSI_FMT_RGB888:
>> +	case MIPI_DSI_FMT_RGB666:
>> +		return 24;
>> +	case MIPI_DSI_FMT_RGB666_PACKED:
>> +		return 18;
>> +	case MIPI_DSI_FMT_RGB565:
>> +		return 16;
>> +	default:
>> +		dev_err(dsi->dev, "unsupported pixel format\n");
>> +		return -EINVAL;
>> +	}
>> +}
>
> Is there a reason why this can't be a standard MIPI DSI function?

How about moving this to include/drm/drm_mipi_dsi.h as an inline
function?

>
>> +
>> +static int check_status(struct imx_mipi_dsi *dsi, u32 reg, u32 status,
>> +			int timeout, bool to_set)
>> +{
>> +	u32 val;
>> +	bool out = false;
>> +
>> +	val = dsi_read(dsi, reg);
>> +	for (;;) {
>> +		out = to_set ? (val & status) : !(val & status);
>> +		if (out)
>> +			break;
>> +
>> +		if (!timeout--)
>> +			return -EFAULT;
>> +
>> +		msleep(1);
>> +		val = dsi_read(dsi, reg);
>> +	}
>> +	return 0;
>> +}
>
> You should probably use a properly timed loop here. msleep() isn't
> guaranteed to return after exactly one millisecond, so your timeout is
> never going to be accurate. Something like the following would be better
> in my opinion:
>
> 	timeout = jiffies + msecs_to_jiffies(timeout);
>
> 	while (time_before(jiffies, timeout)) {
> 		...
> 	}
>
> Also timeout should be unsigned long in that case.

Accepted.

>
>> +static int imx_mipi_dsi_host_attach(struct mipi_dsi_host *host,
>> +				    struct mipi_dsi_device *device)
>> +{
>> +	struct imx_mipi_dsi *dsi = host_to_dsi(host);
>> +	int ret;
>> +
>> +	if (device->lanes > IMX_MIPI_DSI_MAX_DATA_LANES) {
>> +		dev_err(dsi->dev, "the number of data lanes(%d) is too many\n",
>> +				device->lanes);
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (!(device->mode_flags & MIPI_DSI_MODE_VIDEO_BURST) ||
>> +	    !(device->mode_flags & MIPI_DSI_MODE_VIDEO_SYNC_PULSE)) {
>> +		dev_err(dsi->dev, "device mode is unsupported\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	dsi->lanes = device->lanes;
>> +	dsi->channel = device->channel;
>> +	dsi->format = device->format;
>> +	dsi->panel_node = device->dev.of_node;
>> +	of_get_videomode(dsi->panel_node, &dsi->vm, 0);
>
> No, you shouldn't use this. Query the mode from the panel instead. Or
> rather, encode this requirement in ->mode_valid() since that'll give you
> direct access to the mode.
>
> That way, ->host_attach() becomes a filter for compatible devices, yet
> devices may support multiple modes, therefore ->mode_valid() can be used
> to filter out those that don't work with your DSI host controller. There
> is a subtle difference here between devices that are compatible with the
> controller and modes that the controller doesn't support.

Accepted.

In the next version ->host_attach(), I will check the peripheral
compatibility.  Also, I'll get the panel by calling of_drm_find_panel(), 
and then call the drm_panel_attach() function.
Do you think this is okay?

>
>> +
>> +	ret = imx_mipi_dsi_get_lane_bps(dsi, &dsi->lane_mbps);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	return 0;
>> +}
>> +
>> +static int imx_mipi_dsi_host_detach(struct mipi_dsi_host *host,
>> +				    struct mipi_dsi_device *device)
>> +{
>> +	struct imx_mipi_dsi *dsi = host_to_dsi(host);
>> +
>> +	dsi->panel_node = NULL;
>> +	dsi->panel = NULL;
>> +
>> +	return 0;
>> +}
>
> You'll want to detach from the panel here as well.

Ok. I'll call drm_panel_detach() here.

>
>> +
>> +static int imx_mipi_dsi_gen_pkt_hdr_write(struct imx_mipi_dsi *dsi, u32 val)
>> +{
>> +	int ret;
>> +
>> +	ret = check_status(dsi, DSI_CMD_PKT_STATUS, GEN_CMD_FULL,
>> +			   CMD_PKT_STATUS_TIMEOUT, STATUS_TO_CLEAR);
>> +	if (ret < 0) {
>> +		dev_err(dsi->dev, "failed to get avaliable command FIFO\n");
>> +		return ret;
>> +	}
>> +
>> +	dsi_write(dsi, DSI_GEN_HDR, val);
>> +
>> +	ret = check_status(dsi, DSI_CMD_PKT_STATUS,
>> +			   GEN_CMD_EMPTY | GEN_PLD_W_EMPTY,
>> +			   CMD_PKT_STATUS_TIMEOUT, STATUS_TO_SET);
>> +	if (ret < 0) {
>> +		dev_err(dsi->dev, "failed to write command FIFO\n");
>> +		return ret;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int imx_mipi_dsi_dcs_short_write(struct imx_mipi_dsi *dsi,
>> +					const struct mipi_dsi_msg *msg)
>> +{
>> +	const u16 *tx_buf = msg->tx_buf;
>> +	u32 val = GEN_HDATA(*tx_buf) | GEN_HTYPE(msg->type);
>> +
>> +	if (msg->tx_len > 2) {
>> +		dev_err(dsi->dev, "too long tx buf length %d for short write\n",
>> +			msg->tx_len);
>> +		return -EINVAL;
>> +	}
>> +
>> +	return imx_mipi_dsi_gen_pkt_hdr_write(dsi, val);
>> +}
>
> It seems like you would profit from converting to the newly introduced
> mipi_dsi_create_packet() helper which does most of the packing along
> with some sanity checking for you.

I looked at the helper. It seems it's not quite straightforward for me
to use it here.  The message type here defined by GEN_HTYPE() is 8bit
long, while the helper seems to take it as 6bit long?

>
>> +
>> +static int imx_mipi_dsi_dcs_long_write(struct imx_mipi_dsi *dsi,
>> +				       const struct mipi_dsi_msg *msg)
>> +{
>> +	const u32 *tx_buf = msg->tx_buf;
>> +	int len = msg->tx_len, ret;
>> +	u32 val = GEN_HDATA(msg->tx_len) | GEN_HTYPE(msg->type);
>> +
>> +	if (msg->tx_len < 3) {
>> +		dev_err(dsi->dev, "wrong tx buf length %d for long write\n",
>> +			msg->tx_len);
>> +		return -EINVAL;
>> +	}
>> +
>> +	/* write the bulks */
>> +	while (len / IMX_MIPI_DSI_PLD_DATA_BUF_SIZE) {
>> +		dsi_write(dsi, DSI_GEN_PLD_DATA, *tx_buf);
>> +		tx_buf++;
>> +		len -= IMX_MIPI_DSI_PLD_DATA_BUF_SIZE;
>
> This is confusing. Maybe a better option would be to use sizeof(*tx_buf)
> instead of this macro. You're effectively consuming one u32 with each
> write, irrespective of what the value of the macro is.

Ok. I'll use sizeof(*tx_buf).

>
>> +		ret = check_status(dsi, DSI_CMD_PKT_STATUS, GEN_PLD_W_FULL,
>> +				   CMD_PKT_STATUS_TIMEOUT, STATUS_TO_CLEAR);
>> +		if (ret < 0) {
>> +			dev_err(dsi->dev, "failed to get avaliable "
>> +					"write payload FIFO\n");
>> +			return ret;
>> +		}
>> +	}
>> +
>> +	/* write the remainder */
>> +	if (len > 0) {
>> +		ret = check_status(dsi, DSI_CMD_PKT_STATUS, GEN_PLD_W_FULL,
>> +				   CMD_PKT_STATUS_TIMEOUT, STATUS_TO_CLEAR);
>> +		if (ret < 0) {
>> +			dev_err(dsi->dev, "failed to get avaliable "
>> +					"write payload FIFO\n");
>> +			return ret;
>> +		}
>> +		dsi_write(dsi, DSI_GEN_PLD_DATA, *tx_buf);
>> +	}
>
> This is really duplicating what the above loop does. Why can't you do it
> in a single loop? Also the transmission buffer isn't guaranteed to be a
> multiple of 4 bytes, so you could have the situation where len > 0 and
> len < 4 and yet you'll be reading 4 bytes by doing *tx_buf and accessing
> memory that you shouldn't.

Good catch.  I'll make it to be a single loop and avoid accessing memory
that I shouldn't in the next version.

>
>> +	return imx_mipi_dsi_gen_pkt_hdr_write(dsi, val);
>> +}
>> +
>> +static ssize_t imx_mipi_dsi_host_transfer(struct mipi_dsi_host *host,
>> +					  const struct mipi_dsi_msg *msg)
>> +{
>> +	struct imx_mipi_dsi *dsi = host_to_dsi(host);
>> +	int ret;
>> +
>> +	switch (msg->type) {
>> +	case MIPI_DSI_DCS_SHORT_WRITE:
>> +	case MIPI_DSI_DCS_SHORT_WRITE_PARAM:
>> +	case MIPI_DSI_SET_MAXIMUM_RETURN_PACKET_SIZE:
>> +		ret = imx_mipi_dsi_dcs_short_write(dsi, msg);
>> +		break;
>> +	case MIPI_DSI_DCS_LONG_WRITE:
>> +		ret = imx_mipi_dsi_dcs_long_write(dsi, msg);
>> +		break;
>> +	default:
>> +		dev_err(dsi->dev, "unsupported message type\n");
>> +		ret = -EFAULT;
>
> EFAULT really isn't appropriate here.

I'll change it to EINVAL.

>
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +static const struct mipi_dsi_host_ops imx_mipi_dsi_host_ops = {
>> +	.attach = imx_mipi_dsi_host_attach,
>> +	.detach = imx_mipi_dsi_host_detach,
>> +	.transfer = imx_mipi_dsi_host_transfer,
>> +};
>> +
>> +static enum drm_connector_status
>> +imx_mipi_dsi_detect(struct drm_connector *connector, bool force)
>> +{
>> +	struct imx_mipi_dsi *dsi = con_to_dsi(connector);
>> +
>> +	if (!dsi->panel) {
>> +		dsi->panel = of_drm_find_panel(dsi->panel_node);
>> +		if (dsi->panel)
>> +			drm_panel_attach(dsi->panel, &dsi->connector);
>> +	}
>> +
>> +	if (dsi->panel)
>> +		return connector_status_connected;
>> +
>> +	return connector_status_disconnected;
>> +
>> +}
>
> You really shouldn't be doing that here. of_drm_find_panel() returning
> NULL should be considered cause for deferring probe. I suspect that the
> driver doesn't really handle that very well at all, though, since if it
> did you would've run into the same issue that Benjamin ran into this
> morning.

I'll return connector_status_disconnected directly here. Is it okay?

>
>> +static void imx_mipi_dsi_encoder_prepare(struct drm_encoder *encoder)
>> +{
>> +	struct imx_mipi_dsi *dsi = enc_to_dsi(encoder);
>> +	u32 interface_pix_fmt;
>> +
>> +	switch (dsi->format) {
>> +	case MIPI_DSI_FMT_RGB888:
>> +		interface_pix_fmt = V4L2_PIX_FMT_RGB24;
>> +		break;
>> +	case MIPI_DSI_FMT_RGB565:
>> +		interface_pix_fmt = V4L2_PIX_FMT_RGB565;
>> +		break;
>> +	default:
>> +		dev_err(dsi->dev, "unsupported DSI pixel format\n");
>> +		return;
>
> Why even try doing this if you know upfront that it can't be done. You
> know much earlier than this that you can't drive the pixel format, why
> not abort then?
>
> People are much more likely to notice that the panel isn't supported if
> the DSI output doesn't even show up (or doesn't expose any modes) rather
> than if they have to find this error message in dmesg.

Accepted. I'll check the dsi format compatibility in ->host_attach().
And, how about changing the default patch to be this?

	default:
		BUG();
		return;
>
>> +static void imx_mipi_dsi_video_mode_config(struct imx_mipi_dsi *dsi)
>> +{
>> +	u32 val;
>> +
>> +	val = VID_MODE_TYPE_BURST_SYNC_PULSES | ENABLE_LOW_POWER;
>> +
>> +	dsi_write(dsi, DSI_VID_MODE_CFG, val);
>> +}
>
> You probably want to parameterize based on the DSI peripheral's flags. I
> see that you do reject devices with any other modes, so this may not be
> necessary now. Out of curiosity, the hardware supports other modes,
> right?

Yes, the hardware supports other modes according to it's register
definition.
I prefer not to parameterize at present as I do reject devices with 
other modes now.

>
> [...]
>> +MODULE_LICENSE("GPL v2");
>
> Sigh... according to your header comment this needs to be "GPL".

I'll change it to be "GPL".

Thanks,

Liu Ying

>
> Thierry
>
