Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab3EFKl7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 06:41:59 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:57505 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787Ab3EFKl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 06:41:58 -0400
Date: Mon, 6 May 2013 12:41:52 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] pwm: Changes for v3.10-rc1
Message-ID: <20130506104152.GA9776@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:EU0R8B3Pwk2Nxaj+t2QgJvHmrDRYwlRVYYKEVAxZBjG
 ntazduXT8rnB6gamvJZ1Sce5KNL5UE/et47eA3XrhiA48XO2dJ
 +mahMUkLl7wwMIWIosH7EMPI0ZejFNawtNF33jLIaQB/IYF3KL
 FvEaa93U+hsy63gjXPn0LewsJaVWzvRwdXZi6q8Cqwp6M8UZOE
 uVvwk4c6dM6E9e8M024nS78FbrWCznwiKifYA3fWfFNNbTE/5v
 x1MRj4RIYFyx7XSQosQPrNMzleTF8uUKdISVJ8d/vnPQWOQzU9
 crrzYIi6Lx6XbHq9GsmkcodN2Se8EFe8Vp0r6wHaLDKIoMymdl
 ENn9CEhUrVtTkCaSqe7GQlB2+esV2ikU2Gninsf068expd4BdO
 c4qOL2fak9n17Gdq/nQi9PXeC0gNWCkr8w=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit 6dbe51c251a327e012439c4772097a13df43c5b8:

  Linux 3.9-rc1 (2013-03-03 15:11:05 -0800)

are available in the git repository at:

  git://gitorious.org/linux-pwm/linux-pwm.git tags/for-3.10-rc1

for you to fetch changes up to affb923df96d6c927f9a3dfb0e6f4be940b185cd:

  pwm: lpc32xx: Don't change PWM_ENABLE bit in lpc32xx_pwm_config (2013-04-23 10:58:47 +0200)

Thanks,
Thierry

----------------------------------------------------------------
pwm: Changes for v3.10-rc1

Nothing very exciting this time around. A couple of bug fixes and a lot
of cleanup across the board. The DaVinci 8xx family of SoCs now use the
same driver as the AM33xx family.

Many thanks to Axel Lin and Jingoo Han who have done a great job fixing
various bugs and inconsistencies.

----------------------------------------------------------------
Axel Lin (17):
      pwm: ab8500: Fix trivial typo in dev_err message
      pwm: tiecap: Staticize non-exported symbols
      pwm: tiehrpwm: Staticize non-exported symbols
      pwm: spear: Fix checking return value of clk_enable() and clk_prepare()
      pwm: ab8500: Add .owner to struct pwm_ops
      pwm: atmel-tcb: Add .owner to struct pwm_ops
      pwm: twl-led: Add .owner to struct pwm_ops
      pwm: twl: Add .owner to struct pwm_ops
      pwm: imx: Remove enabled field from struct imx_chip
      pwm: pxa: Remove clk_enabled field from struct pxa_pwm_chip
      pwm: twl: Return proper error if twl6030_pwm_enable() fails
      pwm: mxs: Remove unused *dev from struct mxs_pwm_chip
      pwm: spear: Remove unused *dev from struct spear_pwm_chip
      pwm: pxa: Remove PWM_ID_BASE macro
      pwm: puv3: Remove unused enabled filed from struct puv3_pwm_chip
      pwm: lpc32xx: Properly set PWM_ENABLE bit in lpc32xx_pwm_[enable|disable]
      pwm: lpc32xx: Don't change PWM_ENABLE bit in lpc32xx_pwm_config

Jingoo Han (6):
      pwm_backlight: remove unnecessary ifdefs
      pwm: ab8500: use devm_kzalloc()
      pwm: samsung: convert s3c_pwm to dev_pm_ops
      pwm: pwm-tiecap: add CONFIG_PM_SLEEP to suspend/resume functions
      pwm: pwm-tipwmss: add CONFIG_PM_SLEEP to suspend/resume functions
      pwm: pwm-tiehrpwm: add CONFIG_PM_SLEEP to suspend/resume functions

Philip Avinash (3):
      pwm: davinci: Add Kconfig support for ECAP & EHRPWM devices
      pwm: pwm-tiecap: Update device-tree binding document
      pwm: pwm-tiehrpwm: Update device-tree binding document

Thierry Reding (1):
      pwm: Constify OF match tables

 .../devicetree/bindings/pwm/pwm-tiecap.txt         | 12 ++++++++--
 .../devicetree/bindings/pwm/pwm-tiehrpwm.txt       | 12 ++++++++--
 drivers/pwm/Kconfig                                |  8 +++----
 drivers/pwm/pwm-ab8500.c                           | 10 ++++----
 drivers/pwm/pwm-atmel-tcb.c                        |  1 +
 drivers/pwm/pwm-imx.c                              |  6 +----
 drivers/pwm/pwm-lpc32xx.c                          | 27 ++++++++++++++++++----
 drivers/pwm/pwm-mxs.c                              |  4 +---
 drivers/pwm/pwm-puv3.c                             |  1 -
 drivers/pwm/pwm-pxa.c                              | 23 ++++--------------
 drivers/pwm/pwm-samsung.c                          | 20 ++++++++--------
 drivers/pwm/pwm-spear.c                            | 11 ++++-----
 drivers/pwm/pwm-tegra.c                            |  2 +-
 drivers/pwm/pwm-tiecap.c                           |  6 +++--
 drivers/pwm/pwm-tiehrpwm.c                         |  6 +++--
 drivers/pwm/pwm-tipwmss.c                          |  2 ++
 drivers/pwm/pwm-tipwmss.h                          |  2 +-
 drivers/pwm/pwm-twl-led.c                          |  4 +++-
 drivers/pwm/pwm-twl.c                              |  6 +++--
 drivers/video/backlight/pwm_bl.c                   |  7 ++----
 20 files changed, 91 insertions(+), 79 deletions(-)

--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRh4jwAAoJEN0jrNd/PrOh1/wP/37jP2nwjXXmJ8fF1Va3j0a0
DgCIVu9q3rRzmqJduIdwOB4EjpbSaggHiIXQczEnsqAKfdpFZ2oZ51bqggWiT5Bp
0HBz7biU3qxcOihQPqUmF3W+QIZSJ/eoJxRsMaA5jRgj6NOZQpOFjypJrL2rRcP3
y9cqsx9hDPSqLEPnVLzJha8eMVC/HLoycSBBR5addKIjeyVsknIoSNOqPLxjn6aG
3k2iaJYycBJO5ihccIX0nREjBoLTzSYpU/K8ZT6w3chORU4eqrmdQUH47ZKz3JCu
lyOnHd3uyB2cd4my66pD9LARyTs/QBOAOG72CqLP7GSJKrFmwIeOznZwI+nRD6Af
vyZoSjSSHEn8eR1Dvn8DbmxMSZQnFF4LqeSHsBPmRfwrOtlfNSieOvNMifa9qJuh
PV6Vbt2tnolzm7pGhe922tfh2lYgsx+72bGbCiCkrlKQkMra5tSIe2rfKmrXcZZO
x8LbpoDJFt4ejbkcPRWjGb4jSEzOOSYhdfZgIDp/OZjTnjqfbJXBuX9FFKf/EyWu
07fUT0EN1JRqSB5DaRHUmqY/j5ujZs3x0IHIdZkR6JZUYKRo20bpHacyjX/z4YuQ
Xjsl90jjmANaUcvK8N5JlXc4sEVkHK0t9gcr9hAEFg7qoV762m+4QFDVvE11mKSw
OsVi9t/HlBSgA+jx0rNq
=n5Me
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
