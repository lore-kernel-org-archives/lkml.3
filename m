Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbaLSHmJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 02:42:09 -0500
Received: from mail-bn1on0136.outbound.protection.outlook.com ([157.56.110.136]:17985
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751547AbaLSHmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 02:42:07 -0500
Message-ID: <5493D7CF.1020304@freescale.com>
Date: Fri, 19 Dec 2014 15:46:23 +0800
From: Liu Ying <Ying.Liu@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Andy Yan <andyshrk@163.com>
CC: <dri-devel@lists.freedesktop.org>, <devicetree@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <kernel@pengutronix.de>,
        <linux-kernel@vger.kernel.org>, <mturquette@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH RFC v2 00/14] Add support for i.MX MIPI DSI DRM driver
References: <1418886696-11636-1-git-send-email-Ying.Liu@freescale.com>
 <59cf2641.8c29.14a614058be.Coremail.andyshrk@163.com>
In-Reply-To: <59cf2641.8c29.14a614058be.Coremail.andyshrk@163.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(189002)(24454002)(479174004)(51704005)(199003)(243025005)(377454003)(377424004)(65816999)(104016003)(21056001)(107046002)(77156002)(4396001)(106466001)(33656002)(15975445007)(6806004)(54356999)(83506001)(1720100001)(47776003)(2950100001)(105606002)(87936001)(68736005)(110136001)(19580405001)(59896002)(19580395003)(36756003)(50986999)(77096005)(62966003)(31966008)(80316001)(65806001)(64706001)(46102003)(65956001)(97736003)(85426001)(99396003)(23676002)(20776003)(64126003)(84676001)(120916001)(76176999)(86362001)(50466002)(87266999)(92566001)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0634;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0634;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:CY1PR0301MB0634;
X-Forefront-PRVS: 0430FA5CB7
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0634;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

On 12/19/2014 02:33 PM, Andy Yan wrote:
> Hi Liu Ying:
>
>   I foud Rockchip RK618 (a mfd function device with mipi dsi，lvds
> transmitter、HDMI TX、and audio codec，and
> controlled by the SOC from i2c ) have the same register layout with your
> i.MX MIPI DSI，which means RK618 MIPI
> DSI also have the Synopsys compatible DSI IP。So Would you please make
> this drives more platform independent？
>

I may try to place the Synopsys DesignWare MIPI DSI driver in the
drm/bridge directory and make it as less platform-dependant as
possible.

I have no access to the Rockchip RK618 chip and it's reference menu.
You probably may add the Rockchip part support later.

Regards,
Liu Ying

