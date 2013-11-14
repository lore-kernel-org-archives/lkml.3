Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845Ab3KNQVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:21:48 -0500
Received: from mailout3.w2.samsung.com ([211.189.100.13]:54537 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158Ab3KNQQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:16:05 -0500
X-AuditID: cbfec373-b7f356d000006018-da-5284f744491e
Date: Thu, 14 Nov 2013 14:15:59 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.13-rc1] media build fixes
Message-id: <20131114141559.1e77492a@samsung.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjluLIzCtJLcpLzFFi42I5/e9wkK7L95YggyOrxSzmrF/DZnF51xw2
	i54NW1ktHvW9ZXdg8Tgx4zeLx+dNcgFMUVw2Kak5mWWpRfp2CVwZn55NYS745lXR3/GRtYGx
	wbOLkZNDQsBE4uDmP8wQtpjEhXvr2boYuTiEBJYwShw78pAVJCEk0M0kcfW/EIjNIqAqcWMp
	SBEnB5uAkcSrxhawGhEg+/OLK6wgzcwCixklPj5fzw6SEBYwlph19xfQBg4OXgFDiZfPq0FM
	CQEnid0HpEAqeAUEJX5MvscCYjMLaEls3tbECmErSkxb1MA4gZFvFpKyWUjKZiEpW8DIvIpR
	tLQ4uaA4KT3XSK84Mbe4NC9dLzk/dxMjJOyKdzC+2GB1iFGAg1GJh7dgZ3OQEGtiWXFl7iFG
	CQ5mJRHe//dbgoR4UxIrq1KL8uOLSnNSiw8xMnFwSjUw+vjcDt84ZfeMdW+t5tzqev8gsewY
	Z4BTI2PARo/nr07s/aGz/qfP9103Xvm++7wvXHXZqeubGHVMOKfcuBDwRsKxKufKRdkUnp4/
	nE5rRGLm+D/v3930+lTs14dPPr19V2q/33abzJ0lmR9eClXqtO59Y7Z/rsj8oz7Mc/8ujsh+
	9SNYMalnVZcSS3FGoqEWc1FxIgDCShfdGQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rAEGLqRm008328

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media topic/kbuild-fixes-for-next

For a series of patches that fix compilation on non-x86 archs.

While most of them are just build fixes, there are some fixes for
real bugs, as there are a number of drivers using dynamic stack
allocation. A few of those might be considered a security risk, if
the i2c-dev module is loaded, as someone could be sending very long
I2C data that could potentially overflow the Kernel stack. Ok, as
using /dev/i2c-* devnodes usually requires root on usual distros, 
and exploiting it would require a DVB board or USB stick, the risk 
is not high.

PS.: this patch series should be applied after my previous pull request
"[GIT PULL for v3.13-rc1] media updates" that I sent today.

Thanks,
Mauro


