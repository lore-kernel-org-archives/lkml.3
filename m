Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbaHUIQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 04:16:18 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:19662 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792AbaHUIQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 04:16:12 -0400
Date: Thu, 21 Aug 2014 10:16:19 +0200
From: Ludovic Desroches <ludovic.desroches@atmel.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>, David Airlie <airlied@linux.ie>,
        <dri-devel@lists.freedesktop.org>,
        Thierry Reding <thierry.reding@gmail.com>, <linux-pwm@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Clark <robdclark@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mark Rutland <mark.rutland@arm.com>, <devicetree@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Bo Shen <voice.shen@atmel.com>, Kumar Gala <galak@codeaurora.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 00/11] drm: add support for Atmel HLCDC Display
 Controller
Message-ID: <20140821081619.GZ2452@ldesroches-Latitude-E6320>
Mail-Followup-To: Boris BREZILLON <boris.brezillon@free-electrons.com>,
	Nicolas Ferre <nicolas.ferre@atmel.com>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	Alexandre Belloni <alexandre.belloni@free-electrons.com>,
	Andrew Victor <linux@maxim.org.za>, David Airlie <airlied@linux.ie>,
	dri-devel@lists.freedesktop.org,
	Thierry Reding <thierry.reding@gmail.com>,
	linux-pwm@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
	Lee Jones <lee.jones@linaro.org>, Rob Clark <robdclark@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
	Pawel Moll <pawel.moll@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
	Bo Shen <voice.shen@atmel.com>, Kumar Gala <galak@codeaurora.org>,
	linux-arm-kernel@lists.infradead.org
References: <1406034695-15534-1-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1406034695-15534-1-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

You can add

Tested-by: Ludovic Desroches <ludovic.desroches@atmel.com>

Only one issue but not related to your patches, you can't display
quickly the bootup logo since the panel detection takes too much
time.

Regards

Ludovic

