Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbaEAGjG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 02:39:06 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:58619 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbaEAGjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 02:39:03 -0400
Message-ID: <5361EAE0.5020701@traphandler.com>
Date: Thu, 01 May 2014 08:34:08 +0200
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Reply-To: jjhiblot@traphandler.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        nicolas.ferre@atmel.com, linux-arm-kernel@lists.infradead.org,
        dri-devel@lists.freedesktop.org
CC: plagnioj@jcrosoft.com, airlied@linux.ie, robdclark@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/3] atmel: drm: added drm driver for the atmel hlcd controller
References: <1397814309-32160-1-git-send-email-jjhiblot@traphandler.com> <1397814309-32160-2-git-send-email-jjhiblot@traphandler.com> <535EAA71.3050301@free-electrons.com>
In-Reply-To: <535EAA71.3050301@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

On 04/28/2014 09:22 PM, Boris BREZILLON wrote:
> 
> 
> Hi,
> 
> This is a first review, from someone who's clearly not a DRM/KMS expert
> but who already thought about this specific driver :-).
> 
> I strongly recommend that you wait for DRM/KMS maintainers and/or
> experienced developers reviews before modifying anything ;-).
> 
> 
> On 18/04/2014 11:45, Jean-Jacques Hiblot wrote:
>> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
>> ---
>>  drivers/gpu/drm/Kconfig                            |   2 +
>>  drivers/gpu/drm/Makefile                           |   1 +
>>  drivers/gpu/drm/atmel_hlcdc/Kconfig                |  13 +
>>  drivers/gpu/drm/atmel_hlcdc/Makefile               |  12 +
>>  drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc.h          | 771 +++++++++++++++++++++
>>  .../gpu/drm/atmel_hlcdc/atmel_hlcdc_backlight.c    |  92 +++
>>  .../gpu/drm/atmel_hlcdc/atmel_hlcdc_backlight.h    |  25 +
>>  drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_crtc.c     | 702 +++++++++++++++++++
>>  drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_drv.c      | 586 ++++++++++++++++
>>  drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_drv.h      | 124 ++++
>>  drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_ovl.h      | 190 +++++
>>  drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_panel.c    | 459 ++++++++++++
>>  drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_panel.h    |  28 +
>>  13 files changed, 3005 insertions(+)
>>  create mode 100644 drivers/gpu/drm/atmel_hlcdc/Kconfig
>>  create mode 100644 drivers/gpu/drm/atmel_hlcdc/Makefile
>>  create mode 100644 drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc.h
>>  create mode 100644 drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_backlight.c
>>  create mode 100644 drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_backlight.h
>>  create mode 100644 drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_crtc.c
>>  create mode 100644 drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_drv.c
>>  create mode 100644 drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_drv.h
>>  create mode 100644 drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_ovl.h
>>  create mode 100644 drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_panel.c
>>  create mode 100644 drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_panel.h
>>
>> diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
>> index 8e7fa4d..13fec638 100644
>> --- a/drivers/gpu/drm/Kconfig
>> +++ b/drivers/gpu/drm/Kconfig
>> @@ -190,6 +190,8 @@ source "drivers/gpu/drm/omapdrm/Kconfig"
>>  
>>  source "drivers/gpu/drm/tilcdc/Kconfig"
>>  
>> +source "drivers/gpu/drm/atmel_hlcdc/Kconfig"
>> +
>>  source "drivers/gpu/drm/qxl/Kconfig"
>>  
>>  source "drivers/gpu/drm/bochs/Kconfig"
>> diff --git a/drivers/gpu/drm/Makefile b/drivers/gpu/drm/Makefile
>> index 292a79d..8245aa5 100644
>> --- a/drivers/gpu/drm/Makefile
>> +++ b/drivers/gpu/drm/Makefile
>> @@ -57,6 +57,7 @@ obj-$(CONFIG_DRM_RCAR_DU) += rcar-du/
>>  obj-$(CONFIG_DRM_SHMOBILE) +=shmobile/
>>  obj-$(CONFIG_DRM_OMAP)	+= omapdrm/
>>  obj-$(CONFIG_DRM_TILCDC)	+= tilcdc/
>> +obj-$(CONFIG_DRM_ATMEL_HLCDC)	+= atmel_hlcdc/
>>  obj-$(CONFIG_DRM_QXL) += qxl/
>>  obj-$(CONFIG_DRM_BOCHS) += bochs/
>>  obj-$(CONFIG_DRM_MSM) += msm/
>> diff --git a/drivers/gpu/drm/atmel_hlcdc/Kconfig b/drivers/gpu/drm/atmel_hlcdc/Kconfig
>> new file mode 100644
>> index 0000000..6ee5989
>> --- /dev/null
>> +++ b/drivers/gpu/drm/atmel_hlcdc/Kconfig
>> @@ -0,0 +1,13 @@
>> +config DRM_ATMEL_HLCDC
>> +	tristate "DRM Support for ATMEL HLCDC Display Controller"
>> +	depends on DRM && OF && ARM
>> +	select DRM_KMS_HELPER
>> +	select DRM_KMS_FB_HELPER
>> +	select DRM_KMS_CMA_HELPER
>> +	select DRM_GEM_CMA_HELPER
>> +	select VIDEOMODE_HELPERS
>> +	select BACKLIGHT_CLASS_DEVICE
>> +	select BACKLIGHT_LCD_SUPPORT
>> +	help
>> +	  Choose this option if you have an ATMEL SoC with HLCDC display
>> +	  controller, for example SAMA5D36EK.
>> diff --git a/drivers/gpu/drm/atmel_hlcdc/Makefile b/drivers/gpu/drm/atmel_hlcdc/Makefile
>> new file mode 100644
>> index 0000000..4935c36
>> --- /dev/null
>> +++ b/drivers/gpu/drm/atmel_hlcdc/Makefile
>> @@ -0,0 +1,12 @@
>> +ccflags-y := -Iinclude/drm
>> +ifeq (, $(findstring -W,$(EXTRA_CFLAGS)))
>> +	ccflags-y += -Werror
>> +endif
>> +
>> +atmel_hlcdc-y := \
>> +	atmel_hlcdc_crtc.o \
>> +	atmel_hlcdc_panel.o \
>> +	atmel_hlcdc_backlight.o \
>> +	atmel_hlcdc_drv.o
>> +
>> +obj-$(CONFIG_DRM_ATMEL_HLCDC)	+= atmel_hlcdc.o
>> diff --git a/drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc.h b/drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc.h
>> new file mode 100644
>> index 0000000..8ed0767
>> --- /dev/null
>> +++ b/drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc.h
>> @@ -0,0 +1,771 @@
>> +/*
>> + *  Header file for AT91 High end LCD Controller
>> + *
>> + *  Data structure and register user interface
>> + *
>> + *  Copyright (C) 2010 Atmel Corporation
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU General Public License version 2 as published by
>> + * the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful, but WITHOUT
>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
>> + * more details.
>> + *
>> + * You should have received a copy of the GNU General Public License along with
>> + * this program.  If not, see <http://www.gnu.org/licenses/>.
>> + *
>> + */
>> +#ifndef __ATMEL_HLCD_H__
>> +#define __ATMEL_HLCD_H__
>> +
>> +/* Lcdc hardware registers */
>> +#define ATMEL_LCDC_LCDCFG0	0x0000
>> +#define LCDC_LCDCFG0_CLKPOL		(0x1 << 0)
>> +#define LCDC_LCDCFG0_CLKSEL		(0x1 << 2)
>> +#define LCDC_LCDCFG0_CLKPWMSEL		(0x1 << 3)
>> +#define LCDC_LCDCFG0_CGDISBASE		(0x1 << 8)
>> +#define LCDC_LCDCFG0_CGDISOVR1		(0x1 << 9)
>> +#define LCDC_LCDCFG0_CGDISOVR2		(0x1 << 10)
>> +#define LCDC_LCDCFG0_CGDISHEO		(0x1 << 11)
>> +#define LCDC_LCDCFG0_CGDISHCR		(0x1 << 12)
>> +#define LCDC_LCDCFG0_CGDISPP		(0x1 << 13)
>> +#define LCDC_LCDCFG0_CLKDIV_OFFSET	16
>> +#define LCDC_LCDCFG0_CLKDIV		(0xff << LCDC_LCDCFG0_CLKDIV_OFFSET)
>> +
>> +#define ATMEL_LCDC_LCDCFG1	0x0004
>> +#define LCDC_LCDCFG1_HSPW_OFFSET	0
>> +#define LCDC_LCDCFG1_HSPW		(0x3f << LCDC_LCDCFG1_HSPW_OFFSET)
>> +#define LCDC_LCDCFG1_VSPW_OFFSET	16
>> +#define LCDC_LCDCFG1_VSPW		(0x3f << LCDC_LCDCFG1_VSPW_OFFSET)
>> +
>> +#define ATMEL_LCDC_LCDCFG2	0x0008
>> +#define LCDC_LCDCFG2_VFPW_OFFSET	0
>> +#define LCDC_LCDCFG2_VFPW		(0x3f << LCDC_LCDCFG2_VFPW_OFFSET)
>> +#define LCDC_LCDCFG2_VBPW_OFFSET	16
>> +#define LCDC_LCDCFG2_VBPW		(0x3f << LCDC_LCDCFG2_VBPW_OFFSET)
>> +
>> +#define ATMEL_LCDC_LCDCFG3	0x000C
>> +#define LCDC_LCDCFG3_HFPW_OFFSET	0
>> +#define LCDC_LCDCFG3_HFPW		(0xff << LCDC_LCDCFG3_HFPW_OFFSET)
>> +#define LCDC2_LCDCFG3_HFPW		(0x1ff << LCDC_LCDCFG3_HFPW_OFFSET)
>> +#define LCDC_LCDCFG3_HBPW_OFFSET	16
>> +#define LCDC_LCDCFG3_HBPW		(0xff << LCDC_LCDCFG3_HBPW_OFFSET)
>> +#define LCDC2_LCDCFG3_HBPW		(0x1ff << LCDC_LCDCFG3_HBPW_OFFSET)
>> +
>> +#define ATMEL_LCDC_LCDCFG4	0x0010
>> +#define LCDC_LCDCFG4_PPL_OFFSET		0
>> +#define LCDC_LCDCFG4_PPL		(0x7ff << LCDC_LCDCFG4_PPL_OFFSET)
>> +#define LCDC_LCDCFG4_RPF_OFFSET		16
>> +#define LCDC_LCDCFG4_RPF		(0x7ff << LCDC_LCDCFG4_RPF_OFFSET)
>> +
>> +#define ATMEL_LCDC_LCDCFG5	0x0014
>> +#define LCDC_LCDCFG5_HSPOL		(0x1 << 0)
>> +#define LCDC_LCDCFG5_VSPOL		(0x1 << 1)
>> +#define LCDC_LCDCFG5_VSPDLYS		(0x1 << 2)
>> +#define LCDC_LCDCFG5_VSPDLYE		(0x1 << 3)
>> +#define LCDC_LCDCFG5_DISPPOL		(0x1 << 4)
>> +#define LCDC_LCDCFG5_SERIAL		(0x1 << 5)
>> +#define LCDC_LCDCFG5_DITHER		(0x1 << 6)
>> +#define LCDC_LCDCFG5_DISPDLY		(0x1 << 7)
>> +#define LCDC_LCDCFG5_MODE_OFFSET	8
>> +#define LCDC_LCDCFG5_MODE		(0x3 << LCDC_LCDCFG5_MODE_OFFSET)
>> +#define		LCDC_LCDCFG5_MODE_OUTPUT_12BPP		(0x0 << 8)
>> +#define		LCDC_LCDCFG5_MODE_OUTPUT_16BPP		(0x1 << 8)
>> +#define		LCDC_LCDCFG5_MODE_OUTPUT_18BPP		(0x2 << 8)
>> +#define		LCDC_LCDCFG5_MODE_OUTPUT_24BPP		(0x3 << 8)
>> +#define LCDC_LCDCFG5_PP			(0x1 << 10)
>> +#define LCDC_LCDCFG5_VSPSU		(0x1 << 12)
>> +#define LCDC_LCDCFG5_VSPHO		(0x1 << 13)
>> +#define LCDC_LCDCFG5_GUARDTIME_OFFSET	16
>> +#define LCDC_LCDCFG5_GUARDTIME		(0x1f << LCDC_LCDCFG5_GUARDTIME_OFFSET)
>> +
>> +#define ATMEL_LCDC_LCDCFG6	0x0018
>> +#define LCDC_LCDCFG6_PWMPS_OFFSET	0
>> +#define LCDC_LCDCFG6_PWMPS		(0x7 << LCDC_LCDCFG6_PWMPS_OFFSET)
>> +#define LCDC_LCDCFG6_PWMPOL		(0x1 << 4)
>> +#define LCDC_LCDCFG6_PWMCVAL_OFFSET	8
>> +#define LCDC_LCDCFG6_PWMCVAL		(0xff << LCDC_LCDCFG6_PWMCVAL_OFFSET)
>> +
>> +#define ATMEL_LCDC_LCDEN	0x0020
>> +#define LCDC_LCDEN_CLKEN		(0x1 << 0)
>> +#define LCDC_LCDEN_SYNCEN		(0x1 << 1)
>> +#define LCDC_LCDEN_DISPEN		(0x1 << 2)
>> +#define LCDC_LCDEN_PWMEN		(0x1 << 3)
>> +
>> +#define ATMEL_LCDC_LCDDIS	0x0024
>> +#define LCDC_LCDDIS_CLKDIS		(0x1 << 0)
>> +#define LCDC_LCDDIS_SYNCDIS		(0x1 << 1)
>> +#define LCDC_LCDDIS_DISPDIS		(0x1 << 2)
>> +#define LCDC_LCDDIS_PWMDIS		(0x1 << 3)
>> +#define LCDC_LCDDIS_CLKRST		(0x1 << 8)
>> +#define LCDC_LCDDIS_SYNCRST		(0x1 << 9)
>> +#define LCDC_LCDDIS_DISPRST		(0x1 << 10)
>> +#define LCDC_LCDDIS_PWMRST		(0x1 << 11)
>> +
>> +#define ATMEL_LCDC_LCDSR	0x0028
>> +#define LCDC_LCDSR_CLKSTS		(0x1 << 0)
>> +#define LCDC_LCDSR_LCDSTS		(0x1 << 1)
>> +#define LCDC_LCDSR_DISPSTS		(0x1 << 2)
>> +#define LCDC_LCDSR_PWMSTS		(0x1 << 3)
>> +#define LCDC_LCDSR_SIPSTS		(0x1 << 4)
>> +
>> +#define ATMEL_LCDC_LCDIER	0x002C
>> +#define LCDC_LCDIER_SOFIE		(0x1 << 0)
>> +#define LCDC_LCDIER_DISIE		(0x1 << 1)
>> +#define LCDC_LCDIER_DISPIE		(0x1 << 2)
>> +#define LCDC_LCDIER_FIFOERRIE		(0x1 << 4)
>> +#define LCDC_LCDIER_BASEIE		(0x1 << 8)
>> +#define LCDC_LCDIER_OVR1IE		(0x1 << 9)
>> +#define LCDC_LCDIER_OVR2IE		(0x1 << 10)
>> +#define LCDC_LCDIER_HEOIE		(0x1 << 11)
>> +#define LCDC_LCDIER_HCRIE		(0x1 << 12)
>> +#define LCDC_LCDIER_PPIE		(0x1 << 13)
>> +
>> +#define ATMEL_LCDC_LCDIDR	0x0030
>> +#define LCDC_LCDIDR_SOFID		(0x1 << 0)
>> +#define LCDC_LCDIDR_DISID		(0x1 << 1)
>> +#define LCDC_LCDIDR_DISPID		(0x1 << 2)
>> +#define LCDC_LCDIDR_FIFOERRID		(0x1 << 4)
>> +#define LCDC_LCDIDR_BASEID		(0x1 << 8)
>> +#define LCDC_LCDIDR_OVR1ID		(0x1 << 9)
>> +#define LCDC_LCDIDR_OVR2ID		(0x1 << 10)
>> +#define LCDC_LCDIDR_HEOID		(0x1 << 11)
>> +#define LCDC_LCDIDR_HCRID		(0x1 << 12)
>> +#define LCDC_LCDIDR_PPID		(0x1 << 13)
>> +
>> +#define ATMEL_LCDC_LCDIMR	0x0034
>> +#define LCDC_LCDIMR_SOFIM		(0x1 << 0)
>> +#define LCDC_LCDIMR_DISIM		(0x1 << 1)
>> +#define LCDC_LCDIMR_DISPIM		(0x1 << 2)
>> +#define LCDC_LCDIMR_FIFOERRIM		(0x1 << 4)
>> +#define LCDC_LCDIMR_BASEIM		(0x1 << 8)
>> +#define LCDC_LCDIMR_OVR1IM		(0x1 << 9)
>> +#define LCDC_LCDIMR_OVR2IM		(0x1 << 10)
>> +#define LCDC_LCDIMR_HEOIM		(0x1 << 11)
>> +#define LCDC_LCDIMR_HCRIM		(0x1 << 12)
>> +#define LCDC_LCDIMR_PPIM		(0x1 << 13)
>> +
>> +#define ATMEL_LCDC_LCDISR	0x0038
>> +#define LCDC_LCDISR_SOF			(0x1 << 0)
>> +#define LCDC_LCDISR_DIS			(0x1 << 1)
>> +#define LCDC_LCDISR_DISP		(0x1 << 2)
>> +#define LCDC_LCDISR_FIFOERR		(0x1 << 4)
>> +#define LCDC_LCDISR_BASE		(0x1 << 8)
>> +#define LCDC_LCDISR_OVR1		(0x1 << 9)
>> +#define LCDC_LCDISR_OVR2		(0x1 << 10)
>> +#define LCDC_LCDISR_HEO			(0x1 << 11)
>> +#define LCDC_LCDISR_HCR			(0x1 << 12)
>> +#define LCDC_LCDISR_PP			(0x1 << 13)
>> +
>> +#define ATMEL_LCDC_BASECHER	0x0040
>> +#define LCDC_BASECHER_CHEN		(0x1 << 0)
>> +#define LCDC_BASECHER_UPDATEEN		(0x1 << 1)
>> +#define LCDC_BASECHER_A2QEN		(0x1 << 2)
>> +
>> +#define ATMEL_LCDC_BASECHDR	0x0044
>> +#define LCDC_BASECHDR_CHDIS		(0x1 << 0)
>> +#define LCDC_BASECHDR_CHRST		(0x1 << 8)
>> +
>> +#define ATMEL_LCDC_BASECHSR	0x0048
>> +#define LCDC_BASECHSR_CHSR		(0x1 << 0)
>> +#define LCDC_BASECHSR_UPDATESR		(0x1 << 1)
>> +#define LCDC_BASECHSR_A2QSR		(0x1 << 2)
>> +
>> +#define ATMEL_LCDC_BASEIER	0x004C
>> +#define LCDC_BASEIER_DMA		(0x1 << 2)
>> +#define LCDC_BASEIER_DSCR		(0x1 << 3)
>> +#define LCDC_BASEIER_ADD		(0x1 << 4)
>> +#define LCDC_BASEIER_DONE		(0x1 << 5)
>> +#define LCDC_BASEIER_OVR		(0x1 << 6)
>> +
>> +#define ATMEL_LCDC_BASEIDR	0x0050
>> +#define LCDC_BASEIDR_DMA		(0x1 << 2)
>> +#define LCDC_BASEIDR_DSCR		(0x1 << 3)
>> +#define LCDC_BASEIDR_ADD		(0x1 << 4)
>> +#define LCDC_BASEIDR_DONE		(0x1 << 5)
>> +#define LCDC_BASEIDR_OVR		(0x1 << 6)
>> +
>> +#define ATMEL_LCDC_BASEIMR	0x0054
>> +#define LCDC_BASEIMR_DMA		(0x1 << 2)
>> +#define LCDC_BASEIMR_DSCR		(0x1 << 3)
>> +#define LCDC_BASEIMR_ADD		(0x1 << 4)
>> +#define LCDC_BASEIMR_DONE		(0x1 << 5)
>> +#define LCDC_BASEIMR_OVR		(0x1 << 6)
>> +
>> +#define ATMEL_LCDC_BASEISR	0x0058
>> +#define LCDC_BASEISR_DMA		(0x1 << 2)
>> +#define LCDC_BASEISR_DSCR		(0x1 << 3)
>> +#define LCDC_BASEISR_ADD		(0x1 << 4)
>> +#define LCDC_BASEISR_DONE		(0x1 << 5)
>> +#define LCDC_BASEISR_OVR		(0x1 << 6)
>> +
>> +#define ATMEL_LCDC_BASEHEAD	0x005C
>> +
>> +#define ATMEL_LCDC_BASEADDR	0x0060
>> +
>> +#define ATMEL_LCDC_BASECTRL	0x0064
>> +#define LCDC_BASECTRL_DFETCH		(0x1 << 0)
>> +#define LCDC_BASECTRL_LFETCH		(0x1 << 1)
>> +#define LCDC_BASECTRL_DMAIEN		(0x1 << 2)
>> +#define LCDC_BASECTRL_DSCRIEN		(0x1 << 3)
>> +#define LCDC_BASECTRL_ADDIEN		(0x1 << 4)
>> +#define LCDC_BASECTRL_DONEIEN		(0x1 << 5)
>> +
>> +#define ATMEL_LCDC_BASENEXT	0x0068
>> +
>> +#define ATMEL_LCDC_BASECFG0	0x006C
>> +#define LCDC_BASECFG0_SIF		(0x1 << 0)
>> +#define LCDC_BASECFG0_BLEN_OFFSET 4
>> +#define LCDC_BASECFG0_BLEN		(0x3 << LCDC_BASECFG0_BLEN_OFFSET)
>> +#define		LCDC_BASECFG0_BLEN_AHB_SINGLE		(0x0 << 4)
>> +#define		LCDC_BASECFG0_BLEN_AHB_INCR4		(0x1 << 4)
>> +#define		LCDC_BASECFG0_BLEN_AHB_INCR8		(0x2 << 4)
>> +#define		LCDC_BASECFG0_BLEN_AHB_INCR16		(0x3 << 4)
>> +#define LCDC_BASECFG0_DLBO		(0x1 << 8)
>> +
>> +#define ATMEL_LCDC_BASECFG1	0x0070
>> +#define LCDC_BASECFG1_CLUTEN		(0x1 << 0)
>> +#define LCDC_BASECFG1_RGBMODE_OFFSET	4
>> +#define LCDC_BASECFG1_RGBMODE		(0xf << LCDC_BASECFG1_RGBMODE_OFFSET)
>> +#define		LCDC_BASECFG1_RGBMODE_12BPP_RGB_444	(0x0 << 4)
>> +#define		LCDC_BASECFG1_RGBMODE_16BPP_ARGB_4444	(0x1 << 4)
>> +#define		LCDC_BASECFG1_RGBMODE_16BPP_RGBA_4444	(0x2 << 4)
>> +#define		LCDC_BASECFG1_RGBMODE_16BPP_RGB_565	(0x3 << 4)
>> +#define		LCDC_BASECFG1_RGBMODE_16BPP_TRGB_1555	(0x4 << 4)
>> +#define		LCDC_BASECFG1_RGBMODE_18BPP_RGB_666	(0x5 << 4)
>> +#define		LCDC_BASECFG1_RGBMODE_18BPP_RGB_666_PACKED	(0x6 << 4)
>> +#define		LCDC_BASECFG1_RGBMODE_19BPP_TRGB_1666	(0x7 << 4)
>> +#define		LCDC_BASECFG1_RGBMODE_19BPP_TRGB_PACKED	(0x8 << 4)
>> +#define		LCDC_BASECFG1_RGBMODE_24BPP_RGB_888	(0x9 << 4)
>> +#define		LCDC_BASECFG1_RGBMODE_24BPP_RGB_888_PACKED	(0xA << 4)
>> +#define		LCDC_BASECFG1_RGBMODE_25BPP_TRGB_1888	(0xB << 4)
>> +#define		LCDC_BASECFG1_RGBMODE_32BPP_ARGB_8888	(0xC << 4)
>> +#define		LCDC_BASECFG1_RGBMODE_32BPP_RGBA_8888	(0xD << 4)
>> +#define LCDC_BASECFG1_CLUTMODE_OFFSET	8
>> +#define LCDC_BASECFG1_CLUTMODE		(0x3 << LCDC_BASECFG1_CLUTMODE_OFFSET)
>> +#define		LCDC_BASECFG1_CLUTMODE_1BPP		(0x0 << 8)
>> +#define		LCDC_BASECFG1_CLUTMODE_2BPP		(0x1 << 8)
>> +#define		LCDC_BASECFG1_CLUTMODE_4BPP		(0x2 << 8)
>> +#define		LCDC_BASECFG1_CLUTMODE_8BPP		(0x3 << 8)
>> +
>> +#define ATMEL_LCDC_BASECFG2	0x0074
>> +
>> +#define ATMEL_LCDC_BASECFG3	0x0078
>> +#define LCDC_BASECFG3_BDEF_OFFSET	0
>> +#define LCDC_BASECFG3_BDEF		(0xff << LCDC_BASECFG3_BDEF_OFFSET)
>> +#define LCDC_BASECFG3_GDEF_OFFSET	8
>> +#define LCDC_BASECFG3_GDEF		(0xff << LCDC_BASECFG3_GDEF_OFFSET)
>> +#define LCDC_BASECFG3_RDEF_OFFSET	16
>> +#define LCDC_BASECFG3_RDEF		(0xff << LCDC_BASECFG3_RDEF_OFFSET)
>> +
>> +#define ATMEL_LCDC_BASECFG4	0x007C
>> +#define LCDC_BASECFG4_DMA		(0x1 << 8)
>> +#define LCDC_BASECFG4_REP		(0x1 << 9)
>> +#define LCDC_BASECFG4_DISCEN		(0x1 << 11)
>> +
>> +#define ATMEL_LCDC_BASECFG5	0x0080
>> +#define LCDC_BASECFG5_DISCXPOS_OFFSET	0
>> +#define LCDC_BASECFG5_DISCXPOS		(0x7ff << LCDC_BASECFG5_DISCXPOS_OFFSET)
>> +#define LCDC_BASECFG5_DISCYPOS_OFFSET	16
>> +#define LCDC_BASECFG5_DISCYPOS		(0x7ff << LCDC_BASECFG5_DISCYPOS_OFFSET)
>> +
>> +#define ATMEL_LCDC_BASECFG6	0x0084
>> +#define LCDC_BASECFG6_DISCXSIZE_OFFSET	0
>> +#define LCDC_BASECFG6_DISCXSIZE       (0x7ff << LCDC_BASECFG6_DISCXSIZE_OFFSET)
>> +#define LCDC_BASECFG6_DISCYSIZE_OFFSET	16
>> +#define LCDC_BASECFG6_DISCYSIZE       (0x7ff << LCDC_BASECFG6_DISCYSIZE_OFFSET)
>> +
> 
> All layers use pretty much the same layout (IER,IDR, IMR, HEAD, ADDR, ...).
> Maybe you could define something like this:
> 
> ATMEL_LCDC_CHER(layer)    (layer->reg_offset + (0x0))
> ATMEL_LCDC_CHDR(layer)    (layer->reg_offset + (0x4))
> ...
> 
> with each layer storing its own reg_offset.
> 
> IMHO, this would reduce the MACRO list size and thus make this file more
> readable.
> 

Sure, it would be easier. For this RFC I used the header provided by
ATMEL with no modification, but it'll probably need a clean-up pass.

> 
>> +#define ATMEL_LCDC_HEOCHER	0x0280
>> +#define ATMEL_LCDC2_HEOCHER	0x0340
>> +#define LCDC_HEOCHER_CHEN		(0x1 << 0)
>> +#define LCDC_HEOCHER_UPDATEEN		(0x1 << 1)
>> +#define LCDC_HEOCHER_A2QEN		(0x1 << 2)
> 
> [...]
> 
>> +#define ATMEL_LCDC_HCRCLUT	0x1400
>> +#define ATMEL_LCDC2_HCRCLUT	0x1600
>> +#define LCDC_HCRCLUT_BCLUT_OFFSET	0
>> +#define LCDC_HCRCLUT_BCLUT		(0xff << LCDC_HCRCLUT_BCLUT_OFFSET)
>> +#define LCDC_HCRCLUT_GCLUT_OFFSET	8
>> +#define LCDC_HCRCLUT_GCLUT		(0xff << LCDC_HCRCLUT_GCLUT_OFFSET)
>> +#define LCDC_HCRCLUT_RCLUT_OFFSET	16
>> +#define LCDC_HCRCLUT_RCLUT		(0xff << LCDC_HCRCLUT_RCLUT_OFFSET)
>> +#define LCDC_HCRCLUT_ACLUT_OFFSET	24
>> +#define LCDC_HCRCLUT_ACLUT		(0xff << LCDC_HCRCLUT_ACLUT_OFFSET)
>> +
>> +/* Base layer CLUT */
>> +#define ATMEL_HLCDC_LUT			0x0400
>> +
>> +
>> +static inline void hlcdc_write(struct drm_device *dev, u32 reg, u32 data)
>> +{
>> +	struct atmel_hlcdc_drm_private *priv = dev->dev_private;
>> +	iowrite32(data, priv->mmio + reg);
>> +}
>> +
>> +static inline u32 hlcdc_read(struct drm_device *dev, u32 reg)
>> +{
>> +	struct atmel_hlcdc_drm_private *priv = dev->dev_private;
>> +	return ioread32(priv->mmio + reg);
>> +}
>> +
>> +#endif /* __ATMEL_HLCDC4_H__ */
>> diff --git a/drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_backlight.c b/drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_backlight.c
>> new file mode 100644
>> index 0000000..143ba72
>> --- /dev/null
>> +++ b/drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_backlight.c
>> @@ -0,0 +1,92 @@
>> +/*
>> + * atmel_hlcdc_backlight.c  --  Backlight driver for the atmel HLCDC controller
>> + *
>> + * Copyright (C) 2014 Traphandler
>> + *
>> + * Author: Jean-Jacques Hiblot <jjhiblot@traphandler.com)
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU General Public License version 2 as published by
>> + * the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful, but WITHOUT
>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
>> + * more details.
>> + *
>> + * You should have received a copy of the GNU General Public License along with
>> + * this program.  If not, see <http://www.gnu.org/licenses/>.
>> + */
>> +
>> +#include <linux/backlight.h>
>> +
>> +#include "atmel_hlcdc_drv.h"
>> +#include "atmel_hlcdc.h"
>> +
>> +#define ATMEL_LCDC_CVAL_DEFAULT         0xc8
>> +
>> +
>> +static int get_brightness(struct backlight_device *backlight)
>> +{
>> +	struct drm_device *dev = bl_get_data(backlight);
>> +
>> +	return (hlcdc_read(dev, ATMEL_LCDC_LCDCFG6) & LCDC_LCDCFG6_PWMCVAL)
>> +		>> LCDC_LCDCFG6_PWMCVAL_OFFSET;
>> +}
>> +
>> +static int update_status(struct backlight_device *backlight)
>> +{
>> +	struct drm_device *dev = bl_get_data(backlight);
>> +	int brightness = backlight->props.brightness;
>> +	u32 reg;
>> +
>> +	if (backlight->props.power != FB_BLANK_UNBLANK ||
>> +	    backlight->props.state & BL_CORE_SUSPENDED)
>> +		brightness = 0;
>> +
>> +	reg = hlcdc_read(dev, ATMEL_LCDC_LCDCFG6) & ~LCDC_LCDCFG6_PWMCVAL;
>> +	reg |= brightness << LCDC_LCDCFG6_PWMCVAL_OFFSET;
>> +	hlcdc_write(dev, ATMEL_LCDC_LCDCFG6, reg);
>> +	DBG("new brightness is : %d\n", get_brightness(backlight));
>> +	return 0;
>> +}
>> +
>> +
>> +
>> +static const struct backlight_ops atmel_drm_backlight_ops = {
>> +	.options	= BL_CORE_SUSPENDRESUME,
>> +	.update_status	= update_status,
>> +	.get_brightness	= get_brightness,
>> +};
>> +
>> +int atmel_drm_backlight_init(struct drm_device *dev)
>> +{
>> +	struct atmel_hlcdc_drm_private *priv = dev->dev_private;
>> +	struct backlight_device *backlight;
>> +
>> +	backlight = backlight_device_register("backlight", dev->dev, dev,
>> +					      &atmel_drm_backlight_ops , NULL);
>> +	if (IS_ERR(backlight)) {
>> +		dev_err(dev->dev, "unable to register backlight device: %ld\n",
>> +			PTR_ERR(backlight));
>> +		return PTR_ERR(backlight);
>> +	}
>> +	hlcdc_write(dev, ATMEL_LCDC_LCDCFG6, LCDC_LCDCFG6_PWMPOL |
>> +		(ATMEL_LCDC_CVAL_DEFAULT << LCDC_LCDCFG6_PWMCVAL_OFFSET));
>> +
>> +	backlight->props.max_brightness = 0xFF;
>> +	backlight->props.brightness = get_brightness(backlight);
>> +	backlight->props.power = FB_BLANK_UNBLANK;
>> +	backlight_update_status(backlight);
>> +
>> +	priv->backlight = backlight;
>> +
>> +	return 0;
>> +}
>> +
>> +void atmel_drm_backlight_exit(struct drm_device *dev)
>> +{
>> +	struct atmel_hlcdc_drm_private *priv = dev->dev_private;
>> +
>> +	backlight_device_unregister(priv->backlight);
>> +}
> 
> Atmel's datasheet describe it as a PWM (that will most likely be used as
> a backlight, but still :-)).
> How about implementing a pwm chip and then use the backlight-pwm driver
> to expose a backlight device based on this PWM device ?

