Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbaDWPgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 11:36:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.130]:64724 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbaDWPgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 11:36:49 -0400
Message-ID: <1398267396.4295.59.camel@herbert.er.corscience.de>
Subject: Re: [RFC 0/3] DRM driver for the ATMEL High end LCD controller
From: Tim Niemeyer <tim.niemeyer@corscience.de>
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Robert Nelson <robertcnelson@gmail.com>
Cc: nicolas.ferre@atmel.com, boris.brezillon@free-electrons.com,
        linux-arm-kernel@lists.infradead.org, dri-devel@lists.freedesktop.org,
        airlied@linux.ie, robdclark@gmail.com, plagnioj@jcrosoft.com,
        linux-kernel@vger.kernel.org
Date: Wed, 23 Apr 2014 17:36:36 +0200
In-Reply-To: <1397814309-32160-1-git-send-email-jjhiblot@traphandler.com>
References: <1397814309-32160-1-git-send-email-jjhiblot@traphandler.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:4e+1Mngue3nZ8UR399vaeqDAVLJ5EzHY7HrKUTkCqMk
 DGz2HidI+75OF/twIg3Yip/LkvQk0yxgXiFA07samdvNhnCnSy
 Ux+P0cv/PizFzX66vkb3BFymlRuU2oscq2lh8dCCRJ1ZC9pjtX
 Aj4tylBBmFXI2zEJAN6T++XA+bG2ztgbnxr7u8aqXWaMyf5C4u
 isgZI2SOVOijElWCl1SARFl794b04ZbL1qT3na8S3St9YqeEts
 2jjDr76ml5MrPuSVnCmifaITW5QXmvaPjUE2AC/xfr5Dl5aOWq
 xyVSFiGLE1kA6FI3hcuz3foXUQcO8mKJCURZ6zn6MHFwEdpihi
 E96C+zBSMATua7vT6jnIKKsWoXhc7qUuS0mI28ejXzQD339nCR
 SIFta2ErSJko78ymnxu6q0/OZZX7+51A0g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean-Jacques,

Am Freitag, den 18.04.2014, 11:45 +0200 schrieb Jean-Jacques Hiblot:
> Hi,
> 
> this patch serie implements a simple DRM driver for the ATMEL High end LCD
> controller found in the SAMA5 familly. It's based on the tilcdc driver.
> It uses the cma_helper for memory and fbdev stuff.
> Your comments are welcome !
I applied your and Robert's patches on a 3.15-rc2 kernel and tried the
framebuffer device on the sama5d31-ek. Seems to work.

> Supported features:
> * the base layer (the main framebuffer)
Tested to show a little tux png, but it's appearing only after 
'echo 0 > /sys/devices/ahb.1/apb.2/f0030000.hlcdc/graphics/fb0/rotate'
is there missing some initializing?

> * a simple panel
> * a backlight driver
Tested to set brightness to 0, 20 and 255. Works.

Thanks for your work.

Best Regards
Tim

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
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel


