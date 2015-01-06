Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbbAFOda (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 09:33:30 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:17117 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbbAFOd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 09:33:29 -0500
Message-ID: <54ABF234.9010506@atmel.com>
Date: Tue, 6 Jan 2015 15:33:24 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
        David Airlie <airlied@linux.ie>, <dri-devel@lists.freedesktop.org>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "Alexandre Belloni" <alexandre.belloni@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 0/2] drm: add support for Atmel HLCDC Display Controller
References: <1420544147-18379-1-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1420544147-18379-1-git-send-email-boris.brezillon@free-electrons.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 06/01/2015 12:35, Boris Brezillon a écrit :
> Hi Dave,
> 
> As I already said here [1], I'd really like to have the Atmel HLCDC driver
> merged in 3.20 (it's already floating around for quite some time now).
> So, unless someone complain about this version, I plan to send a PR soon,
> is that okay for you ?
> Please note that this series depends on [1] (which I can also include in my
> PR).
> 
> Here comes the usual description:
> 
> This patch series adds support for the Atmel HLCDC Display Controller
> embedded in the HLCDC block.
> 
> The drivers supports basic CRTC functionalities, several overlays and
> provides an hardware cursor.
> 
> At the moment, it only supports connection to LCD panels through an RGB
> connector (defined as an LVDS connector in my implementation), though
> connection to other kind of devices (like DRM bridges) could be added later.
> 
> It also supports several RGB formats on all planes and some YUV formats on
> the HEO overlay plane.
> 
> Best Regards,
> 
> Boris
> 
> [1]https://lkml.org/lkml/2015/1/6/171
> 
> Changes since v8:
>  - remove dependency on this series https://lkml.org/lkml/2014/11/16/12
>    (which did not make it into 3.19) to avoid cross subsystem dependency
>    issues
> 
> Changes since v7:
>  - split MFD, PWM and Display Controller drivers in several patch series
>  - fix inline documentation (suggested by Nicolas)
>  - fix DMA BURST LEN config (suggested by Nicolas)
>  - call load and unload in probe and remove functions instead of setting
>    them in drm_driver struct
> 
> Changes since v6:
> - move interrupts property from hlcdc display controller node to its
>   parent node (the MFD device)
> - add mode_set_base implementation
> - rework page flip handling to rely on vblank events instead of DMA
>   transfer events (the end of a DMA transfer does not mean the frame
>   is actually flipped: data are first copied to an output FIFO before
>   being sent on the RGB/DPI connector)
> - few minor coding style fixes
> 
> Changes since v5:
> - fix Kconfig dependency bug
> - use adjusted mode in crtc config
> - move signal config (clk, hsync, vsync) from connector to crtc mode_set
>   function
> - use standard rotation property
> - check display_mode validity in connecto mode_valid function
> - remove dma_set_coherent mask call (now done in MFD core)
> - do not use drm_platform_init
> 
> Changes since v4:
> - fix a few more bugs in rotation handling (rotation was buggy on some
>   formats)
> - return connector_status_unknown until a panel is exposed by the
>   drm_panel infrastructure (prevent fbdev creation until everyting is
>   in place)
> - rework Kconfig MFD_ATMEL_HLCDC selection to simplify the configuration
>   (automatically select this option when selecting the HLCDC PMW or DRM
>   driver, instead of depending on this option)
> 
> Changes since v3:
> - rework the layer code to simplify several parts (locking and layer
>   disabling)
> - make use of the drm_flip_work infrastructure
> - rely on default HW cursor implementation using on the cursor plane
> - rework the display controller DT bindings (based on OF graph
>   representation)
> - add rotation support
> - retrieve RGB bus format from drm_display_info
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
> - explicitly include regmap and clk headers instead of relying on
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
> Boris Brezillon (2):
>   drm: add Atmel HLCDC Display Controller support
>   drm: add DT bindings documentation for atmel-hlcdc-dc driver

Boris, David,

I realize that I already gave my acknowledgement to this driver for the
v7 revision. It was before it is split.
For the record, here is my review and the message:
https://lkml.org/lkml/2014/10/8/219

As I had said:
"I'm absolutely not an expert in DRM drivers" but here is my:

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

On the driver and associated DT binding.

Thanks, bye,


>  .../devicetree/bindings/drm/atmel/hlcdc-dc.txt     |  53 ++
>  drivers/gpu/drm/Kconfig                            |   2 +
>  drivers/gpu/drm/Makefile                           |   1 +
>  drivers/gpu/drm/atmel-hlcdc/Kconfig                |  11 +
>  drivers/gpu/drm/atmel-hlcdc/Makefile               |   7 +
>  drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c     | 406 ++++++++++
>  drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_dc.c       | 579 ++++++++++++++
>  drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_dc.h       | 213 +++++
>  drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_layer.c    | 667 ++++++++++++++++
>  drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_layer.h    | 398 ++++++++++
>  drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_output.c   | 319 ++++++++
>  drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c    | 856 +++++++++++++++++++++
>  12 files changed, 3512 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/drm/atmel/hlcdc-dc.txt
>  create mode 100644 drivers/gpu/drm/atmel-hlcdc/Kconfig
>  create mode 100644 drivers/gpu/drm/atmel-hlcdc/Makefile
>  create mode 100644 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c
>  create mode 100644 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_dc.c
>  create mode 100644 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_dc.h
>  create mode 100644 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_layer.c
>  create mode 100644 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_layer.h
>  create mode 100644 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_output.c
>  create mode 100644 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c
> 


-- 
Nicolas Ferre
