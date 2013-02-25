Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345Ab3BYHyw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 02:54:52 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:63316 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567Ab3BYHyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 02:54:51 -0500
Date: Mon, 25 Feb 2013 08:54:46 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] pwm: Changes for v3.9-rc1
Message-ID: <20130225075446.GA29488@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:lCJO7QcIn+UzJyXlcZn8MBGjun82kQJuYKytCL264mc
 Iv2hSsCwa9i5ngGcVeZ0X3cqPf3ajJYdWa1qdaFOF07Vmbcpp7
 wfrwEmPBk6M7FHlpkNZ+kuk1D7IadSqS+fFC/2tEIpUFFRN+rf
 z2qPvRea8w0WECC8wRyfytj9U3IjKBXB20uqSo7Lb/rTrMw4KW
 pH7HvYWE/8ewFbIWCXZt+c2UQL0rMH2XuTyOBjhzPSCR7eT/zj
 Q6iQsOKy+HQsPMQcfPbz41wzkby3b12OYhritX1flSbC1FRwyP
 Wx2fHNRl8otghq7ejomK9uI/6FktnNqB9VM+u8lo8I1JTta6RZ
 Coilnwt1srH/smpDKl+xj7kxUTms+Ba8u/AaKTlqZYHxCBVscz
 GdEHhsywq+hc+W8B+G83peorbyXptyivDmyxg+D/fgjkqGuVIx
 tDB8X
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit d1c3ed669a2d452cacfb48c2d171a1f364dae2ed:

  Linux 3.8-rc2 (2013-01-02 18:13:21 -0800)

are available in the git repository at:

  git://gitorious.org/linux-pwm/linux-pwm.git tags/for-3.9-rc1

for you to fetch changes up to 30f786170352b8264bc7b61c2482713e54accec8:

  pwm: twl: Use to_twl() instead of container_of() (2013-02-17 11:27:07 +0100)

Thanks,
Thierry

----------------------------------------------------------------
pwm: Changes for v3.9-rc1

A new driver has been added to support the PWM mode of the timer counter
blocks found on Atmel AT91 SoCs. The VT8500 driver now supports changing
the PWM signal polarity and the TI drivers (EHRPWM and ECAP) gained
suspend and resume functionality.

User drivers can now query the core for whether access to a PWM device
will sleep (if the PWM chip is on a slow bus such as I2C or SPI).

The pwm-backlight driver now handles the backlight BL_CORE_FBBLANK state
in addition to the FB layer's blanking states.

To round things off, a few fixes and cleanups are also included.

----------------------------------------------------------------
Alexandre Courbot (1):
      pwm-backlight: handle BL_CORE_FBBLANK state

Boris BREZILLON (1):
      pwm: atmel: add Timer Counter Block PWM driver

Florian Vaussard (2):
      pwm: Add pwm_can_sleep() as exported API to users
      pwm: Add can_sleep property to drivers

Johannes Thumshirn (1):
      pwm: twl: Use to_twl() instead of container_of()

Peter Ujfalusi (1):
      pwm_backlight: Validate dft_brightness in main probe function

Philip Avinash (2):
      pwm: pwm-tiehrpwm: Low power sleep support
      pwm: pwm-tiecap: Low power sleep support

Philip, Avinash (1):
      pwm: pwm-tiehrpwm: Update the clock handling of pwm-tiehrpwm driver

Stephen Warren (1):
      pwm: tegra: assume CONFIG_OF

Thierry Reding (2):
      pwm: Make Kconfig entries more consistent
      pwm: Export pwm_{set,get}_chip_data()

Tony Prisk (2):
      pwm: vt8500: Register write busy test performed incorrectly
      pwm: vt8500: Add polarity support

 .../devicetree/bindings/pwm/atmel-tcb-pwm.txt      |  18 +
 .../devicetree/bindings/pwm/vt8500-pwm.txt         |   9 +-
 drivers/pwm/Kconfig                                |  18 +-
 drivers/pwm/Makefile                               |   1 +
 drivers/pwm/core.c                                 |  14 +
 drivers/pwm/pwm-atmel-tcb.c                        | 445 +++++++++++++++++++++
 drivers/pwm/pwm-tegra.c                            |   4 +-
 drivers/pwm/pwm-tiecap.c                           |  53 +++
 drivers/pwm/pwm-tiehrpwm.c                         |  93 ++++-
 drivers/pwm/pwm-twl-led.c                          |   1 +
 drivers/pwm/pwm-twl.c                              |  10 +-
 drivers/pwm/pwm-vt8500.c                           |  87 +++-
 drivers/video/backlight/pwm_bl.c                   |  20 +-
 include/linux/pwm.h                                |  10 +
 14 files changed, 741 insertions(+), 42 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pwm/atmel-tcb-pwm.txt
 create mode 100644 drivers/pwm/pwm-atmel-tcb.c

--M9NhX3UHpAaciwkO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRKxjGAAoJEN0jrNd/PrOhh1kP/2wrstpaEKWb8Ug/3Tbmmp6j
T0cUvafhZcbyKUR5nYQymaLSr/0k291NSqkePgKzfnzwWN5uqb7CrXlVDhLf/amD
bpZtWzD8EcDaYTpOTFYCasw3xlBzJAP6DefCrfCGLT40svfA24BgomVauGAIfq5A
9JuLvjDM0Jo1PQJAaP4MqVohOmbSG9dQFwe9D36l/QWsxtl7xft/r41I7BAMk+6e
M9mE6T6FdZehjPYw+T11Ph+yzQGJ+e2huU2kMi+X2y9i35lioT3nWpA3aEmdBlaK
A1qpC99xThY7VRBCp1GOLSRZBJrtKq7sLpq9CvgasNgphJf3cFwd7d5YkgUtpdbd
kuUjd/QClg6unPuMwdBblnoRNMPVqekQyhshpEv7OCjtLFpWzlnsSmB73DTp5nkT
AfMLp2gYGcmFJeqerKFiwX59Q2N6w5HjbG8y9D7LuKVhA92yCQRxbnFxcLvUGFHA
aEmGH5vZF6RiTtS6uTaoSVW+QaCzUpSnVJF2uSeU3c5VdQWmICV4kQV/hmfiNHfT
wzd5oDe//REbtZWij3ndGmxTCqclGg5bQk/7YB3gAqU17o144tW3SKJ+CdMllWwv
hcq45u0CCHhIP0g0ofdK3xUeUAOej670cvuAoddBq0/BWUbW4UmZ5WJOtxnjxpd2
bW9OO5S4gt4dox2xLYdU
=C73b
-----END PGP SIGNATURE-----

--M9NhX3UHpAaciwkO--