I thought about this when writing this part. I wondered if this PWM will
ever be used for something else than backlight control as the ATMEL's
chip already have several PWM outputs that are more advanced than this
one. It's more straightforward and the amount of code is less.

> 
>> diff --git a/drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_backlight.h b/drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_backlight.h
>> new file mode 100644
>> index 0000000..6a99101
>> --- /dev/null
>> +++ b/drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_backlight.h
>> @@ -0,0 +1,25 @@
>> +/*
>> + * Copyright (C) 2014 Traphandler
>> + *
>> + * Author: Jean-Jacques Hiblot <jjhiblot@traphandler.com)
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU General Public License version 2 as published by
>> + * the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful, but WITHOUT
>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
>> + * more details.
>> + *
>> + * You should have received a copy of the GNU General Public License along with
>> + * this program.  If not, see <http://www.gnu.org/licenses/>.
>> + */
>> +
>> +#ifndef __ATMEL_HLCDC_BACKLIGHT_H__
>> +#define __ATMEL_HLCDC_BACKLIGHT_H__
>> +
>> +int atmel_drm_backlight_init(struct drm_device *dev);
>> +void atmel_drm_backlight_exit(struct drm_device *dev);
>> +
>> +#endif
>> diff --git a/drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_crtc.c b/drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_crtc.c
>> new file mode 100644
>> index 0000000..649fa19
>> --- /dev/null
>> +++ b/drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_crtc.c
>> @@ -0,0 +1,702 @@
>> +/*
>> + * Copyright (C) 2014 Traphandler
>> + *
>> + * Author: Jean-Jacques Hiblot <jjhiblot@traphandler.com)
>> + *
>> + * Base on the tilcdc driver
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU General Public License version 2 as published by
>> + * the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful, but WITHOUT
>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
>> + * more details.
>> + *
>> + * You should have received a copy of the GNU General Public License along with
>> + * this program.  If not, see <http://www.gnu.org/licenses/>.
>> + */
>> +
>> +#include "drm_flip_work.h"
>> +
>> +#include "atmel_hlcdc_drv.h"
>> +#include "atmel_hlcdc.h"
>> +#include "atmel_hlcdc_ovl.h"
>> +
>> +#define MAX(x, y) ((x) > (y) ? (x) : (y))
>> +
>> +
>> +struct atmel_hlcd_dma_desc {
>> +	u32	address;
> 
> I think you should use dma_addr_t instead of u32.
> 
>> +	u32	control;
>> +	u32	next;
> 
> ditto
> 
>> +	u32     dummy; /* for 64-bit alignment */
>> +};
>> +
>> +enum {
>> +	DMA_BASE = 0,
>> +	DMA_OVR_1,
>> +	DMA_OVR_2,
>> +	DMA_HEO,
>> +	DMA_HCR,
>> +	DMA_PP,
>> +	DMA_MAX
>> +};
>> +
>> +struct atmel_hlcdc_crtc {
>> +	struct drm_crtc base;
>> +	uint32_t dirty;
>> +	dma_addr_t start, end;
>> +	struct drm_pending_vblank_event *event;
>> +	int dpms;
>> +
>> +	struct atmel_hlcd_dma_desc *dma_descs[DMA_MAX];
>> +	dma_addr_t dma_descs_phys[DMA_MAX];
>> +
>> +	/* fb currently set to scanout 0/1: */
>> +	struct drm_framebuffer *fb;
>> +
>> +	/* for deferred fb unref's: */
>> +	struct drm_flip_work unref_work;
>> +#ifdef USE_LUT
>> +	u8 lut_r[256], lut_g[256], lut_b[256];
>> +#endif
>> +};
>> +#define to_atmel_hlcdc_crtc(x) container_of(x, struct atmel_hlcdc_crtc, base)
>> +
>> +static void unref_worker(struct drm_flip_work *work, void *val)
>> +{
>> +	struct atmel_hlcdc_crtc *atmel_hlcdc_crtc =
>> +		container_of(work, struct atmel_hlcdc_crtc, unref_work);
>> +	struct drm_device *dev = atmel_hlcdc_crtc->base.dev;
>> +
>> +	mutex_lock(&dev->mode_config.mutex);
>> +	drm_framebuffer_unreference(val);
>> +	mutex_unlock(&dev->mode_config.mutex);
>> +}
>> +
>> +static void update_scanout(struct drm_crtc *crtc)
>> +{
>> +	struct atmel_hlcdc_crtc *hlcdc_crtc = to_atmel_hlcdc_crtc(crtc);
>> +	struct drm_device *dev = crtc->dev;
>> +	struct atmel_hlcdc_drm_private *priv = dev->dev_private;
>> +	struct drm_framebuffer *fb = crtc->fb;
>> +
>> +	struct drm_gem_cma_object *gem;
>> +	struct atmel_hlcd_dma_desc *desc = hlcdc_crtc->dma_descs[DMA_BASE];
>> +	unsigned int depth, bpp;
>> +	dma_addr_t start;
>> +	dma_addr_t desc_phys = hlcdc_crtc->dma_descs_phys[DMA_BASE];
>> +
>> +	drm_fb_get_bpp_depth(fb->pixel_format, &depth, &bpp);
>> +	gem = drm_fb_cma_get_gem_obj(fb, 0);
>> +
>> +	start = gem->paddr + fb->offsets[0] +
>> +			(crtc->y * fb->pitches[0]) + (crtc->x * bpp/8);
>> +
>> +	if (hlcdc_crtc->fb != fb) {
>> +		struct drm_framebuffer *oldfb = hlcdc_crtc->fb;
>> +		drm_framebuffer_reference(fb);
>> +		hlcdc_crtc->fb = fb;
>> +		if (oldfb) {
>> +			drm_flip_work_queue(&hlcdc_crtc->unref_work, oldfb);
>> +			drm_flip_work_commit(&hlcdc_crtc->unref_work, priv->wq);
>> +		}
>> +	}
>> +
>> +	if (desc->address != start) {
>> +		desc->address = start;
>> +		desc->next = desc_phys;
>> +		desc->control = LCDC_OVRCTRL_DFETCH;
>> +	}
>> +
>> +	if (hlcdc_read(dev, ATMEL_LCDC_BASENEXT) != desc_phys) {
>> +		hlcdc_write(dev, ATMEL_LCDC_BASENEXT, desc_phys);
> 
> I read the datasheet several times, and wonder how this could work.
> 
> Here's what I understood:
> 
> If you want to initiate a DMA transfer and the layer channel is not
> enabled yet, you have to write ATMEL_LCDC_BASEADDR, ATMEL_LCDC_BASENEXT
> and ATMEL_LCDC_BASECTRL registers, and then write the CHEN bit in the
> CHER register.
> If the layer channel is already enabled and a DMA transfer is in
> progress, you'd better use the HEAD pointer and write the A2QEN bit.
> 
> Here, you're only writing the NEXT pointer, and AFAICT this can only
> work if the layer has already been enabled (by the bootloader for example).

OK. I'll put back the complete init of the DMA. This should probably be
changed to be more genreic so that other layers can also use this DMA
initialization.


> 
>> +		hlcdc_write(dev, ATMEL_LCDC_BASECHER, LCDC_BASECHER_UPDATEEN);
>> +	}
>> +}
>> +
>> +static void start(struct drm_crtc *crtc)
>> +{
>> +	struct drm_device *dev = crtc->dev;
>> +
>> +	hlcdc_write(dev, ATMEL_LCDC_LCDEN, LCDC_LCDEN_CLKEN);
>> +	while (!(hlcdc_read(dev, ATMEL_LCDC_LCDSR) & LCDC_LCDSR_CLKSTS))
>> +		cpu_relax();
>> +	hlcdc_write(dev, ATMEL_LCDC_LCDEN, LCDC_LCDEN_SYNCEN);
>> +	while (!(hlcdc_read(dev, ATMEL_LCDC_LCDSR) & LCDC_LCDSR_LCDSTS))
>> +		cpu_relax();
>> +	hlcdc_write(dev, ATMEL_LCDC_LCDEN, LCDC_LCDEN_DISPEN);
>> +	while (!(hlcdc_read(dev, ATMEL_LCDC_LCDSR) & LCDC_LCDSR_DISPSTS))
>> +		cpu_relax();
>> +	hlcdc_write(dev, ATMEL_LCDC_LCDEN, LCDC_LCDEN_PWMEN);
>> +	while (!(hlcdc_read(dev, ATMEL_LCDC_LCDSR) & LCDC_LCDSR_PWMSTS))
>> +		cpu_relax();
>> +}
>> +
>> +static void stop(struct drm_crtc *crtc)
>> +{
>> +	struct drm_device *dev = crtc->dev;
>> +
>> +	/* Disable DISP signal */
>> +	hlcdc_write(dev, ATMEL_LCDC_LCDDIS, LCDC_LCDDIS_DISPDIS);
>> +	while ((hlcdc_read(dev, ATMEL_LCDC_LCDSR) & LCDC_LCDSR_DISPSTS))
>> +		cpu_relax();
>> +	/* Disable synchronization */
>> +	hlcdc_write(dev, ATMEL_LCDC_LCDDIS, LCDC_LCDDIS_SYNCDIS);
>> +	while ((hlcdc_read(dev, ATMEL_LCDC_LCDSR) & LCDC_LCDSR_LCDSTS))
>> +		cpu_relax();
>> +	/* Disable pixel clock */
>> +	hlcdc_write(dev, ATMEL_LCDC_LCDDIS, LCDC_LCDDIS_CLKDIS);
>> +	while ((hlcdc_read(dev, ATMEL_LCDC_LCDSR) & LCDC_LCDSR_CLKSTS))
>> +		cpu_relax();
>> +	/* Disable PWM */
>> +	hlcdc_write(dev, ATMEL_LCDC_LCDDIS, LCDC_LCDDIS_PWMDIS);
>> +	while ((hlcdc_read(dev, ATMEL_LCDC_LCDSR) & LCDC_LCDSR_PWMSTS))
>> +		cpu_relax();
>> +}
>> +
>> +static void atmel_hlcdc_crtc_destroy(struct drm_crtc *crtc)
>> +{
>> +	struct atmel_hlcdc_crtc *atmel_hlcdc_crtc = to_atmel_hlcdc_crtc(crtc);
>> +	struct drm_device *dev = crtc->dev;
>> +
>> +	WARN_ON(atmel_hlcdc_crtc->dpms == DRM_MODE_DPMS_ON);
>> +
>> +	drm_crtc_cleanup(crtc);
>> +	drm_flip_work_cleanup(&atmel_hlcdc_crtc->unref_work);
>> +
>> +	if (atmel_hlcdc_crtc->dma_descs[0])
>> +		dma_free_writecombine(dev->dev,
>> +			      sizeof(struct atmel_hlcd_dma_desc) * DMA_MAX,
>> +			      atmel_hlcdc_crtc->dma_descs[0],
>> +			      atmel_hlcdc_crtc->dma_descs_phys[0]);
>> +	kfree(atmel_hlcdc_crtc);
>> +}
>> +
>> +static int atmel_hlcdc_crtc_page_flip(struct drm_crtc *crtc,
>> +		struct drm_framebuffer *fb,
>> +		struct drm_pending_vblank_event *event,
>> +		uint32_t page_flip_flags)
>> +{
>> +	struct atmel_hlcdc_crtc *atmel_hlcdc_crtc = to_atmel_hlcdc_crtc(crtc);
>> +	struct drm_device *dev = crtc->dev;
>> +
>> +	if (atmel_hlcdc_crtc->event) {
>> +		dev_err(dev->dev, "already pending page flip!\n");
>> +		return -EBUSY;
>> +	}
>> +
>> +	crtc->fb = fb;
>> +	atmel_hlcdc_crtc->event = event;
>> +	update_scanout(crtc);
>> +	return 0;
>> +}
>> +
>> +static void atmel_hlcdc_crtc_dpms(struct drm_crtc *crtc, int mode)
>> +{
>> +	struct atmel_hlcdc_crtc *atmel_hlcdc_crtc = to_atmel_hlcdc_crtc(crtc);
>> +	struct drm_device *dev = crtc->dev;
>> +
>> +	/* we really only care about on or off: */
>> +	if (mode != DRM_MODE_DPMS_ON)
>> +		mode = DRM_MODE_DPMS_OFF;
>> +
>> +	if (atmel_hlcdc_crtc->dpms == mode)
>> +		return;
>> +
>> +	atmel_hlcdc_crtc->dpms = mode;
>> +
>> +	pm_runtime_get_sync(dev->dev);
>> +
>> +	if (mode == DRM_MODE_DPMS_ON) {
>> +		pm_runtime_forbid(dev->dev);
>> +		start(crtc);
>> +	} else {
>> +		stop(crtc);
>> +		pm_runtime_allow(dev->dev);
>> +	}
>> +
>> +	pm_runtime_put_sync(dev->dev);
>> +}
>> +
>> +static bool atmel_hlcdc_crtc_mode_fixup(struct drm_crtc *crtc,
>> +		const struct drm_display_mode *mode,
>> +		struct drm_display_mode *adjusted_mode)
>> +{
>> +	return true;
>> +}
>> +
>> +static void atmel_hlcdc_crtc_prepare(struct drm_crtc *crtc)
>> +{
>> +	atmel_hlcdc_crtc_dpms(crtc, DRM_MODE_DPMS_OFF);
>> +}
>> +
>> +static void atmel_hlcdc_crtc_commit(struct drm_crtc *crtc)
>> +{
>> +	atmel_hlcdc_crtc_dpms(crtc, DRM_MODE_DPMS_ON);
>> +}
>> +
>> +static u32 atmel_hlcdfb_get_rgbmode(struct device *dev, int depth, int bpp)
>> +{
>> +	u32 value = 0;
>> +
>> +	switch (depth) {
>> +	case 1:
>> +		value = LCDC_BASECFG1_CLUTMODE_1BPP | LCDC_BASECFG1_CLUTEN;
>> +		break;
>> +	case 2:
>> +		value = LCDC_BASECFG1_CLUTMODE_2BPP | LCDC_BASECFG1_CLUTEN;
>> +		break;
>> +	case 4:
>> +		value = LCDC_BASECFG1_CLUTMODE_4BPP | LCDC_BASECFG1_CLUTEN;
>> +		break;
>> +	case 8:
>> +		value = LCDC_BASECFG1_CLUTMODE_8BPP | LCDC_BASECFG1_CLUTEN;
>> +		break;
>> +	case 12:
>> +		value = LCDC_BASECFG1_RGBMODE_12BPP_RGB_444;
>> +		break;
>> +	case 16:
>> +		value = LCDC_BASECFG1_RGBMODE_16BPP_RGB_565;
>> +		break;
>> +	case 18:
>> +		value = LCDC_BASECFG1_RGBMODE_18BPP_RGB_666_PACKED;
>> +		break;
>> +	case 24:
>> +		value = LCDC_BASECFG1_RGBMODE_24BPP_RGB_888_PACKED;
>> +		break;
>> +	case 32:
>> +		value = LCDC_BASECFG1_RGBMODE_32BPP_ARGB_8888;
>> +		break;
>> +	default:
>> +		dev_err(dev, "Cannot set video mode for depth %d, bpp %d\n",
>> +			depth, bpp);
>> +		break;
>> +	}
>> +
>> +	return value;
>> +}
>> +
>> +
>> +void atmel_hlcdc_crtc_update_clk(struct drm_crtc *crtc, int clock)
>> +{
>> +	struct drm_device *dev = crtc->dev;
>> +	struct atmel_hlcdc_drm_private *priv = dev->dev_private;
>> +	unsigned long value;
>> +	unsigned long clk_value_khz;
>> +
>> +	if (clock == 0)
>> +		clock = crtc->mode.clock;
>> +
>> +	pm_runtime_get_sync(dev->dev);
>> +
>> +	clk_value_khz = clk_get_rate(priv->clk) / 1000;
>> +
>> +	value = DIV_ROUND_CLOSEST(clk_value_khz, clock);
>> +
>> +	if (value < 1) {
>> +		dev_notice(dev->dev, "using system clock as pixel clock\n");
>> +		value = LCDC_LCDCFG0_CLKPWMSEL | LCDC_LCDCFG0_CGDISBASE;
>> +		hlcdc_write(dev, ATMEL_LCDC_LCDCFG0, value);
>> +	} else {
>> +		dev_dbg(dev->dev, "  updated pixclk:     %lu KHz\n",
>> +				clk_value_khz / value);
>> +		value = value - 2;
>> +		dev_dbg(dev->dev, "  * programming CLKDIV = 0x%08lx\n",
>> +					value);
>> +		value = LCDC_LCDCFG0_CLKPWMSEL |
>> +			(value << LCDC_LCDCFG0_CLKDIV_OFFSET)
>> +			| LCDC_LCDCFG0_CGDISBASE;
>> +		hlcdc_write(dev, ATMEL_LCDC_LCDCFG0, value);
>> +	}
>> +
>> +	pm_runtime_put_sync(dev->dev);
>> +}
>> +
>> +static int atmel_hlcdc_crtc_mode_set(struct drm_crtc *crtc,
>> +		struct drm_display_mode *mode,
>> +		struct drm_display_mode *adjusted_mode,
>> +		int x, int y,
>> +		struct drm_framebuffer *old_fb)
>> +{
>> +	struct atmel_hlcdc_crtc *atmel_hlcdc_crtc = to_atmel_hlcdc_crtc(crtc);
>> +	struct drm_device *dev = crtc->dev;
>> +	struct atmel_hlcdc_drm_private *priv = dev->dev_private;
>> +	int dpms = atmel_hlcdc_crtc->dpms;
>> +	int hbp, hfp, hsw, vbp, vfp, vsw;
>> +	unsigned int depth, bpp;
>> +	unsigned long value;
>> +	int ret;
>> +
>> +	ret = atmel_hlcdc_crtc_mode_valid(crtc, mode);
>> +	if (WARN_ON(ret))
>> +		return ret;
>> +
>> +	pm_runtime_get_sync(dev->dev);
>> +
>> +	if (dpms == DRM_MODE_DPMS_ON)
>> +		atmel_hlcdc_crtc_dpms(crtc, DRM_MODE_DPMS_OFF);
>> +
>> +	dev_dbg(dev->dev, "%s:\n", __func__);
>> +
>> +
>> +	/* Set pixel clock */
>> +	atmel_hlcdc_crtc_update_clk(crtc, mode->clock);
>> +
>> +	/* Initialize control register 5 */
>> +	value = priv->default_lcdcfg5;
>> +	value |= (priv->guard_time << LCDC_LCDCFG5_GUARDTIME_OFFSET)
>> +		| LCDC_LCDCFG5_DISPDLY
>> +		| LCDC_LCDCFG5_VSPDLYS;
>> +
>> +	if (adjusted_mode->flags & DRM_MODE_FLAG_NHSYNC)
>> +		value |= LCDC_LCDCFG5_HSPOL;
>> +
>> +	if (adjusted_mode->flags & DRM_MODE_FLAG_NVSYNC)
>> +		value |= LCDC_LCDCFG5_VSPOL;
>> +
>> +	dev_dbg(dev->dev, "  * LCDC_LCDCFG5 = %08lx\n", value);
>> +	hlcdc_write(dev, ATMEL_LCDC_LCDCFG5, value);
>> +
>> +
>> +	/* Configure timings: */
>> +	hbp = MAX(mode->htotal - mode->hsync_end, 1);
>> +	hfp = MAX(mode->hsync_start - mode->hdisplay, 1);
>> +	hsw = MAX(mode->hsync_end - mode->hsync_start, 1);
>> +	vbp = MAX(mode->vtotal - mode->vsync_end, 0);
>> +	vfp = MAX(mode->vsync_start - mode->vdisplay, 1);
>> +	vsw = MAX(mode->vsync_end - mode->vsync_start, 1);
>> +
>> +	DBG("%dx%d, hbp=%u, hfp=%u, hsw=%u, vbp=%u, vfp=%u, vsw=%u",
>> +		mode->hdisplay, mode->vdisplay, hbp, hfp, hsw, vbp, vfp, vsw);
>> +
>> +	/* Vertical & Horizontal Timing */
>> +	value = (vsw - 1) << LCDC_LCDCFG1_VSPW_OFFSET;
>> +	value |= (hsw - 1) << LCDC_LCDCFG1_HSPW_OFFSET;
>> +	dev_dbg(dev->dev, "  * LCDC_LCDCFG1 = %08lx\n", value);
>> +	hlcdc_write(dev, ATMEL_LCDC_LCDCFG1, value);
>> +
>> +	value = (vbp) << LCDC_LCDCFG2_VBPW_OFFSET;
>> +	value |= (vfp - 1) << LCDC_LCDCFG2_VFPW_OFFSET;
>> +	dev_dbg(dev->dev, "  * LCDC_LCDCFG2 = %08lx\n", value);
>> +	hlcdc_write(dev, ATMEL_LCDC_LCDCFG2, value);
>> +
>> +	value = (hbp - 1) << LCDC_LCDCFG3_HBPW_OFFSET;
>> +	value |= (hfp - 1) << LCDC_LCDCFG3_HFPW_OFFSET;
>> +	dev_dbg(dev->dev, "  * LCDC_LCDCFG3 = %08lx\n", value);
>> +	hlcdc_write(dev, ATMEL_LCDC_LCDCFG3, value);
>> +
>> +	/* Display size */
>> +	value = (mode->vdisplay - 1) << LCDC_LCDCFG4_RPF_OFFSET;
>> +	value |= (mode->hdisplay - 1) << LCDC_LCDCFG4_PPL_OFFSET;
>> +	dev_dbg(dev->dev, "  * LCDC_LCDCFG4 = %08lx\n", value);
>> +	hlcdc_write(dev, ATMEL_LCDC_LCDCFG4, value);
>> +
>> +	hlcdc_write(dev, ATMEL_LCDC_BASECFG0,
>> +		    LCDC_BASECFG0_BLEN_AHB_INCR16 | LCDC_BASECFG0_DLBO);
>> +
>> +	drm_fb_get_bpp_depth(crtc->fb->pixel_format, &depth, &bpp);
>> +	hlcdc_write(dev, ATMEL_LCDC_BASECFG1,
>> +		    atmel_hlcdfb_get_rgbmode(dev->dev, depth, bpp));
>> +	hlcdc_write(dev, ATMEL_LCDC_BASECFG2, 0);
>> +	hlcdc_write(dev, ATMEL_LCDC_BASECFG3, 0);	/* Default color */
>> +	hlcdc_write(dev, ATMEL_LCDC_BASECFG4, LCDC_BASECFG4_DMA);
>> +
>> +	/* Disable all interrupts */
>> +	hlcdc_write(dev, ATMEL_LCDC_LCDIDR, ~0UL);
>> +	hlcdc_write(dev, ATMEL_LCDC_BASEIDR, ~0UL);
>> +	/* Enable BASE LAYER overflow interrupts */
>> +	hlcdc_write(dev, ATMEL_LCDC_BASEIER, LCDC_BASEIER_OVR);
>> +	/* Enable FIFO error interrupt and  the global BASE LAYER interrupt*/
>> +	hlcdc_write(dev, ATMEL_LCDC_LCDIER, LCDC_LCDIER_FIFOERRIE |
>> +					    LCDC_LCDIER_BASEIE);
>> +
>> +
>> +	update_scanout(crtc);
>> +
>> +	atmel_hlcdc_crtc_dpms(crtc, dpms);
>> +
>> +	pm_runtime_put_sync(dev->dev);
>> +	return 0;
>> +}
>> +
>> +static int atmel_hlcdc_crtc_mode_set_base(struct drm_crtc *crtc, int x, int y,
>> +		struct drm_framebuffer *old_fb)
>> +{
>> +	update_scanout(crtc);
>> +	return 0;
>> +}
>> +
>> +#ifdef USE_LUT
>> +static void atmel_hlcdc_crtc_load_lut(struct drm_crtc *crtc)
>> +{
>> +	struct atmel_hlcdc_crtc *atmel_hlcdc_crtc = to_atmel_hlcdc_crtc(crtc);
>> +	struct drm_device *dev = crtc->dev;
>> +	int i;
>> +
>> +	if (!crtc->enabled)
>> +		return;
>> +
>> +	for (i = 0; i < 256; i++)
>> +		hlcdc_write(dev, ATMEL_HLCDC_LUT + (i*4),
>> +			(atmel_hlcdc_crtc->lut_r[i] << 16) |
>> +			(atmel_hlcdc_crtc->lut_g[i] << 8)  |
>> +			(atmel_hlcdc_crtc->lut_b[i] << 0));
>> +}
>> +void atmel_hlcdc_crtc_fb_gamma_set(struct drm_crtc *crtc, u16 red, u16 green,
>> +			      u16 blue, int regno)
>> +{
>> +	struct atmel_hlcdc_crtc *atmel_hlcdc_crtc = to_atmel_hlcdc_crtc(crtc);
>> +
>> +	atmel_hlcdc_crtc->lut_r[regno] = red;
>> +	atmel_hlcdc_crtc->lut_g[regno] = green;
>> +	atmel_hlcdc_crtc->lut_b[regno] = blue;
>> +}
>> +
>> +void atmel_hlcdc_crtc_fb_gamma_get(struct drm_crtc *crtc, u16 *red, u16 *green,
>> +			      u16 *blue, int regno)
>> +{
>> +	struct atmel_hlcdc_crtc *atmel_hlcdc_crtc = to_atmel_hlcdc_crtc(crtc);
>> +
>> +	*red = atmel_hlcdc_crtc->lut_r[regno];
>> +	*green = atmel_hlcdc_crtc->lut_g[regno];
>> +	*blue = atmel_hlcdc_crtc->lut_b[regno];
>> +}
>> +#endif
>> +
>> +static const struct drm_crtc_funcs atmel_hlcdc_crtc_funcs = {
>> +		.destroy        = atmel_hlcdc_crtc_destroy,
>> +		.set_config     = drm_crtc_helper_set_config,
>> +		.page_flip      = atmel_hlcdc_crtc_page_flip,
>> +};
>> +
>> +static const struct drm_crtc_helper_funcs atmel_hlcdc_crtc_helper_funcs = {
>> +		.dpms           = atmel_hlcdc_crtc_dpms,
>> +		.mode_fixup     = atmel_hlcdc_crtc_mode_fixup,
>> +		.prepare        = atmel_hlcdc_crtc_prepare,
>> +		.commit         = atmel_hlcdc_crtc_commit,
>> +		.mode_set       = atmel_hlcdc_crtc_mode_set,
>> +		.mode_set_base  = atmel_hlcdc_crtc_mode_set_base,
>>
>> +/*
>> + * DRM operations:
>> + */
>> +
>> +static int atmel_hlcdc_unload(struct drm_device *dev)
>> +{
>> +	struct atmel_hlcdc_drm_private *priv = dev->dev_private;
>> +	struct atmel_hlcdc_module *mod, *cur;
>> +
>> +	drm_kms_helper_poll_fini(dev);
>> +	drm_mode_config_cleanup(dev);
>> +	drm_vblank_cleanup(dev);
>> +
>> +	pm_runtime_get_sync(dev->dev);
>> +	drm_irq_uninstall(dev);
>> +	pm_runtime_put_sync(dev->dev);
>> +
>> +#ifdef CONFIG_CPU_FREQ
>> +	cpufreq_unregister_notifier(&priv->freq_transition,
>> +			CPUFREQ_TRANSITION_NOTIFIER);
>> +#endif
>> +
>> +	if (priv->clk)
>> +		clk_put(priv->clk);
>> +
>> +	if (priv->mmio)
>> +		iounmap(priv->mmio);
>> +
>> +	flush_workqueue(priv->wq);
>> +	destroy_workqueue(priv->wq);
>> +
>> +	dev->dev_private = NULL;
>> +
>> +	pm_runtime_disable(dev->dev);
>> +
>> +	list_for_each_entry_safe(mod, cur, &module_list, list) {
>> +		DBG("destroying module: %s", mod->name);
>> +		mod->funcs->destroy(mod);
>> +	}
>> +
>> +	kfree(priv);
>> +
>> +	return 0;
>> +}
>> +
>> +static int atmel_hlcdc_load(struct drm_device *dev, unsigned long flags)
>> +{
>> +	struct platform_device *pdev = dev->platformdev;
>> +	struct device_node *node = pdev->dev.of_node;
>> +	struct atmel_hlcdc_drm_private *priv;
>> +	struct atmel_hlcdc_module *mod;
>> +	struct resource *res;
>> +	u32 bpp = 0;
>> +	int ret;
>> +
>> +	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
>> +	if (!priv) {
>> +		dev_err(dev->dev, "failed to allocate private data\n");
>> +		return -ENOMEM;
>> +	}
>> +
>> +	dev->dev_private = priv;
>> +
>> +	priv->wq = alloc_ordered_workqueue("atmel_hlcdc", 0);
>> +
>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	if (!res) {
>> +		dev_err(dev->dev, "failed to get memory resource\n");
>> +		ret = -EINVAL;
>> +		goto fail;
>> +	}
>> +
>> +	priv->mmio = ioremap_nocache(res->start, resource_size(res));
>> +	if (!priv->mmio) {
>> +		dev_err(dev->dev, "failed to ioremap\n");
>> +		ret = -ENOMEM;
>> +		goto fail;
>> +	}
>> +
>> +	priv->clk = clk_get(dev->dev, "lcdc_clk");
> Make use of devm functions whenever possible.
>> +	if (IS_ERR(priv->clk)) {
>> +		dev_err(dev->dev, "failed to get lcd clock\n");
>> +		ret = -ENODEV;
>> +		goto fail;
>> +	}
>> +	clk_prepare_enable(priv->clk);
>> +
>> +	priv->bus_clk = clk_get(dev->dev, "bus_clk");
>> +	if (IS_ERR(priv->bus_clk)) {
>> +		dev_dbg(dev->dev, "no bus clock defined.\n");
>> +		priv->bus_clk = NULL;
>> +	}
>> +	if (priv->bus_clk)
>> +		clk_prepare_enable(priv->bus_clk);
>> +
>> +#ifdef CONFIG_CPU_FREQ
>> +	priv->lcd_fck_rate = clk_get_rate(priv->clk);
>> +	priv->freq_transition.notifier_call = cpufreq_transition;
>> +	ret = cpufreq_register_notifier(&priv->freq_transition,
>> +			CPUFREQ_TRANSITION_NOTIFIER);
>> +	if (ret) {
>> +		dev_err(dev->dev, "failed to register cpufreq notifier\n");
>> +		goto fail;
>> +	}
>> +#endif
>> +
>> +	if (of_property_read_u32(node, "default-lcdcfg5",
>> +				  &priv->default_lcdcfg5))
>> +		priv->default_lcdcfg5 = LCDC_LCDCFG5_MODE_OUTPUT_24BPP;
>> +
>> +	DBG("LCDCFG5 default value 0x%x", priv->default_lcdcfg5);
>> +
>> +	if (of_property_read_u32(node, "guard-time", &priv->guard_time))
>> +		priv->guard_time = 9;
>> +
>> +	DBG("Guard time Value 0x%x", priv->guard_time);
>> +
>> +	if (of_property_read_u32(node, "hlcdc,max-pixelclock",
>> +					&priv->max_pixelclock))
>> +		priv->max_pixelclock = ATMEL_HLCDC_DEFAULT_MAX_PIXELCLOCK;
>> +
>> +	DBG("Maximum Pixel Clock Value %dKHz", priv->max_pixelclock);
>> +
>> +	pm_runtime_enable(dev->dev);
>> +
>> +	ret = modeset_init(dev);
>> +	if (ret < 0) {
>> +		dev_err(dev->dev, "failed to initialize mode setting\n");
>> +		goto fail;
>> +	}
>> +
>> +	ret = drm_vblank_init(dev, 1);
>> +	if (ret < 0) {
>> +		dev_err(dev->dev, "failed to initialize vblank\n");
>> +		goto fail;
>> +	}
>> +
>> +	pm_runtime_get_sync(dev->dev);
>> +	ret = drm_irq_install(dev);
>> +	pm_runtime_put_sync(dev->dev);
>> +	if (ret < 0) {
>> +		dev_err(dev->dev, "failed to install IRQ handler\n");
>> +		goto fail;
>> +	}
>> +
>> +	platform_set_drvdata(pdev, dev);
>> +
>> +	list_for_each_entry(mod, &module_list, list) {
>> +		DBG("%s: preferred_bpp: %d", mod->name, mod->preferred_bpp);
>> +		bpp = mod->preferred_bpp;
>> +		if (bpp > 0)
>> +			break;
>> +	}
>> +
>> +	priv->fbdev = drm_fbdev_cma_init(dev, bpp,
>> +			dev->mode_config.num_crtc,
>> +			dev->mode_config.num_connector);
>> +	drm_kms_helper_poll_init(dev);
>> +
>> +	return 0;
>> +
>> +fail:
>> +	atmel_hlcdc_unload(dev);
>> +	return ret;
>> +}
>> +
>> +static void atmel_hlcdc_preclose(struct drm_device *dev, struct drm_file *file)
>> +{
>> +	struct atmel_hlcdc_drm_private *priv = dev->dev_private;
>> +	atmel_hlcdc_crtc_cancel_page_flip(priv->crtc, file);
>> +}
>> +
>> +static void atmel_hlcdc_lastclose(struct drm_device *dev)
>> +{
>> +	struct atmel_hlcdc_drm_private *priv = dev->dev_private;
>> +	drm_fbdev_cma_restore_mode(priv->fbdev);
>> +}
>> +
> [...]
>> +/*
>> + * Connector:
>> + */
>> +
>> +struct panel_connector {
>> +	struct drm_connector base;
>> +
>> +	struct drm_encoder *encoder;  /* our connected encoder */
>> +	struct panel_module *mod;
>> +};
>> +#define to_panel_connector(x) container_of(x, struct panel_connector, base)
>> +
>> +
>> +static void panel_connector_destroy(struct drm_connector *connector)
>> +{
>> +	struct panel_connector *panel_con = to_panel_connector(connector);
>> +	drm_connector_cleanup(connector);
>> +	kfree(panel_con);
>> +}
>> +
>> +static enum drm_connector_status panel_connector_detect(
>> +		struct drm_connector *connector,
>>
>> +static struct of_device_id panel_of_match[];
>> +
>> +static int panel_probe(struct platform_device *pdev)
>> +{
>> +	struct device_node *node = pdev->dev.of_node;
>> +	struct panel_module *panel_mod;
>> +	struct atmel_hlcdc_module *mod;
>> +	struct pinctrl *pinctrl;
>> +	int ret = -EINVAL;
>> +
>> +	/* bail out early if no DT data: */
>> +	if (!node) {
>> +		dev_err(&pdev->dev, "device-tree data is missing\n");
>> +		return -ENXIO;
>> +	}
>> +	panel_mod = kzalloc(sizeof(*panel_mod), GFP_KERNEL);
>> +	if (!panel_mod)
>> +		return -ENOMEM;
>> +
>> +	mod = &panel_mod->base;
>> +
>> +	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
>> +	if (IS_ERR(pinctrl))
>> +		dev_warn(&pdev->dev, "pins are not configured\n");
>> +
>> +	panel_mod->timings = of_get_display_timings(node);
>> +	if (!panel_mod->timings) {
>> +		dev_err(&pdev->dev, "could not get panel timings\n");
>> +		goto fail;
>> +	}
>> +
>> +	if (of_get_panel_info(&pdev->dev, node, panel_mod) < 0) {
>> +		dev_err(&pdev->dev, "could not get panel info\n");
>> +		goto fail;
>> +	}
>> +
>> +	mod->preferred_bpp = panel_mod->preferred_bpp;
>> +
>> +	panel_mod->backlight = of_find_backlight_by_node(node);
>> +	if (panel_mod->backlight)
>> +		dev_info(&pdev->dev, "found backlight\n");
>> +
>> +
>> +	atmel_hlcdc_module_init(mod, "panel", &panel_module_ops);
>> +
>> +	return 0;
>> +
>> +fail:
>> +	panel_destroy(mod);
>> +	return ret;
>> +}
>> +
>> +static int panel_remove(struct platform_device *pdev)
>> +{
>> +	return 0;
>> +}
>> +
>> +static struct of_device_id panel_of_match[] = {
>> +		{ .compatible = "atmel,hlcdc,panel", },
>> +		{ },
>> +};
>> +
>> +struct platform_driver panel_driver = {
>> +	.probe = panel_probe,
>> +	.remove = panel_remove,
>> +	.driver = {
>> +		.owner = THIS_MODULE,
>> +		.name = "panel",
>> +		.of_match_table = panel_of_match,
>> +	},
>> +};
>> +
>> +int __init atmel_hlcdc_panel_init(void)
>> +{
>> +	return platform_driver_register(&panel_driver);
>> +}
>> +
>> +void __exit atmel_hlcdc_panel_fini(void)
>> +{
>> +	platform_driver_unregister(&panel_driver);
>> +}
> 
> Wouldn't it make more sense to use the drm_panel infrastructure (and the
> simple-panel driver) instead of implementing a new panel layer for the
> HLCDC driver ?
> You'd still have to implement the hlcdc glue to use an LCD panel (to
> convert panel timings to hlcdc timings), but at least you'll reuse the
> common DT bindings.
I actually did this when I did a mockup for the at91sam9261ek and I
think that's definitely the way to go. I just did not include this for
the RFC to keep it small.

> 
> This is all for the moment, but I definitely need to dig more into the
> code for a better review :-).
> 
> Best Regards,
> 
> Boris
> 
>> diff --git a/drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_panel.h b/drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_panel.h
>> new file mode 100644
>> index 0000000..0f66169
>> --- /dev/null
>> +++ b/drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_panel.h
>> @@ -0,0 +1,28 @@
>> +/*
>> + * Copyright (C) 2014 Traphandler
>> + * Copyright (C) 2012 Texas Instruments
>> + *
>> + * Base on the tilcdc panel driver
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU General Public License version 2 as published by
>> + * the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful, but WITHOUT
>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
>> + * more details.
>> + *
>> + * You should have received a copy of the GNU General Public License along with
>> + * this program.  If not, see <http://www.gnu.org/licenses/>.
>> + */
>> +
>> +#ifndef __ATMEL_HLCDC_PANEL_H__
>> +#define __ATMEL_HLCDC_PANEL_H__
>> +
>> +/* sub-module for generic lcd panel output */
>> +
>> +int atmel_hlcdc_panel_init(void);
>> +void atmel_hlcdc_panel_fini(void);
>> +
>> +#endif /* __ATMEL_HLCDC_PANEL_H__ */
> 
