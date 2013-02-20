Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935054Ab3BTVXt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 16:23:49 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:33720 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759095Ab3BTVXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 16:23:10 -0500
Date: Wed, 20 Feb 2013 22:22:47 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Davide Ciminaghi <ciminaghi@gnudd.com>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Subject: [PATCH V5 0/5] x86: a bridge from PCI to AMBA
Message-ID: <cover.1361393832.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a repost of patches I sent quite some time ago and are
available from the "tip" repository, as branch "x86/amba" based on
v3.7.  That branch includes 7 patches but two of them are already
upstream. Some of the other 5 had minor conflicts during rebase, but
only in the initial "#include" area.

I repost as Peter Anvin suggested. The commits in the tip
repository included both hpa's signed off (which I left in)
and the reference to the previous lkml message, which I removed
as it is not current by the time  this message exists.

Some acked-by we received on the mailing list are not in the patch set
because they are missing from tip::x86/amba which is authoritative.

Alessandro Rubini (5):
  DMA: PL330: use prefix in reg names to build under x86
  watchdog: sp805_wdt depends on ARM
  mmc: Use the new <linux/sizes.h>
  drivers/amba: add support for a PCI bridge
  x86: add CONFIG_ARM_AMBA, selected by STA2X11

 arch/x86/Kconfig            |    4 ++
 drivers/Kconfig             |    2 +
 drivers/amba/Kconfig        |   10 ++++
 drivers/amba/Makefile       |    1 +
 drivers/amba/pci-amba.c     |   93 +++++++++++++++++++++++++++++++++++++
 drivers/dma/pl330.c         |  107 ++++++++++++++++++++++---------------------
 drivers/mmc/host/mmci.c     |    2 +-
 drivers/mmc/host/msm_sdcc.c |    2 +-
 drivers/mmc/host/mvsdio.c   |    2 +-
 drivers/mmc/host/mxcmmc.c   |    2 +-
 drivers/mmc/host/pxamci.c   |    3 +-
 drivers/watchdog/Kconfig    |    2 +-
 12 files changed, 170 insertions(+), 60 deletions(-)
 create mode 100644 drivers/amba/Kconfig
 create mode 100644 drivers/amba/pci-amba.c

-- 
1.7.7.2