Latest commit at the branch: 
3cdcf7369cdb3406c61090e453b78cb8d4882ef8 [media] platform drivers: Fix build on frv arch
The following changes since commit 80f93c7b0f4599ffbdac8d964ecd1162b8b618b9:

  [media] media: st-rc: Add ST remote control driver (2013-10-31 08:20:08 -0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media topic/kbuild-fixes-for-next

for you to fetch changes up to 3cdcf7369cdb3406c61090e453b78cb8d4882ef8:

  [media] platform drivers: Fix build on frv arch (2013-11-08 09:45:47 -0200)

- ----------------------------------------------------------------
Mauro Carvalho Chehab (27):
      [media] tda9887: remove an warning when compiling for alpha
      [media] radio-shark: remove a warning when CONFIG_PM is not defined
      [media] zoran: don't build it on alpha
      [media] cx18: struct i2c_client is too big for stack
      [media] tef6862: fix warning on avr32 arch
      [media] radio-si470x-i2c: fix a warning on ia64
      [media] rc: Fir warnings on m68k arch
      [media] uvc/lirc_serial: Fix some warnings on parisc arch
      [media] s5h1420: Don't use dynamic static allocation
      [media] dvb-frontends: Don't use dynamic static allocation
      [media] dvb-frontends: Don't use dynamic static allocation
      [media] stb0899_drv: Don't use dynamic static allocation
      [media] stv0367: Don't use dynamic static allocation
      [media] stv090x: Don't use dynamic static allocation
      [media] av7110_hw: Don't use dynamic static allocation
      [media] tuners: Don't use dynamic static allocation
      [media] tuner-xc2028: Don't use dynamic static allocation
      [media] cimax2: Don't use dynamic static allocation
      [media] v4l2-async: Don't use dynamic static allocation
      [media] cxusb: Don't use dynamic static allocation
      [media] dibusb-common: Don't use dynamic static allocation
      [media] dw2102: Don't use dynamic static allocation
      [media] af9015: Don't use dynamic static allocation
      [media] af9035: Don't use dynamic static allocation
      [media] mxl111sf: Don't use dynamic static allocation
      [media] lirc_zilog: Don't use dynamic static allocation
      [media] platform drivers: Fix build on frv arch

Sean Young (1):
      [media] iguanair: simplify calculation of carrier delay cycles

 drivers/media/dvb-frontends/af9013.c          | 14 ++++-
 drivers/media/dvb-frontends/af9033.c          | 23 ++++++-
 drivers/media/dvb-frontends/bcm3510.c         | 15 ++++-
 drivers/media/dvb-frontends/cxd2820r_core.c   | 21 ++++++-
 drivers/media/dvb-frontends/itd1000.c         | 13 +++-
 drivers/media/dvb-frontends/mt312.c           | 10 ++-
 drivers/media/dvb-frontends/nxt200x.c         | 11 +++-
 drivers/media/dvb-frontends/rtl2830.c         | 14 ++++-
 drivers/media/dvb-frontends/rtl2832.c         | 14 ++++-
 drivers/media/dvb-frontends/s5h1420.c         | 11 +++-
 drivers/media/dvb-frontends/stb0899_drv.c     | 12 +++-
 drivers/media/dvb-frontends/stb6100.c         | 11 +++-
 drivers/media/dvb-frontends/stv0367.c         | 13 +++-
 drivers/media/dvb-frontends/stv090x.c         | 12 +++-
 drivers/media/dvb-frontends/stv6110.c         | 12 +++-
 drivers/media/dvb-frontends/stv6110x.c        | 13 +++-
 drivers/media/dvb-frontends/tda10071.c        | 25 ++++++--
 drivers/media/dvb-frontends/tda18271c2dd.c    | 14 ++++-
 drivers/media/dvb-frontends/zl10039.c         | 12 +++-
 drivers/media/pci/cx18/cx18-driver.c          | 20 +++---
 drivers/media/pci/cx23885/cimax2.c            | 13 +++-
 drivers/media/pci/ttpci/av7110_hw.c           | 19 +++++-
 drivers/media/pci/zoran/Kconfig               |  1 +
 drivers/media/platform/soc_camera/rcar_vin.c  |  1 +
 drivers/media/radio/radio-shark.c             |  2 +
 drivers/media/radio/radio-shark2.c            |  2 +
 drivers/media/radio/si470x/radio-si470x-i2c.c |  4 +-
 drivers/media/radio/tef6862.c                 | 20 +++---
 drivers/media/rc/fintek-cir.h                 |  4 +-
 drivers/media/rc/iguanair.c                   | 22 ++-----
 drivers/media/rc/nuvoton-cir.h                |  4 +-
 drivers/media/tuners/e4000.c                  | 25 ++++++--
 drivers/media/tuners/fc2580.c                 | 25 ++++++--
 drivers/media/tuners/tda18212.c               | 25 ++++++--
 drivers/media/tuners/tda18218.c               | 23 ++++++-
 drivers/media/tuners/tda9887.c                |  4 +-
 drivers/media/tuners/tuner-xc2028.c           |  8 ++-
 drivers/media/usb/dvb-usb-v2/af9015.c         |  3 +-
 drivers/media/usb/dvb-usb-v2/af9035.c         | 29 ++++++++-
 drivers/media/usb/dvb-usb-v2/mxl111sf.c       | 10 ++-
 drivers/media/usb/dvb-usb/cxusb.c             | 41 ++++++++++--
 drivers/media/usb/dvb-usb/dibusb-common.c     | 10 ++-
 drivers/media/usb/dvb-usb/dw2102.c            | 90 ++++++++++++++++++++++++---
 drivers/media/usb/uvc/uvc_video.c             |  3 +-
 drivers/media/v4l2-core/v4l2-async.c          | 30 ++++++++-
 drivers/staging/media/lirc/lirc_serial.c      |  9 ++-
 drivers/staging/media/lirc/lirc_zilog.c       | 12 +++-
 47 files changed, 610 insertions(+), 119 deletions(-)



- -- 

Cheers,
Mauro
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJShPc/AAoJEAhfPr2O5OEVIMkQAIO2F2RDbwpIlGHUKRQMLrEb
CuN6NjBKECmRe4T8XYb3lBfbJrbCbawiITzp3l5mIEbzYeYpZ1V6oMVqgiBVlvDs
r1Eoc9Dnzy/JqddYz1IefqUc5vC6Veck0+PSixawOhu4Q/wyLcog3Uo2A670x28w
2Wgs3an2XNlNDHuKVNUMx+dOusIls/JotwC+0UsL1HnVg/hr3/PBl2oDxKS3nLVi
TbR4pH2cQmHeGfWAUhI8GRdDJdiJcwPcTZXAGQy5KNjODRlzKPfnoId8IK+YsU+Y
qiK9ypjr/U5A6KdOW2FHOXgBxLNushixf1LXg3siHb6JIrqfm4sqISethFf/0swI
I8ZUwAe2v3wsDYWlu0UGkS0tqQ8OfxwQTh9MfWxV/SRAVFuY7nJ4eaMVaSy47caG
CPe3zTBZRG8Jk+EvxggXSR2NrzR01KLDV7dpHFGlOgbbug/o0LqWe4EJDNbfoB/1
K1NhvRP5ahssuIM0IWezbQqbquGbDbY/vrkV1ueCtKY8+Zg3ZIGRQjZvX5Z+AVBW
xrv6CyTBS9kWVlCz3ZgskcIBlNSL9+XBQcIJUIsbupKkOiYnXpeaZxdRkU6IQZ7a
WqfY1h0qWN6tMtLIwDlYPv2v3ykp6HdTeaK7xiRX3R8l1xAGVSbvIlcaiOBOO1Ws
XymqqMsiS+XWREt50H45
=sV/l
-----END PGP SIGNATURE-----
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
