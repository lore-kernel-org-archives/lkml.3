Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934218AbaGXHEo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 03:04:44 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56352 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbaGXHEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 03:04:43 -0400
Message-ID: <53D0B005.8050400@infradead.org>
Date: Thu, 24 Jul 2014 00:04:37 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: linux-next: build failure after merge of the crypto tree
References: <20140724130801.3dce9bb7@canb.auug.org.au>
In-Reply-To: <20140724130801.3dce9bb7@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2014 08:08 PM, Stephen Rothwell wrote:
> Hi Herbert,
> 
> After merging the crypto tree, today's linux-next build (powerpc
> ppc64_defconfig) produced these messages:
> 
> fs/sysfs/Kconfig:1:error: recursive dependency detected!
> fs/sysfs/Kconfig:1:	symbol SYSFS is selected by AT91_ADC
> drivers/iio/adc/Kconfig:110:	symbol AT91_ADC depends on IIO
> drivers/iio/Kconfig:5:	symbol IIO is selected by RTC_DRV_HID_SENSOR_TIME
> drivers/rtc/Kconfig:1370:	symbol RTC_DRV_HID_SENSOR_TIME depends on USB_HID
> drivers/hid/usbhid/Kconfig:4:	symbol USB_HID depends on USB
> drivers/usb/Kconfig:41:	symbol USB is selected by MOUSE_APPLETOUCH

Don't know if it will help, but we
aren't supposed to use 'select' for subsystems, like USB above.

> drivers/input/mouse/Kconfig:162:	symbol MOUSE_APPLETOUCH depends on INPUT
> drivers/input/Kconfig:8:	symbol INPUT is selected by VT

That one ^^^ is also questionable.

> drivers/tty/Kconfig:12:	symbol VT is selected by FB_STI
> drivers/video/fbdev/Kconfig:652:	symbol FB_STI depends on FB
> drivers/video/fbdev/Kconfig:5:	symbol FB is selected by DRM_KMS_FB_HELPER
> drivers/gpu/drm/Kconfig:39:	symbol DRM_KMS_FB_HELPER is selected by DRM_KMS_CMA_HELPER
> drivers/gpu/drm/Kconfig:74:	symbol DRM_KMS_CMA_HELPER is selected by DRM_TILCDC
> drivers/gpu/drm/tilcdc/Kconfig:1:	symbol DRM_TILCDC depends on OF
> drivers/of/Kconfig:4:	symbol OF is selected by CRYPTO_DEV_CCP_DD
> drivers/crypto/ccp/Kconfig:1:	symbol CRYPTO_DEV_CCP_DD depends on CRYPTO
> crypto/Kconfig:15:	symbol CRYPTO is selected by IP_SCTP

That one ^^^ could be questionable...

