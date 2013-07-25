Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213Ab3GYRxX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 13:53:23 -0400
Received: from mail-ye0-f182.google.com ([209.85.213.182]:42927 "EHLO
	mail-ye0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756970Ab3GYRxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:53:19 -0400
Date: Thu, 25 Jul 2013 13:53:10 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [GIT PULL] libata changes for v3.11-rc2
Message-ID: <20130725175310.GI26107@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Here are assorted libata updates.  The most critical one is a fix for
ahci oops during boot.  Also, a new smallish platform ahci driver is
added and sata_inic162x is marked clearly as experimental (it whines
during boot too) as data corruption seems rather common on the device
and it's unlikely to get any love in the foreseeable future.  If the
whining doesn't draw any attention, I think we'd probably be better of
making the driver depend on BROKEN in a couple releases.

The changes are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata.git for-3.11-fixes

for you to fetch changes up to 9e54eae23bc9cca0d8a955018c35b1250e09a73a:

  ahci_imx: add ahci sata support on imx platforms (2013-07-24 12:29:08 -0400)

Thanks!

----------------------------------------------------------------
Jingoo Han (1):
      libata: replace strict_strtol() with kstrtol()

Richard Zhu (2):
      ARM: imx6q: update the sata bits definitions of gpr13
      ahci_imx: add ahci sata support on imx platforms

Tejun Heo (1):
      libata: make it clear that sata_inic162x is experimental

Xiaotian Feng (1):
      ahci: fix Null pointer dereference in achi_host_active()

Youquan Song (1):
      ata: Fix DVD not dectected at some platform with Wellsburg PCH

 drivers/ata/Kconfig                         |  11 +-
 drivers/ata/Makefile                        |   1 +
 drivers/ata/ahci.c                          |   9 +-
 drivers/ata/ahci_imx.c                      | 236 ++++++++++++++++++++++++++++
 drivers/ata/ata_piix.c                      |   2 +-
 drivers/ata/libata-scsi.c                   |   6 +-
 drivers/ata/sata_inic162x.c                 |  14 ++
 include/linux/mfd/syscon/imx6q-iomuxc-gpr.h | 121 +++++++++-----
 8 files changed, 358 insertions(+), 42 deletions(-)
 create mode 100644 drivers/ata/ahci_imx.c

-- 
tejun