On Tue, Jul 22, 2014 at 03:11:24PM +0200, Boris BREZILLON wrote:
> Hello,
> 
> This patch series adds support for Atmel HLCDC (HLCD Controller) available
> on some Atmel SoCs (i.e. the sama5d3 family).
> 
> The HLCDC actually provides a Display Controller and a PWM device, hence I
> decided to declare an MFD device exposing 2 subdevices: a display
> controller and a PWM chip.
> This also solves a circular dependency issue preventing HLCDC driver from
> unloading.
> The HLCDC request a drm_panel device, which request a backlight device
> (a PWM backlight), which depends on a PWM which is provided by the HLCDC
> driver (hlcdc -> panel -> backlight -> hlcdc (pwm part)).
> 
> The current implementation only supports sama5d3 SoCs but other SoCs should
> be easily ported by defining new compatible strings and adding HLCDC
> description structures for these SoCs.
> 
> The drivers supports basic CRTC functionalities, several overlays and an
> hardware cursor.
> 
> At the moment, it only supports connection to LCD panels through an RGB
> connector (defined as an LVDS connector in my implementation), though
> connection to other kind of devices (like DRM bridges) could be added later.
> 
> It also supports several RGB formats on all planes and some YUV formats on
> the HEO overlay plane.
> 
> This series depends on 2 other series currently under review: [1] and [2].
> 
> Best Regards,
> 
> Boris
> 
> [1]http://lkml.iu.edu/hypermail/linux/kernel/1407.1/04171.html
> [2]http://www.spinics.net/lists/kernel/msg1791681.html
> 
> Changes since v3:
> - rework the layer code to simplify several parts (locking and layer
>   disabling)
> - make use of the drm_flip_work infrastructure
> - rely on default HW cursor implementation using on the cursor plane
> - rework the display controller DT bindings (based on OF graph
>   representation)
> - add rotation support
> - retrive RGB bus format from drm_display_info
> - drop the dynamic pinctrl state selection
> - rework HLCDC output handling (previously specialized to interface
>   with LCD panels)
> - drop ".module = THIS_MODULE" lines
> - change display controller compatible string
> 
> Changes since v2:
> - fix coding style issues (macro indentation)
> - make use of GENMASK in several places
> - declare regmap config as a static structure
> - rework hlcdc plane update API
> - rework cursor handling to make use of the new plane update API
> - fix backporch config
> - do not use devm_regmap_init_mmio_clk to avoid extra clk_enable
>   clk disable calls when accessing registers
> - explicitely include regmap and clk headers instead of relying on
>   atmel-hlcdc.h inclusions
> - make the atmel-hlcdc driver depends on CONFIG_OF
> - separate DT bindings documentation from driver implementation
> - support several pin muxing for HLCDC pins on sama5d3 SoCs
> 
> Changes since v1:
> - replace the backlight driver by a PWM driver
> - make use of drm_panel infrastructure
> - split driver code in several subsystem: MFD, PWM and DRM
> - add support for overlays
> - add support for hardware cursor
> 
> 
> Boris BREZILLON (11):
>   mfd: add atmel-hlcdc driver
>   mfd: add documentation for atmel-hlcdc DT bindings
>   pwm: add support for atmel-hlcdc-pwm device
>   pwm: add DT bindings documentation for atmel-hlcdc-pwm driver
>   drm: add Atmel HLCDC Display Controller support
>   drm: add DT bindings documentation for atmel-hlcdc-dc driver
>   ARM: AT91/dt: split sama5d3 lcd pin definitions to match RGB mode
>     configs
>   ARM: AT91/dt: add alternative pin muxing for sama5d3 lcd pins
>   ARM: at91/dt: define the HLCDC node available on sama5d3 SoCs
>   ARM: at91/dt: add LCD panel description to sama5d3xdm.dtsi
>   ARM: at91/dt: enable the LCD panel on sama5d3xek boards
> 
>  .../devicetree/bindings/drm/atmel-hlcdc-dc.txt     |  54 ++
>  .../devicetree/bindings/mfd/atmel-hlcdc.txt        |  50 ++
>  .../devicetree/bindings/pwm/atmel-hlcdc-pwm.txt    |  55 ++
>  arch/arm/boot/dts/sama5d31ek.dts                   |  20 +
>  arch/arm/boot/dts/sama5d33ek.dts                   |  20 +
>  arch/arm/boot/dts/sama5d34ek.dts                   |  20 +
>  arch/arm/boot/dts/sama5d36ek.dts                   |  20 +
>  arch/arm/boot/dts/sama5d3_lcd.dtsi                 | 205 +++++-
>  arch/arm/boot/dts/sama5d3xdm.dtsi                  |  58 ++
>  drivers/gpu/drm/Kconfig                            |   2 +
>  drivers/gpu/drm/Makefile                           |   1 +
>  drivers/gpu/drm/atmel-hlcdc/Kconfig                |  11 +
>  drivers/gpu/drm/atmel-hlcdc/Makefile               |   7 +
>  drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c     | 286 ++++++++
>  drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_dc.c       | 488 +++++++++++++
>  drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_dc.h       | 224 ++++++
>  drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_layer.c    | 635 ++++++++++++++++
>  drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_layer.h    | 396 ++++++++++
>  drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_output.c   | 478 ++++++++++++
>  drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c    | 804 +++++++++++++++++++++
>  drivers/mfd/Kconfig                                |  12 +
>  drivers/mfd/Makefile                               |   1 +
>  drivers/mfd/atmel-hlcdc.c                          | 118 +++
>  drivers/pwm/Kconfig                                |   9 +
>  drivers/pwm/Makefile                               |   1 +
>  drivers/pwm/pwm-atmel-hlcdc.c                      | 229 ++++++
>  include/linux/mfd/atmel-hlcdc.h                    |  78 ++
>  27 files changed, 4251 insertions(+), 31 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/drm/atmel-hlcdc-dc.txt
>  create mode 100644 Documentation/devicetree/bindings/mfd/atmel-hlcdc.txt
>  create mode 100644 Documentation/devicetree/bindings/pwm/atmel-hlcdc-pwm.txt
>  create mode 100644 drivers/gpu/drm/atmel-hlcdc/Kconfig
>  create mode 100644 drivers/gpu/drm/atmel-hlcdc/Makefile
>  create mode 100644 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c
>  create mode 100644 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_dc.c
>  create mode 100644 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_dc.h
>  create mode 100644 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_layer.c
>  create mode 100644 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_layer.h
>  create mode 100644 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_output.c
>  create mode 100644 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c
>  create mode 100644 drivers/mfd/atmel-hlcdc.c
>  create mode 100644 drivers/pwm/pwm-atmel-hlcdc.c
>  create mode 100644 include/linux/mfd/atmel-hlcdc.h
> 
> -- 
> 1.8.3.2
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