> net/sctp/Kconfig:5:	symbol IP_SCTP is selected by DLM
> fs/dlm/Kconfig:1:	symbol DLM depends on SYSFS
> 
> The x86_64 allmodconfig build produced these:
> 
> scripts/kconfig/conf --allmodconfig Kconfig
> drivers/usb/Kconfig:41:error: recursive dependency detected!
> drivers/usb/Kconfig:41:	symbol USB is selected by MOUSE_APPLETOUCH
> drivers/input/mouse/Kconfig:162:	symbol MOUSE_APPLETOUCH depends on INPUT
> drivers/input/Kconfig:8:	symbol INPUT is selected by VT
> drivers/tty/Kconfig:12:	symbol VT is selected by FB_STI
> drivers/video/fbdev/Kconfig:652:	symbol FB_STI depends on FB
> drivers/video/fbdev/Kconfig:5:	symbol FB is selected by DRM_KMS_FB_HELPER
> drivers/gpu/drm/Kconfig:39:	symbol DRM_KMS_FB_HELPER is selected by DRM_KMS_CMA_HELPER
> drivers/gpu/drm/Kconfig:74:	symbol DRM_KMS_CMA_HELPER is selected by DRM_TILCDC
> drivers/gpu/drm/tilcdc/Kconfig:1:	symbol DRM_TILCDC depends on OF
> drivers/of/Kconfig:4:	symbol OF is selected by CRYPTO_DEV_CCP_DD
> drivers/crypto/ccp/Kconfig:1:	symbol CRYPTO_DEV_CCP_DD depends on CRYPTO
> crypto/Kconfig:15:	symbol CRYPTO is selected by IP_SCTP
> net/sctp/Kconfig:5:	symbol IP_SCTP is selected by DLM
> fs/dlm/Kconfig:1:	symbol DLM depends on SYSFS
> fs/sysfs/Kconfig:1:	symbol SYSFS is selected by AT91_ADC
> drivers/iio/adc/Kconfig:110:	symbol AT91_ADC depends on IIO
> drivers/iio/Kconfig:5:	symbol IIO is selected by RTC_DRV_HID_SENSOR_TIME
> drivers/rtc/Kconfig:1370:	symbol RTC_DRV_HID_SENSOR_TIME depends on USB_HID
> drivers/hid/usbhid/Kconfig:4:	symbol USB_HID depends on USB
> 
> And then the arm multi_v7_defconfig build produced these:
> 
> drivers/usb/Kconfig:41:error: recursive dependency detected!
> drivers/usb/Kconfig:41:	symbol USB is selected by MOUSE_APPLETOUCH
> drivers/input/mouse/Kconfig:162:	symbol MOUSE_APPLETOUCH depends on INPUT
> drivers/input/Kconfig:8:	symbol INPUT is selected by VT
> drivers/tty/Kconfig:12:	symbol VT is selected by FB_STI
> drivers/video/fbdev/Kconfig:652:	symbol FB_STI depends on FB
> drivers/video/fbdev/Kconfig:5:	symbol FB is selected by DRM_KMS_FB_HELPER
> drivers/gpu/drm/Kconfig:39:	symbol DRM_KMS_FB_HELPER is selected by DRM_KMS_CMA_HELPER
> drivers/gpu/drm/Kconfig:74:	symbol DRM_KMS_CMA_HELPER is selected by DRM_TILCDC
> drivers/gpu/drm/tilcdc/Kconfig:1:	symbol DRM_TILCDC depends on OF
> drivers/of/Kconfig:4:	symbol OF is selected by CRYPTO_DEV_CCP_DD
> drivers/crypto/ccp/Kconfig:1:	symbol CRYPTO_DEV_CCP_DD depends on CRYPTO
> crypto/Kconfig:15:	symbol CRYPTO is selected by IP_SCTP
> net/sctp/Kconfig:5:	symbol IP_SCTP is selected by DLM
> fs/dlm/Kconfig:1:	symbol DLM depends on SYSFS
> fs/sysfs/Kconfig:1:	symbol SYSFS is selected by AT91_ADC
> drivers/iio/adc/Kconfig:110:	symbol AT91_ADC depends on IIO
> drivers/iio/Kconfig:5:	symbol IIO is selected by RTC_DRV_HID_SENSOR_TIME
> drivers/rtc/Kconfig:1370:	symbol RTC_DRV_HID_SENSOR_TIME depends on USB_HID
> drivers/hid/usbhid/Kconfig:4:	symbol USB_HID depends on USB
> #
> # configuration written to .config
> #
> WITHOUT_CCACHE: 
> WITHOUT_DISTCC: 
> ARCH=arm
> CCVER=4.9.0
> drivers/usb/Kconfig:41:error: recursive dependency detected!
> drivers/usb/Kconfig:41:	symbol USB is selected by MOUSE_APPLETOUCH
> drivers/input/mouse/Kconfig:162:	symbol MOUSE_APPLETOUCH depends on INPUT
> drivers/input/Kconfig:8:	symbol INPUT is selected by VT
> drivers/tty/Kconfig:12:	symbol VT is selected by FB_STI
> drivers/video/fbdev/Kconfig:652:	symbol FB_STI depends on FB
> drivers/video/fbdev/Kconfig:5:	symbol FB is selected by DRM_KMS_FB_HELPER
> drivers/gpu/drm/Kconfig:39:	symbol DRM_KMS_FB_HELPER is selected by DRM_KMS_CMA_HELPER
> drivers/gpu/drm/Kconfig:74:	symbol DRM_KMS_CMA_HELPER is selected by DRM_TILCDC
> drivers/gpu/drm/tilcdc/Kconfig:1:	symbol DRM_TILCDC depends on OF
> drivers/of/Kconfig:4:	symbol OF is selected by CRYPTO_DEV_CCP_DD
> drivers/crypto/ccp/Kconfig:1:	symbol CRYPTO_DEV_CCP_DD depends on CRYPTO
> crypto/Kconfig:15:	symbol CRYPTO is selected by IP_SCTP
> net/sctp/Kconfig:5:	symbol IP_SCTP is selected by DLM
> fs/dlm/Kconfig:1:	symbol DLM depends on SYSFS
> fs/sysfs/Kconfig:1:	symbol SYSFS is selected by AT91_ADC
> drivers/iio/adc/Kconfig:110:	symbol AT91_ADC depends on IIO
> drivers/iio/Kconfig:5:	symbol IIO is selected by RTC_DRV_HID_SENSOR_TIME
> drivers/rtc/Kconfig:1370:	symbol RTC_DRV_HID_SENSOR_TIME depends on USB_HID
> drivers/hid/usbhid/Kconfig:4:	symbol USB_HID depends on USB
> *
> * Restart config...
> *
> *
> * USB HID Boot Protocol drivers
> *
> USB HIDBP Keyboard (simple Boot) support (USB_KBD) [N/m/y/?] (NEW) aborted!
> 
> Console input/output is redirected. Run 'make oldconfig' to update configuration.
> 
> 
> I am not sure exactly what caused all this, but it is probably commit
> 126ae9adc1ec ("crypto: ccp - Base AXI DMA cache settings on device
> tree").
> 
> I have used the version of the crypto tree from next-20140723 for today.
> 


-- 
~Randy
