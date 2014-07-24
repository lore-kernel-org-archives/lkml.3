Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758636AbaGXDIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 23:08:11 -0400
Received: from ozlabs.org ([103.22.144.67]:60742 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758463AbaGXDIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 23:08:09 -0400
Date: Thu, 24 Jul 2014 13:08:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: linux-next: build failure after merge of the crypto tree
Message-ID: <20140724130801.3dce9bb7@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/V5kR1b69Nx6Rr86sSz=DDjw"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/V5kR1b69Nx6Rr86sSz=DDjw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Herbert,

After merging the crypto tree, today's linux-next build (powerpc
ppc64_defconfig) produced these messages:

fs/sysfs/Kconfig:1:error: recursive dependency detected!
fs/sysfs/Kconfig:1:	symbol SYSFS is selected by AT91_ADC
drivers/iio/adc/Kconfig:110:	symbol AT91_ADC depends on IIO
drivers/iio/Kconfig:5:	symbol IIO is selected by RTC_DRV_HID_SENSOR_TIME
drivers/rtc/Kconfig:1370:	symbol RTC_DRV_HID_SENSOR_TIME depends on USB_HID
drivers/hid/usbhid/Kconfig:4:	symbol USB_HID depends on USB
drivers/usb/Kconfig:41:	symbol USB is selected by MOUSE_APPLETOUCH
drivers/input/mouse/Kconfig:162:	symbol MOUSE_APPLETOUCH depends on INPUT
drivers/input/Kconfig:8:	symbol INPUT is selected by VT
drivers/tty/Kconfig:12:	symbol VT is selected by FB_STI
drivers/video/fbdev/Kconfig:652:	symbol FB_STI depends on FB
drivers/video/fbdev/Kconfig:5:	symbol FB is selected by DRM_KMS_FB_HELPER
drivers/gpu/drm/Kconfig:39:	symbol DRM_KMS_FB_HELPER is selected by DRM_KMS=
_CMA_HELPER
drivers/gpu/drm/Kconfig:74:	symbol DRM_KMS_CMA_HELPER is selected by DRM_TI=
LCDC
drivers/gpu/drm/tilcdc/Kconfig:1:	symbol DRM_TILCDC depends on OF
drivers/of/Kconfig:4:	symbol OF is selected by CRYPTO_DEV_CCP_DD
drivers/crypto/ccp/Kconfig:1:	symbol CRYPTO_DEV_CCP_DD depends on CRYPTO
crypto/Kconfig:15:	symbol CRYPTO is selected by IP_SCTP
net/sctp/Kconfig:5:	symbol IP_SCTP is selected by DLM
fs/dlm/Kconfig:1:	symbol DLM depends on SYSFS

The x86_64 allmodconfig build produced these:

scripts/kconfig/conf --allmodconfig Kconfig
drivers/usb/Kconfig:41:error: recursive dependency detected!
drivers/usb/Kconfig:41:	symbol USB is selected by MOUSE_APPLETOUCH
drivers/input/mouse/Kconfig:162:	symbol MOUSE_APPLETOUCH depends on INPUT
drivers/input/Kconfig:8:	symbol INPUT is selected by VT
drivers/tty/Kconfig:12:	symbol VT is selected by FB_STI
drivers/video/fbdev/Kconfig:652:	symbol FB_STI depends on FB
drivers/video/fbdev/Kconfig:5:	symbol FB is selected by DRM_KMS_FB_HELPER
drivers/gpu/drm/Kconfig:39:	symbol DRM_KMS_FB_HELPER is selected by DRM_KMS=
_CMA_HELPER
drivers/gpu/drm/Kconfig:74:	symbol DRM_KMS_CMA_HELPER is selected by DRM_TI=
LCDC
drivers/gpu/drm/tilcdc/Kconfig:1:	symbol DRM_TILCDC depends on OF
drivers/of/Kconfig:4:	symbol OF is selected by CRYPTO_DEV_CCP_DD
drivers/crypto/ccp/Kconfig:1:	symbol CRYPTO_DEV_CCP_DD depends on CRYPTO
crypto/Kconfig:15:	symbol CRYPTO is selected by IP_SCTP
net/sctp/Kconfig:5:	symbol IP_SCTP is selected by DLM
fs/dlm/Kconfig:1:	symbol DLM depends on SYSFS
fs/sysfs/Kconfig:1:	symbol SYSFS is selected by AT91_ADC
drivers/iio/adc/Kconfig:110:	symbol AT91_ADC depends on IIO
drivers/iio/Kconfig:5:	symbol IIO is selected by RTC_DRV_HID_SENSOR_TIME
drivers/rtc/Kconfig:1370:	symbol RTC_DRV_HID_SENSOR_TIME depends on USB_HID
drivers/hid/usbhid/Kconfig:4:	symbol USB_HID depends on USB

And then the arm multi_v7_defconfig build produced these:

drivers/usb/Kconfig:41:error: recursive dependency detected!
drivers/usb/Kconfig:41:	symbol USB is selected by MOUSE_APPLETOUCH
drivers/input/mouse/Kconfig:162:	symbol MOUSE_APPLETOUCH depends on INPUT
drivers/input/Kconfig:8:	symbol INPUT is selected by VT
drivers/tty/Kconfig:12:	symbol VT is selected by FB_STI
drivers/video/fbdev/Kconfig:652:	symbol FB_STI depends on FB
drivers/video/fbdev/Kconfig:5:	symbol FB is selected by DRM_KMS_FB_HELPER
drivers/gpu/drm/Kconfig:39:	symbol DRM_KMS_FB_HELPER is selected by DRM_KMS=
_CMA_HELPER
drivers/gpu/drm/Kconfig:74:	symbol DRM_KMS_CMA_HELPER is selected by DRM_TI=
LCDC
drivers/gpu/drm/tilcdc/Kconfig:1:	symbol DRM_TILCDC depends on OF
drivers/of/Kconfig:4:	symbol OF is selected by CRYPTO_DEV_CCP_DD
drivers/crypto/ccp/Kconfig:1:	symbol CRYPTO_DEV_CCP_DD depends on CRYPTO
crypto/Kconfig:15:	symbol CRYPTO is selected by IP_SCTP
net/sctp/Kconfig:5:	symbol IP_SCTP is selected by DLM
fs/dlm/Kconfig:1:	symbol DLM depends on SYSFS
fs/sysfs/Kconfig:1:	symbol SYSFS is selected by AT91_ADC
drivers/iio/adc/Kconfig:110:	symbol AT91_ADC depends on IIO
drivers/iio/Kconfig:5:	symbol IIO is selected by RTC_DRV_HID_SENSOR_TIME
drivers/rtc/Kconfig:1370:	symbol RTC_DRV_HID_SENSOR_TIME depends on USB_HID
drivers/hid/usbhid/Kconfig:4:	symbol USB_HID depends on USB
#
# configuration written to .config
#
WITHOUT_CCACHE:=20
WITHOUT_DISTCC:=20
ARCH=3Darm
CCVER=3D4.9.0
drivers/usb/Kconfig:41:error: recursive dependency detected!
drivers/usb/Kconfig:41:	symbol USB is selected by MOUSE_APPLETOUCH
drivers/input/mouse/Kconfig:162:	symbol MOUSE_APPLETOUCH depends on INPUT
drivers/input/Kconfig:8:	symbol INPUT is selected by VT
drivers/tty/Kconfig:12:	symbol VT is selected by FB_STI
drivers/video/fbdev/Kconfig:652:	symbol FB_STI depends on FB
drivers/video/fbdev/Kconfig:5:	symbol FB is selected by DRM_KMS_FB_HELPER
drivers/gpu/drm/Kconfig:39:	symbol DRM_KMS_FB_HELPER is selected by DRM_KMS=
_CMA_HELPER
drivers/gpu/drm/Kconfig:74:	symbol DRM_KMS_CMA_HELPER is selected by DRM_TI=
LCDC
drivers/gpu/drm/tilcdc/Kconfig:1:	symbol DRM_TILCDC depends on OF
drivers/of/Kconfig:4:	symbol OF is selected by CRYPTO_DEV_CCP_DD
drivers/crypto/ccp/Kconfig:1:	symbol CRYPTO_DEV_CCP_DD depends on CRYPTO
crypto/Kconfig:15:	symbol CRYPTO is selected by IP_SCTP
net/sctp/Kconfig:5:	symbol IP_SCTP is selected by DLM
fs/dlm/Kconfig:1:	symbol DLM depends on SYSFS
fs/sysfs/Kconfig:1:	symbol SYSFS is selected by AT91_ADC
drivers/iio/adc/Kconfig:110:	symbol AT91_ADC depends on IIO
drivers/iio/Kconfig:5:	symbol IIO is selected by RTC_DRV_HID_SENSOR_TIME
drivers/rtc/Kconfig:1370:	symbol RTC_DRV_HID_SENSOR_TIME depends on USB_HID
drivers/hid/usbhid/Kconfig:4:	symbol USB_HID depends on USB
*
* Restart config...
*
*
* USB HID Boot Protocol drivers
*
USB HIDBP Keyboard (simple Boot) support (USB_KBD) [N/m/y/?] (NEW) aborted!

Console input/output is redirected. Run 'make oldconfig' to update configur=
ation.


I am not sure exactly what caused all this, but it is probably commit
126ae9adc1ec ("crypto: ccp - Base AXI DMA cache settings on device
tree").

I have used the version of the crypto tree from next-20140723 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/V5kR1b69Nx6Rr86sSz=DDjw
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT0HiWAAoJEMDTa8Ir7ZwVZyoP/i9R8m4ekJLTt7gok1DeQWi1
HN7WgEaMWIiUjGHz3zcga6p5hfcRfJyWSFDN0BtIjYCwZCNoINZWad7TtH6fYDJl
FNoROjGptPYdnz8tajsTjlhr1lDSkMsptFqBCvNFwGQWzeyQeP3y8/CHeKu5DppH
QNNpX+Z1R5ilEjf5IVE5zoaJD3WwmoUb+mt1VA5rgcQU1BmhYGBChmV/jvC/lX1+
ZOcxBpTQD/E8LvoZMrgeVVUPl8CAetnpLqKq12Cm5OMktfAzQKlXT/TEcUxT9LQe
kBztqzXkP6gHj9Wo4hLcNZ0V50G/QF19tRtq+zo2ChUufXjO7XgoUOmXTn7Hk7vO
mUr2VnkaMpcCEXkbElBPc0mGiT4RUZzFdLphw2kEZ4z+UMZc8+4wVAiv63DtAK6Y
zGY6mPKiFhHxzE59oJtfCxNU3eWY4oPvz00JPkcZHg6FRWvNJ6AT0VwA7BiTFzTl
HphCMhVwd2le+O1AThyy0F8pfr1vLOKKKQFUO69BtDHLtKMIqZdgIwglqWGbwvfq
6De2NChxascjLcuFubaC8nX+K7NLlbCK32f3veB047Q9yazTCY7kr8+AedxEx1YD
BygUKrYoYcaBwOWpIqGRq611ToLOQCFHd2louAgyMrdyU3WqVMK4ghwtEIpY8trL
b2W7kZjRtfCFH+4YefcZ
=RDfL
-----END PGP SIGNATURE-----

--Sig_/V5kR1b69Nx6Rr86sSz=DDjw--
