Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763377Ab3DDFSG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 01:18:06 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:63035 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763351Ab3DDFSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 01:18:04 -0400
Message-ID: <515D0D29.8030203@prisktech.co.nz>
Date: Thu, 04 Apr 2013 18:18:33 +1300
From: Tony Prisk <linux@prisktech.co.nz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: arm@kernel.org, "Bergmann, Arnd" <arnd@arndb.de>,
        "Johansson, Olof" <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        "List, VT8500" <vt8500-wm8505-linux-kernel@googlegroups.com>
Subject: [GIT PULL] arm: vt8500: Add support for pinctrl/gpio module
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 8bb9660418e05bb1845ac1a2428444d78e322cc7:

   Linux 3.9-rc4 (2013-03-23 16:52:44 -0700)

are available in the git repository at:

   git://server.prisktech.co.nz/git/linuxwmt.git tags/vt8500/pinctrl

for you to fetch changes up to ce63d6d4bb9f601de32d4b99f925a65182521873:

   pinctrl: bcm2835: make use of of_property_read_u32_index() 
(2013-04-04 18:05:26 +1300)

----------------------------------------------------------------
arm: vt8500: Add pinctrl driver for arch-vt8500

This series adds support for the pinctrl/gpio module on all arch-vt8500
supported SoCs. It also drops the existing GPIO only driver and binding.

As part of the review process, some tidy up is also done to
drivers/of/base.c to remove some code that is being constantly duplicated.

Also, a patch for the bcm2835 pinctrl driver is included to take advantage
of the new of/base.c code from Stephen W.

----------------------------------------------------------------
Stephen Warren (1):
       pinctrl: bcm2835: make use of of_property_read_u32_index()

Tony Prisk (7):
       of: Add support for reading a u32 from a multi-value property.
       of: Remove duplicated code for validating property and value
       arm: vt8500: Increase available GPIOs on arch-vt8500
       pinctrl: gpio: vt8500: Add pincontrol driver for arch-vt8500
       arm: dts: vt8500: Update Wondermedia SoC dtsi files for pinctrl 
driver
       arm: vt8500: Remove gpio devicetree nodes
       gpio: vt8500: Remove arch-vt8500 gpio driver

  .../devicetree/bindings/gpio/gpio-vt8500.txt       |   24 -
  .../devicetree/bindings/pinctrl/pinctrl-vt8500.txt |   57 ++
  arch/arm/Kconfig                                   |    3 +-
  arch/arm/boot/dts/vt8500.dtsi                      |   10 +-
  arch/arm/boot/dts/wm8505.dtsi                      |   10 +-
  arch/arm/boot/dts/wm8650.dtsi                      |   10 +-
  arch/arm/boot/dts/wm8850.dtsi                      |   10 +-
  arch/arm/mach-vt8500/Kconfig                       |    1 +
  drivers/gpio/Kconfig                               |    6 -
  drivers/gpio/Makefile                              |    1 -
  drivers/gpio/gpio-vt8500.c                         |  355 -----------
  drivers/of/base.c                                  |  111 ++--
  drivers/pinctrl/Kconfig                            |    1 +
  drivers/pinctrl/Makefile                           |    1 +
  drivers/pinctrl/pinctrl-bcm2835.c                  |   19 +-
  drivers/pinctrl/vt8500/Kconfig                     |   52 ++
  drivers/pinctrl/vt8500/Makefile                    |    8 +
  drivers/pinctrl/vt8500/pinctrl-vt8500.c            |  501 ++++++++++++++++
  drivers/pinctrl/vt8500/pinctrl-wm8505.c            |  532 ++++++++++++++++
  drivers/pinctrl/vt8500/pinctrl-wm8650.c            |  370 ++++++++++++
  drivers/pinctrl/vt8500/pinctrl-wm8750.c            |  409 +++++++++++++
  drivers/pinctrl/vt8500/pinctrl-wm8850.c            |  388 ++++++++++++
  drivers/pinctrl/vt8500/pinctrl-wmt.c               |  632 
++++++++++++++++++++
  drivers/pinctrl/vt8500/pinctrl-wmt.h               |   79 +++
  include/linux/of.h                                 |    9 +
  25 files changed, 3153 insertions(+), 446 deletions(-)
  delete mode 100644 Documentation/devicetree/bindings/gpio/gpio-vt8500.txt
  create mode 100644 
Documentation/devicetree/bindings/pinctrl/pinctrl-vt8500.txt
  delete mode 100644 drivers/gpio/gpio-vt8500.c
  create mode 100644 drivers/pinctrl/vt8500/Kconfig
  create mode 100644 drivers/pinctrl/vt8500/Makefile
  create mode 100644 drivers/pinctrl/vt8500/pinctrl-vt8500.c
  create mode 100644 drivers/pinctrl/vt8500/pinctrl-wm8505.c
  create mode 100644 drivers/pinctrl/vt8500/pinctrl-wm8650.c
  create mode 100644 drivers/pinctrl/vt8500/pinctrl-wm8750.c
  create mode 100644 drivers/pinctrl/vt8500/pinctrl-wm8850.c
  create mode 100644 drivers/pinctrl/vt8500/pinctrl-wmt.c
  create mode 100644 drivers/pinctrl/vt8500/pinctrl-wmt.h
