Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282AbaDRNhh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:37:37 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33668 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751159AbaDRNhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:37:34 -0400
Message-ID: <53512A9B.8000404@free-electrons.com>
Date: Fri, 18 Apr 2014 15:37:31 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>, nicolas.ferre@atmel.com,
        linux-arm-kernel@lists.infradead.org, dri-devel@lists.freedesktop.org
CC: plagnioj@jcrosoft.com, airlied@linux.ie, robdclark@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/3] DRM driver for the ATMEL High end LCD controller
References: <1397814309-32160-1-git-send-email-jjhiblot@traphandler.com>
In-Reply-To: <1397814309-32160-1-git-send-email-jjhiblot@traphandler.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi JJ,

On 18/04/2014 11:45, Jean-Jacques Hiblot wrote:
> Hi,
>
> this patch serie implements a simple DRM driver for the ATMEL High end LCD
> controller found in the SAMA5 familly. It's based on the tilcdc driver.
> It uses the cma_helper for memory and fbdev stuff.
> Your comments are welcome !

Thanks for you work.

As I already told you, I started to work on a DRM/KMS driver for the
hlcdc too, and I'd be pleased to help you on this driver (either by
adding the missing stuff, debugging or reworking some parts).

Regarding the code itself, I only had a quick look, but I'll try to
review it next week. Anyway, I might not be the best person to give
advice on a DRM/KMS driver :-).

BTW, I tried to boot a kernel with your driver (statically compiled),
and it hangs (see http://pastebin.com/H24KpVHb). But I didn't have time
for further debugging.

Best Regards,

Boris
>
>
> Supported features:
> * the base layer (the main framebuffer)
> * a simple panel
> * a backlight driver
> * structure to 'easily' add other connectors (it comes from the tilcdc)
>
> On the todo list:
> * support overlays as drm_planes
> * support for the hardware cursor
> * support for the SiI9022 HDMI connector (present on sama5d36ek)
>
>
> Jean-Jacques Hiblot (3):
>   atmel: drm: added drm driver for the atmel hlcd controller
>   atmel: drm: dt: Added DT entry for the atmel hlcdc found in the sama5
>   atmel: dt: Add supports for the lcdc support on the sama5d36ek
>
>  arch/arm/boot/dts/sama5d36ek.dts                   |  27 +-
>  arch/arm/boot/dts/sama5d3_lcd.dtsi                 |  11 +
>  drivers/gpu/drm/Kconfig                            |   2 +
>  drivers/gpu/drm/Makefile                           |   1 +
>  drivers/gpu/drm/atmel_hlcdc/Kconfig                |  13 +
>  drivers/gpu/drm/atmel_hlcdc/Makefile               |  12 +
>  drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc.h          | 771 +++++++++++++++++++++
>  .../gpu/drm/atmel_hlcdc/atmel_hlcdc_backlight.c    |  92 +++
>  .../gpu/drm/atmel_hlcdc/atmel_hlcdc_backlight.h    |  25 +
>  drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_crtc.c     | 702 +++++++++++++++++++
>  drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_drv.c      | 586 ++++++++++++++++
>  drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_drv.h      | 124 ++++
>  drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_ovl.h      | 190 +++++
>  drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_panel.c    | 459 ++++++++++++
>  drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_panel.h    |  28 +
>  15 files changed, 3042 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/gpu/drm/atmel_hlcdc/Kconfig
>  create mode 100644 drivers/gpu/drm/atmel_hlcdc/Makefile
>  create mode 100644 drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc.h
>  create mode 100644 drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_backlight.c
>  create mode 100644 drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_backlight.h
>  create mode 100644 drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_crtc.c
>  create mode 100644 drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_drv.c
>  create mode 100644 drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_drv.h
>  create mode 100644 drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_ovl.h
>  create mode 100644 drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_panel.c
>  create mode 100644 drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_panel.h
>
> --
> 1.9.1
>

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

