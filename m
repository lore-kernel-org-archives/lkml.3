Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792AbaF3Skq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 14:40:46 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43836 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754603AbaF3Sko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 14:40:44 -0400
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [GIT PULL] USB fixes for v3.16-rc4
Date: Mon, 30 Jun 2014 13:40:35 -0500
Message-ID: <1404153635-10868-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.0.0.390.gcb682f8
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Here's my second set of fixes. Note the revert of the patch Michal
asked to revert.

Please consider merging to your usb-linus branch. Let me know if you
want any changes to this pull request.

cheers


The following changes since commit 5d881802c407d83c169c875dad88fe2bba066c33:

  usb: musb: core: Handle Babble condition only in HOST mode (2014-06-19 15:43:07 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git tags/fixes-for-v3.16-rc4

for you to fetch changes up to 8035691365b80428c58908215d4408559afe7cb3:

  usb: musb: dsps: fix the base address for accessing the mode register (2014-06-30 13:31:48 -0500)

----------------------------------------------------------------
usb: fixes for v3.16-rc4

A few more fixes for this RC cycle. There's a revert of a previous patch
which ended up being the wrong version, so we reverted that commit and
applied a better fix.

CPPI41 got a race condition fix which was found by Thomas Gleixner.

The MSM PHY driver got a runtime pm usage fix so that it wouldn't
kill the PHY while it was still being used.

We also have a fix for a panic caused when removing musb_am335x driver.

Other than that, a few other minor fixes.

Signed-of-by: Felipe Balbi <balbi@ti.com>

----------------------------------------------------------------
Andreas Larsson (1):
      usb: gadget: gr_udc: Fix check for invalid number of microframes

Ezequiel Garcia (1):
      usb: musb: Fix panic upon musb_am335x module removal

Felipe Balbi (1):
      Revert "tools: ffs-test: convert to new descriptor format fixing compilation error"

Lothar Waßmann (1):
      usb: musb: dsps: fix the base address for accessing the mode register

Michal Nazarewicz (2):
      usb: gadget: f_fs: resurect usb_functionfs_descs_head structure
      tools: ffs-test: fix header values endianess

Srinivas Kandagatla (1):
      usb: phy: msm: Do not do runtime pm if the phy is not idle

Thomas Gleixner (1):
      usb: musb: Ensure that cppi41 timer gets armed on premature DMA TX irq

 drivers/usb/gadget/gr_udc.c         |  5 +++--
 drivers/usb/musb/musb_am335x.c      | 23 ++++++-----------------
 drivers/usb/musb/musb_cppi41.c      |  2 +-
 drivers/usb/musb/musb_dsps.c        |  9 ++++-----
 drivers/usb/phy/phy-msm-usb.c       |  4 +++-
 include/uapi/linux/usb/functionfs.h |  9 ++++++++-
 tools/usb/Makefile                  |  6 +-----
 tools/usb/ffs-test.c                | 24 ++++--------------------
 8 files changed, 30 insertions(+), 52 deletions(-)