>
>
>
> At 2014-12-18 15:11:22, "Liu Ying" <Ying.Liu@freescale.com> wrote:
>>Hi,
>>
>>This series addressed almost all comments from Thierry Redding and Russell
>>on v1.
>>
>>This series adds support for i.MX MIPI DSI DRM driver.
>>Currently, the MIPI DSI driver only supports the burst with sync pulse mode.
>>
>>This series also includes a DRM panel driver for the Truly TFT480800-16-E panel
>>which is driven by the Himax HX8369A driver IC.  The driver IC data sheet could
>>be found at [1].  As mentioned by the data sheet, the driver IC supports several
>>interface modes.  Currently, the DRM panel driver only supports the MIPI DSI video
>>mode.  New interface modes could be added later(perhaps, just like the way the DRM
>>simple panel driver supports both MIPI DSI interface panels and simple(parallel)
>>interface panels).
>>
>>The MIPI DSI feature is tested on i.MX6Q SabreSD board and i.MX6DL SabreSD board.
>>The MIPI DSI display could be enabled directly on i.MX6Q SabreSD board after
>>applying this series, because the 26.4MHz pixel clock the panel requires could be
>>derived from the IPU HSP clock(264MHz) with an integer divider.
>>On i.MX6DL SabreSD board, we need to manually disable the LVDS and HDMI displays in
>>the device tree blob, since the i.MX6DL IPU HSP clock is 198MHz at present, which
>>makes the pixel clock share the PLL5 video clock source with the LVDS and HDMI,
>>thus, the panel cannot get the pixel clock rate it wants.
>>
>>Patch 01/15 is needed to get a precise pixel clock rate(26.4MHz) from the PLL5 video
>>clock.  If we don't have this patch, the pixel clock rate is about 20MHz, which
>>causes a horitonal shift on the display image.
>>
>>This series can be applied on the drm-next branch.
>>
>>[1] http://www.allshore.com/pdf/Himax_HX8369-A.pdf
>>
>>Liu Ying (14):
>>  clk: divider: Correct parent clk round rate if no bestdiv is normally
>>    found
>>  of: Add vendor prefix for Himax Technologies Inc.
>>  of: Add vendor prefix for Truly Semiconductors Limited
>>  ARM: imx6q: Add GPR3 MIPI muxing control register field shift bits
>>    definition
>>  ARM: imx6q: clk: Add the video_27m clock
>>  ARM: dts: imx6qdl: Move existing MIPI DSI ports into a new 'ports'
>>    node
>>  drm/dsi: Add a helper to get bits per pixel of MIPI DSI pixel format
>>  drm: imx: Add MIPI DSI host controller driver
>>  drm: panel: Add support for Himax HX8369A MIPI DSI panel
>>  ARM: dtsi: imx6qdl: Add support for MIPI DSI host controller
>>  ARM: dts: imx6qdl-sabresd: Add support for TRULY TFT480800-16-E MIPI
>>    DSI panel
>>  ARM: imx_v6_v7_defconfig: Cleanup for imx drm being moved out of
>>    staging
>>  ARM: imx_v6_v7_defconfig: Add support for MIPI DSI host controller
>>  ARM: imx_v6_v7_defconfig: Add support for Himax HX8369A panel
>>
>> .../devicetree/bindings/drm/imx/mipi_dsi.txt       |   78 ++
>> .../devicetree/bindings/panel/himax,hx8369a.txt    |   41 +
>> .../devicetree/bindings/vendor-prefixes.txt        |    2 +
>> arch/arm/boot/dts/imx6q.dtsi                       |   20 +-
>> arch/arm/boot/dts/imx6qdl-sabresd.dtsi             |   20 +
>> arch/arm/boot/dts/imx6qdl.dtsi                     |   30 +-
>> arch/arm/configs/imx_v6_v7_defconfig               |   17 +-
>> arch/arm/mach-imx/clk-imx6q.c                      |    1 +
>> drivers/clk/clk-divider.c                          |    3 +-
>> drivers/gpu/drm/imx/Kconfig                        |    6 +
>> drivers/gpu/drm/imx/Makefile                       |    1 +
>> drivers/gpu/drm/imx/imx-mipi-dsi.c                 | 1056 ++++++++++++++++++++
>> drivers/gpu/drm/panel/Kconfig                      |    5 +
>> drivers/gpu/drm/panel/Makefile                     |    1 +
>> drivers/gpu/drm/panel/panel-himax-hx8369a.c        |  573 +++++++++++
>> include/drm/drm_mipi_dsi.h                         |   14 +
>> include/dt-bindings/clock/imx6qdl-clock.h          |    3 +-
>> include/linux/mfd/syscon/imx6q-iomuxc-gpr.h        |    1 +
>> 18 files changed, 1844 insertions(+), 28 deletions(-)
>> create mode 100644 Documentation/devicetree/bindings/drm/imx/mipi_dsi.txt
>> create mode 100644 Documentation/devicetree/bindings/panel/himax,hx8369a.txt
>> create mode 100644 drivers/gpu/drm/imx/imx-mipi-dsi.c
>> create mode 100644 drivers/gpu/drm/panel/panel-himax-hx8369a.c
>>
>>--
>>2.1.0
>>
>>_______________________________________________
>>dri-devel mailing list
>>dri-devel@lists.freedesktop.org
>>http://lists.freedesktop.org/mailman/listinfo/dri-devel
>
>
>
