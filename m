Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524Ab3LSUmd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 15:42:33 -0500
Received: from seketeli.net ([91.121.166.71]:47963 "EHLO ms.seketeli.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756378Ab3LSUm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 15:42:29 -0500
From: Apelete Seketeli <apelete@seketeli.net>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v3 0/2] Add USB support for Ingenic JZ4740
Date: Thu, 19 Dec 2013 21:42:25 +0100
Message-Id: <1387485747-25759-1-git-send-email-apelete@seketeli.net>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Following the fix I submitted a few weeks ago, here is a set of
patches that adds USB support for the Ingenic JZ4740 MIPS SoC.

The JZ4740 is found in the Ben NanoNote handheld computer which is
built by the Qi-Hardware community.
Even though Ben NanoNote is already supported in the kernel, we were
relying on an out-of-tree gadget driver to make use of the JZ4740 USB
Device Controller.

The patches that come as a follow-up of this message are an attempt to
provide USB support through an musb glue layer.

Changes since v2:
	- usb: musb-jz4740: Add COMPILE_TEST dependency in Kconfig
	- usb: musb-jz4740: Split drivers/ files from arch/ files

Changes since v1:
	- usb: musb-jz4740: Don't manually free device managed resources
	- usb: musb-jz4740: Move musb_hdrc_config to the glue driver
	- usb: musb-jz4740: Move jz4740 specific fifo config to the jz4740 glue
	- usb: musb-jz4740: Mask host mode only IRQ bits
	- usb: musb-jz4740: Remove set_vbus callback
	- usb: musb_gadget: Use is_otg flag to set gadget peripheral mode on reset

Changes were rebased on top of Felipe Balbi's USB Subsystem master
branch, built and tested on device successfully.

The following changes since commit 7c0883d:

  Merge branch 'next'

are available in the git repository at:

  git://seketeli.fr/~apelete/linux-usb.git musb-jz4740

Apelete Seketeli (2):
  usb: musb: add support for JZ4740 usb device  controller
  usb: musb: fix setting JZ4740 gadget periphal mode on reset

 drivers/usb/musb/Kconfig       |    8 +-
 drivers/usb/musb/Makefile      |    1 +
 drivers/usb/musb/jz4740.c      |  201 ++++++++++++++++++++++++++++++++++++++++
 drivers/usb/musb/musb_gadget.c |   10 +-
 4 files changed, 218 insertions(+), 2 deletions(-)
 create mode 100644 drivers/usb/musb/jz4740.c

-- 
1.7.10.4

