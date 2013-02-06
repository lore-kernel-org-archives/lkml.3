Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757729Ab3BFQYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 11:24:17 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:60301 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757700Ab3BFQYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 11:24:14 -0500
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: arnd@arndb.de, axboe@kernel.dk, cbou@mail.ru, davem@davemloft.net,
        dtor@mail.ru, dwmw2@infradead.org, grant.likely@secretlab.ca,
        gregkh@linuxfoundation.org, jkosina@suse.cz, jslaby@suse.cz,
        khali@linux-fr.org, mchehab@redhat.com, perex@perex.cz,
        sameo@linux.intel.com, tiwai@suse.de, w.sang@pengutronix.de
Cc: linux-kernel@vger.kernel.org, sebott@linux.vnet.ibm.com,
        gerald.schaefer@de.ibm.com, schwidefsky@de.ibm.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 00/15] Add various missing GENERIC_HARDIRQS dependencies
Date: Wed,  6 Feb 2013 17:23:48 +0100
Message-Id: <1360167843-3587-1-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
x-cbid: 13020616-8372-0000-0000-00000518F7B8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

this patch set just adds various missing GENERIC_HARDIRQS to a couple of
Kconfig files in order to make an s390 allmodconfig/alldefconfig compile
again.
This is necessary since during the last merge window s390 got CONFIG_PCI
and with that also CONFIG_HAS_DMA and CONFIG_HAS_IOMEM. These new config
options enable lots and lots of new drivers for s390, which however does
not support GENERIC_HARDIRQS.
Therefore a couple of drivers do not compile. To fix this, just add the
missing dependency (instead of sprinkling a !S390 dependency across the
whole tree).

The patches below are all against linux-next as of today.

If the you as the maintainers would take the patches that would be great.
Or please let me know if any patch should go in via the s390 tree.

Thanks!

Heiko Carstens (15):
  drivers/input: add couple of missing GENERIC_HARDIRQS dependencies
  drivers/i2c: remove !S390 dependency, add missing GENERIC_HARDIRQS dependencies
  drivers/mfd: add missing GENERIC_HARDIRQS dependecies
  drivers/block/mtip32xx: add missing GENERIC_HARDIRQS dependency
  drivers/dma/dw_dmac: add missing GENERIC_HARDIRQS dependency
  drivers/gpio: add missing GENERIC_HARDIRQ dependency
  drivers/hid: add missing GENERIC_HARDIRQ dependency
  drivers/misc/cb710: add missing GENERIC_HARDIRQS dependency
  drivers/media: add missing GENERIC_HARDIRQS dependencies
  drivers/net,AT91RM9200: add missing GENERIC_HARDIRQS dependency
  drivers/spi: add missing GENERIC_HARDIRQS dependencies
  sound: add missing HAS_IOPORT and GENERIC_HARDIRQS dependencies
  drivers/usb: add missing GENERIC_HARDIRQS dependencies
  drivers/power,goldfisch battery: add missing GENERIC_HARDIRQS dependency
  drivers/serial: add GENERIC_HARDIRQS dependency

 drivers/block/mtip32xx/Kconfig       |    2 +-
 drivers/dma/Kconfig                  |    1 +
 drivers/gpio/Kconfig                 |    4 +-
 drivers/hid/Kconfig                  |    2 +-
 drivers/i2c/Kconfig                  |    2 +-
 drivers/i2c/busses/Kconfig           |    6 ++-
 drivers/input/Kconfig                |    2 +-
 drivers/input/keyboard/Kconfig       |    4 +-
 drivers/input/serio/Kconfig          |    1 +
 drivers/input/touchscreen/Kconfig    |    2 +-
 drivers/media/platform/Kconfig       |    2 +-
 drivers/media/radio/Kconfig          |    2 +-
 drivers/mfd/Kconfig                  |   72 ++++++++++++++++++----------------
 drivers/misc/cb710/Kconfig           |    2 +-
 drivers/mmc/host/Kconfig             |    2 +-
 drivers/net/ethernet/cadence/Kconfig |    1 +
 drivers/power/Kconfig                |    1 +
 drivers/spi/Kconfig                  |    3 +-
 drivers/tty/serial/Kconfig           |    2 +-
 drivers/usb/dwc3/Kconfig             |    2 +-
 drivers/usb/gadget/Kconfig           |    3 +-
 drivers/usb/host/Kconfig             |    2 +-
 drivers/usb/musb/Kconfig             |    1 +
 drivers/usb/renesas_usbhs/Kconfig    |    2 +-
 sound/pci/Kconfig                    |    1 +
 sound/soc/codecs/Kconfig             |    2 +-
 26 files changed, 70 insertions(+), 56 deletions(-)

-- 
1.7.10.4

