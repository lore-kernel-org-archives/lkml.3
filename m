Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758921Ab3GZNJf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 09:09:35 -0400
Received: from mail-yh0-f41.google.com ([209.85.213.41]:64529 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757321Ab3GZNJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 09:09:29 -0400
Date: Fri, 26 Jul 2013 09:09:26 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [GIT PULL] libata changes for v3.11-rc2
Message-ID: <20130726130926.GC3013@htj.dyndns.org>
References: <20130725175310.GI26107@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130725175310.GI26107@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

The ahci_imx addition was missing dependency on CONFIG_MFD_SYSCON
leading to build failures depending on config combination.  A patch
was added to address the issue.  The modified pull request follows.

Thanks.

The following changes since commit ad81f0545ef01ea651886dddac4bef6cec930092:

  Linux 3.11-rc1 (2013-07-14 15:18:27 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata.git for-3.11-fixes

for you to fetch changes up to 867974fc09f93bdd7f98d46ac3733934486bbf4a:

  ahci_imx: depend on CONFIG_MFD_SYSCON (2013-07-26 08:57:56 -0400)

----------------------------------------------------------------
Jingoo Han (1):
      libata: replace strict_strtol() with kstrtol()

Richard Zhu (2):
      ARM: imx6q: update the sata bits definitions of gpr13
      ahci_imx: add ahci sata support on imx platforms

Tejun Heo (2):
      libata: make it clear that sata_inic162x is experimental
      ahci_imx: depend on CONFIG_MFD_SYSCON

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
