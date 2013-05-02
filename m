Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583Ab3EBMXl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 08:23:41 -0400
Received: from sauhun.de ([89.238.76.85]:54372 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758380Ab3EBMXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 08:23:39 -0400
Date: Thu, 2 May 2013 14:23:02 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] i2c for 3.10
Message-ID: <20130502122302.GA16610@the-dreams.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the i2c changes for 3.10. Highlights:

* an arbitration driver. While the driver is quite simple, it caused
  discussion if we need additional arbitration on top of the one
  specified in the I2C standard. Conclusion is that I accept a few
  generic mechanisms, but not very specific ones.

* the core lost the detach_adapter() call. It has no users anymore
  and was in the way for other cleanups. attach_adapter() is sadly
  still there since there are users waiting to be converted.

* the core gained a bus recovery infrastructure. I2C defines a way
  to recover if the data line is stalled. This mechanism is now in the
  core and drivers can now pass some data to make use of it.

* bigger driver cleanups for designware, s3c2410

* removing superfluous refcounting from drivers

* removing Ben Dooks as second maintainer due to inactivity. Thanks
  for all your work so far, Ben!

* bugfixes, feature additions, devicetree fixups, simplifications...

Thanks,

   Wolfram


The following changes since commit 8bb9660418e05bb1845ac1a2428444d78e322cc7:

  Linux 3.9-rc4 (2013-03-23 16:52:44 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git i2c/for-next

for you to fetch changes up to c39e8e4354ce4daf23336de5daa28a3b01f00aa6:

  i2c: xiic: must always write 16-bit words to TX_FIFO (2013-04-23 20:18:34 +0200)

----------------------------------------------------------------
Andy Shevchenko (3):
      i2c-designware: move to managed functions (devm_*)
      i2c-designware-pci: use dev_err() instead of printk()
      i2c-designware-pci: use managed functions pcim_* and devm_*

Doug Anderson (3):
      i2c: core: Pick i2c bus number from dt alias if present
      i2c: pxa: Use i2c-core to get bus number now
      i2c: mux: Add i2c-arb-gpio-challenge 'mux' driver

Heiko Stübner (2):
      i2c: s3c2410: move mach/regs-iic.h into i2c-s3c2410 device driver
      i2c: s3c2410: fixup the styling of the newly moved register definitions

Jaemin Yoo (1):
      i2c: s3c2410: Add SMBus emulation for block read

Jean Delvare (2):
      i2c: gpio: Add support for deferred probing
      i2c: mux: gpio: Check gpio_direction_output return value

Lars-Peter Clausen (6):
      i2c: Remove detach_adapter
      i2c: i2c_del_adapter: Don't treat removing a non-registered adapter as error
      i2c: Ignore return value of i2c_del_adapter()
      i2c: Make return type of i2c_del_adapter() void
      i2c: Ignore the return value of i2c_del_mux_adapter()
      i2c: Make the return type of i2c_del_mux_adapter() void

Lucas Stach (2):
      i2c: mxs: remove races in PIO code
      i2c: mxs: do error checking and handling in PIO mode

Ludovic Desroches (1):
      i2c: at91: convert to dma_request_slave_channel_compat()

Mika Westerberg (4):
      i2c-designware: use dynamic adapter numbering on Lynxpoint
      i2c-designware: enable/disable the controller properly
      i2c-designware: use usleep_range() in the busy-loop
      i2c-designware: switch to use runtime PM autosuspend

Sachin Kamat (1):
      i2c: at91: Use of_match_ptr() macro

Stephen Warren (1):
      i2c: tegra: assume CONFIG_OF, remove platform data

Steven A. Falco (1):
      i2c: xiic: must always write 16-bit words to TX_FIFO

Viresh Kumar (1):
      i2c: Add bus recovery infrastructure

Vishwanathrao Badarkhe, Manish (1):
      i2c: davinci: update to devm_* API

Wolfram Sang (6):
      i2c: ismt: remove duplicate const
      i2c: davinci: rename recover bus functions
      MAINTAINERS: Ben Dooks is inactive regarding I2C
      i2c: davinci: drop superfluous {get|put}_device
      i2c: designware-plat: drop superfluous {get|put}_device
      i2c: designware-pci: drop superfluous {get|put}_device

Yijing Wang (1):
      i2c: remove CONFIG_HOTPLUG ifdefs

송은봉 (2):
      i2c: octeon: Fix i2c fail problem when a process is terminated by a signal
      i2c: octeon: use HZ in timeout value

 .../bindings/i2c/i2c-arb-gpio-challenge.txt        |   80 +++++++
 MAINTAINERS                                        |    1 -
 arch/arm/mach-s3c24xx/mach-rx1950.c                |    1 -
 arch/arm/mach-tegra/board-dt-tegra20.c             |    2 -
 arch/arm/plat-samsung/devs.c                       |    1 -
 arch/arm/plat-samsung/include/plat/regs-iic.h      |   56 -----
 drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c         |    3 +-
 drivers/i2c/busses/i2c-amd756-s4882.c              |    6 +-
 drivers/i2c/busses/i2c-at91.c                      |   58 +++--
 drivers/i2c/busses/i2c-cbus-gpio.c                 |    4 +-
 drivers/i2c/busses/i2c-davinci.c                   |   77 ++----
 drivers/i2c/busses/i2c-designware-core.c           |   39 ++-
 drivers/i2c/busses/i2c-designware-pcidrv.c         |   73 ++----
 drivers/i2c/busses/i2c-designware-platdrv.c        |   83 ++-----
 drivers/i2c/busses/i2c-gpio.c                      |   75 ++++--
 drivers/i2c/busses/i2c-intel-mid.c                 |    3 +-
 drivers/i2c/busses/i2c-ismt.c                      |    2 +-
 drivers/i2c/busses/i2c-mv64xxx.c                   |    5 +-
 drivers/i2c/busses/i2c-mxs.c                       |  104 ++++++--
 drivers/i2c/busses/i2c-nforce2-s4985.c             |    6 +-
 drivers/i2c/busses/i2c-octeon.c                    |   10 +-
 drivers/i2c/busses/i2c-powermac.c                  |   10 +-
 drivers/i2c/busses/i2c-puv3.c                      |   10 +-
 drivers/i2c/busses/i2c-pxa.c                       |   20 +-
 drivers/i2c/busses/i2c-s3c2410.c                   |   48 +++-
 drivers/i2c/busses/i2c-tegra.c                     |   26 +-
 drivers/i2c/busses/i2c-viperboard.c                |    5 +-
 drivers/i2c/busses/i2c-xiic.c                      |    6 +-
 drivers/i2c/i2c-core.c                             |  246 +++++++++++++++----
 drivers/i2c/i2c-mux.c                              |    9 +-
 drivers/i2c/muxes/Kconfig                          |   12 +
 drivers/i2c/muxes/Makefile                         |    2 +
 drivers/i2c/muxes/i2c-arb-gpio-challenge.c         |  251 ++++++++++++++++++++
 drivers/i2c/muxes/i2c-mux-gpio.c                   |   17 +-
 drivers/i2c/muxes/i2c-mux-pca954x.c                |    6 +-
 drivers/media/pci/bt8xx/bttv-input.c               |    6 +-
 drivers/media/pci/mantis/mantis_i2c.c              |    4 +-
 drivers/net/ethernet/sfc/falcon.c                  |    6 +-
 drivers/staging/media/go7007/go7007-driver.c       |    7 +-
 include/linux/i2c-mux.h                            |    2 +-
 include/linux/i2c-tegra.h                          |   25 --
 include/linux/i2c.h                                |   50 +++-
 42 files changed, 960 insertions(+), 497 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-arb-gpio-challenge.txt
 delete mode 100644 arch/arm/plat-samsung/include/plat/regs-iic.h
 create mode 100644 drivers/i2c/muxes/i2c-arb-gpio-challenge.c
 delete mode 100644 include/linux/i2c-tegra.h
