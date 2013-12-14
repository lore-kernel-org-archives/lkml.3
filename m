Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab3LNDtM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 22:49:12 -0500
Received: from seketeli.net ([91.121.166.71]:48107 "EHLO ms.seketeli.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253Ab3LNDsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 22:48:40 -0500
From: Apelete Seketeli <apelete@seketeli.net>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 0/3] Add USB support for Ingenic JZ4740
Date: Sat, 14 Dec 2013 04:48:35 +0100
Message-Id: <1386992918-1531-1-git-send-email-apelete@seketeli.net>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Following the fix I submitted a few weeks ago, here is a set of
patches that add USB support for the Ingenic JZ4740 MIPS SoC.

The JZ4740 is found in the Ben NanoNote handheld computer which is
built by the Qi-Hardware community.
Even though Ben NanoNote is already supported in the kernel, we were
relying on an out-of-tree gadget driver to make use of the JZ4740 USB
Device Controller.

The patches that come as a follow-up of this message are an attempt to
provide USB support through an musb glue layer.

Changes were rebased on top of Felipe Balbi's USB Subsystem master
branch, built and tested on device successfully.

The following changes since commit 9bdff34517bc49d8e98558659e077ea9f9df3d60:

  Merge branch 'next'

are available in the git repository at:

  git://seketeli.fr/~apelete/linux-usb.git musb-jz4740

Apelete Seketeli (3):
  mips: qi_lb60: add defconfig for Ben NanoNote
  usb: musb: add support for JZ4740 usb device controller
  usb: musb: fix setting JZ4740 gadget periphal mode on reset

 arch/mips/configs/qi_lb60_defconfig          |  188 +++++++++++++++++++++
 arch/mips/include/asm/mach-jz4740/platform.h |    1 +
 arch/mips/jz4740/board-qi_lb60.c             |    1 +
 arch/mips/jz4740/platform.c                  |   55 +++++--
 drivers/usb/musb/Kconfig                     |    8 +-
 drivers/usb/musb/Makefile                    |    1 +
 drivers/usb/musb/jz4740.c                    |  229 ++++++++++++++++++++++++++
 drivers/usb/musb/musb_core.c                 |   14 ++
 drivers/usb/musb/musb_gadget.c               |    9 +
 9 files changed, 489 insertions(+), 17 deletions(-)
 create mode 100644 arch/mips/configs/qi_lb60_defconfig
 create mode 100644 drivers/usb/musb/jz4740.c

-- 
1.7.10.4

