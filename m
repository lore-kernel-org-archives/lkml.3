Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab3IWRIH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 13:08:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54371 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435Ab3IWRIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 13:08:04 -0400
Date: Mon, 23 Sep 2013 10:08:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 3.12-rc2
Message-ID: <20130923170803.GA4763@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 272b98c6455f00884f0350f775c5342358ebb73f:

  Linux 3.12-rc1 (2013-09-16 16:17:51 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.12-rc2

for you to fetch changes up to 42f4891ca29a3c1535692a24acefb7015bbbc077:

  Merge tag 'fixes-for-v3.12-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb into usb-linus (2013-09-17 13:00:43 -0700)

----------------------------------------------------------------

USB fixes for 3.12-rc2

Here are a number of small USB fixes for 3.12-rc2.

One is a revert of a EHCI change that isn't quite ready for 3.12.  Others are
minor things, gadget fixes, Kconfig fixes, and some quirks and documentation
updates.

All have been in linux-next for a bit.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alan Stern (1):
      usb: gadget: fix a bug and a WARN_ON in dummy-hcd

Alexey Khoroshilov (1):
      usb: gadget: mv_u3d_core: fix violation of locking discipline in mv_u3d_ep_disable()

Andrzej Pietrasiewicz (1):
      usb: gadget: cdc2: fix conversion to new interface of f_ecm

Chanho Park (1):
      usb: s3c-hsotg: do not disconnect gadget when receiving ErlySusp intr

Chen Gang (1):
      usb: gadget: add '__ref' for rndis_config_register() and cdc_config_register()

Dave Jones (2):
      USB: fix typo in usb serial simple driver Kconfig
      USB: Faraday fotg210: fix email addresses

David Cohen (1):
      usb: dwc3: gadget: avoid memory leak when failing to allocate all eps

Frank Schäfer (1):
      USB: pl2303: distinguish between original and cloned HX chips

Greg Kroah-Hartman (2):
      Revert "USB: EHCI: support running URB giveback in tasklet context"
      Merge tag 'fixes-for-v3.12-rc2' of git://git.kernel.org/.../balbi/usb into usb-linus

Heikki Krogerus (2):
      usb: dwc3: pci: add support for BayTrail
      usb: dwc3: remove extcon dependency

Marek Szyprowski (1):
      usb: s3c-hsotg: fix unregistration function

Peter Oh (1):
      usb: gadget: f_mass_storage: reset endpoint driver data when disabled

Sachin Kamat (4):
      usb: phy: omap-usb3: Fix return value
      usb: gadget: f_ecm: Staticize ecm_alloc
      usb: gadget: f_eem: Staticize eem_alloc
      usb: host: fsl-mph-dr-of: Staticize local symbols

 drivers/usb/dwc3/Kconfig            |  1 -
 drivers/usb/dwc3/dwc3-pci.c         |  2 ++
 drivers/usb/dwc3/gadget.c           |  6 ++----
 drivers/usb/gadget/cdc2.c           | 19 +---------------
 drivers/usb/gadget/dummy_hcd.c      |  7 +++---
 drivers/usb/gadget/f_ecm.c          |  2 +-
 drivers/usb/gadget/f_eem.c          |  2 +-
 drivers/usb/gadget/f_mass_storage.c |  2 ++
 drivers/usb/gadget/fotg210-udc.c    |  2 +-
 drivers/usb/gadget/fusb300_udc.c    |  2 +-
 drivers/usb/gadget/multi.c          |  8 +++----
 drivers/usb/gadget/mv_u3d_core.c    |  3 +++
 drivers/usb/gadget/s3c-hsotg.c      | 13 ++++-------
 drivers/usb/host/ehci-fsl.c         |  2 +-
 drivers/usb/host/ehci-grlib.c       |  2 +-
 drivers/usb/host/ehci-hcd.c         |  2 +-
 drivers/usb/host/ehci-mv.c          |  2 +-
 drivers/usb/host/ehci-octeon.c      |  2 +-
 drivers/usb/host/ehci-pmcmsp.c      |  2 +-
 drivers/usb/host/ehci-ppc-of.c      |  2 +-
 drivers/usb/host/ehci-ps3.c         |  2 +-
 drivers/usb/host/ehci-q.c           |  5 +++++
 drivers/usb/host/ehci-sead3.c       |  2 +-
 drivers/usb/host/ehci-sh.c          |  2 +-
 drivers/usb/host/ehci-tilegx.c      |  2 +-
 drivers/usb/host/ehci-w90x900.c     |  2 +-
 drivers/usb/host/ehci-xilinx-of.c   |  2 +-
 drivers/usb/host/fsl-mph-dr-of.c    |  6 +++---
 drivers/usb/phy/phy-omap-usb3.c     |  2 +-
 drivers/usb/serial/Kconfig          |  2 +-
 drivers/usb/serial/pl2303.c         | 43 +++++++++++++++++++++++++++----------
 31 files changed, 81 insertions(+), 72 deletions(-)
