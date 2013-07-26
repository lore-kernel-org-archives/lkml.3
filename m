Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758847Ab3GZQ6L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 12:58:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48618 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757334Ab3GZQ6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 12:58:08 -0400
Date: Fri, 26 Jul 2013 09:58:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 3.11-rc3
Message-ID: <20130726165807.GA22997@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit ad81f0545ef01ea651886dddac4bef6cec930092:

  Linux 3.11-rc1 (2013-07-14 15:18:27 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.11-rc3

for you to fetch changes up to 2c7b871b9102c497ba8f972aa5d38532f05b654d:

  usb: Clear both buffers when clearing a control transfer TT buffer. (2013-07-25 11:37:13 -0700)

----------------------------------------------------------------
USB fixes for 3.11-rc3

Here are a number of USB fixes for 3.11-rc3.

Lots of little things, nothing major.  A number of new device ids, build
fixes for DMA, and a bunch of other minor things.  All of these have
been in the linux-next tree.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alan Stern (3):
      usb: gadget: don't fail when DMA isn't present
      USB: move the definition of USB_MAXCHILDREN
      USB: global suspend and remote wakeup don't mix

Alexandr \"Sky\" Ivanov (1):
      USB: option: add D-Link DWM-152/C1 and DWM-156/C1

Andrzej Pietrasiewicz (2):
      usb: gadget: Kconfig: Fix configfs-based RNDIS function build
      usb/gadget: free opts struct on error recovery

Arnd Bergmann (1):
      usb: gadget: at91_udc: call at91udc_of_init only when needed

Barry Grussling (1):
      usb: cp210x support SEL C662 Vendor/Device

Bjørn Mork (1):
      usb: option: add TP-LINK MA260

Boris BREZILLON (1):
      usb: gadget: at91_udc: prepare clk before calling enable

Dan Williams (1):
      usb: serial: option: add Olivetti Olicard 200

Daniil Bolsun (1):
      USB: option: append Petatel NP10T device to GSM modems list

Enrico Mioso (3):
      usb: serial: option: Add ONYX 3G device support
      usb: serial: option: blacklist ONDA MT689DC QMI interface
      usb: serial: option.c: remove ONDA MT825UP product ID fromdriver

Felipe Balbi (1):
      usb: dwc3: gadget: don't prevent gadget from being probed if we fail

Geert Uytterhoeven (4):
      usb: dwc3: USB_DWC3 should depend on HAS_DMA
      usb: gadget: USB_MV_UDC should depend on HAS_DMA
      usb: gadget: USB_FOTG210_UDC should depend on HAS_DMA
      usb: gadget: USB_MV_U3D should depend on HAS_DMA

George Cherian (1):
      usb: host: xhci: Enable XHCI_SPURIOUS_SUCCESS for all controllers with xhci 1.0

Greg Kroah-Hartman (2):
      Merge tag 'fixes-for-v3.11-rc1' of git://git.kernel.org/.../balbi/usb into usb-linus
      Merge tag 'for-usb-linus-2013-07-25' of git://git.kernel.org/.../sarah/xhci into usb-linus

Huang Rui (1):
      usb: dwc3: fix wrong bit mask in dwc3_event_type

Johan Hovold (2):
      USB: ti_usb_3410_5052: fix dynamic-id matching
      USB: mos7840: fix memory leak in open

Jóhann B. Guðmundsson (1):
      USB: misc: Add Manhattan Hi-Speed USB DVI Converter to sisusbvga

Kuninori Morimoto (1):
      usb: renesas_usbhs: gadget: remove extra check on udc_stop

Luiz Angelo Daros de Luca (1):
      usb: serial: cp210x: Add USB ID for Netgear Switches embedded serial adapter

Oleksij Rempel (1):
      xhci: fix null pointer dereference on ring_doorbell_for_active_rings

Olof Johansson (1):
      usb: xhci: Mark two functions __maybe_unused

Randy Dunlap (1):
      usb: fix build warning in pci-quirks.h when CONFIG_PCI is not enabled

Ren Bigcren (1):
      USB: storage: Add MicroVault Flash Drive to unusual_devs

Roger Quadros (1):
      USB: EHCI: Fix resume signalling on remote wakeup

Ruchika Kharwar (2):
      usb: dwc3: fix the error returned with usb3_phy failure
      usb: phy: omap-usb3: fix dpll clock index

Sachin Kamat (1):
      usb: phy: samsung: Fix an error message typo

Sami Rahman (1):
      USB: cp210x: add MMB and PI ZigBee USB Device Support

Sarah Sharp (1):
      xhci: Avoid NULL pointer deref when host dies.

Wei Yongjun (1):
      usb: gadget: mv_u3d_core: fix to pass correct device identity to free_irq()

William Gulland (1):
      usb: Clear both buffers when clearing a control transfer TT buffer.

Yuan-Hsin Chen (1):
      usb: gadget: fotg210-udc: remove __init and __exit

 drivers/usb/core/hub.c                 | 48 ++++++++++++++++++++++++++++------
 drivers/usb/core/hub.h                 |  3 +++
 drivers/usb/dwc3/Kconfig               |  2 +-
 drivers/usb/dwc3/core.c                |  2 +-
 drivers/usb/dwc3/core.h                |  4 +--
 drivers/usb/dwc3/gadget.c              |  1 +
 drivers/usb/gadget/Kconfig             |  5 +++-
 drivers/usb/gadget/at91_udc.c          | 16 +++++++-----
 drivers/usb/gadget/f_ecm.c             |  7 +++--
 drivers/usb/gadget/f_eem.c             |  7 +++--
 drivers/usb/gadget/f_ncm.c             |  7 +++--
 drivers/usb/gadget/f_phonet.c          |  7 +++--
 drivers/usb/gadget/f_rndis.c           |  7 +++--
 drivers/usb/gadget/f_subset.c          |  7 +++--
 drivers/usb/gadget/fotg210-udc.c       |  4 +--
 drivers/usb/gadget/mv_u3d_core.c       |  4 +--
 drivers/usb/gadget/udc-core.c          |  6 +++++
 drivers/usb/host/ehci-hub.c            |  1 +
 drivers/usb/host/pci-quirks.h          |  1 +
 drivers/usb/host/xhci-pci.c            |  1 -
 drivers/usb/host/xhci-ring.c           |  2 +-
 drivers/usb/host/xhci.c                | 17 ++++++++----
 drivers/usb/misc/sisusbvga/sisusb.c    |  1 +
 drivers/usb/phy/phy-omap-usb3.c        |  2 +-
 drivers/usb/phy/phy-samsung-usb2.c     |  2 +-
 drivers/usb/renesas_usbhs/mod_gadget.c |  4 ---
 drivers/usb/serial/cp210x.c            |  4 +++
 drivers/usb/serial/mos7840.c           | 25 ++++++++++++------
 drivers/usb/serial/option.c            | 23 +++++++++-------
 drivers/usb/serial/ti_usb_3410_5052.c  |  2 +-
 drivers/usb/storage/unusual_devs.h     |  7 +++++
 include/linux/usb.h                    | 11 --------
 include/uapi/linux/usb/ch11.h          | 11 ++++++++
 33 files changed, 172 insertions(+), 79 deletions(-)
