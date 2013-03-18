Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab3CRPAH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 11:00:07 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56563 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108Ab3CRPAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 11:00:05 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 0/8] staging: [omap,ti-soc]-thermal: fixes and renaming
Date: Mon, 18 Mar 2013 10:59:08 -0400
Message-ID: <1363618756-15851-1-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

I am sending extra patches on omap-thermal driver, under staging.

There are couple of fixes based on Dan Carpenter's review on
the last patch set I sent. On top of these, there are some
changes on the naming convention for this driver. This rename
is based on previous review cycles that this driver has got.
Besides, it must support other chip families, apart from OMAP,
that's mainly why there is a big rename on this patch set.
And as  usual, there are couple of extra fixes.

All these are based on your staging/staging-next branch.

For those interested in testing and trying the driver, these patches are
also available, as usual, here:
git@gitorious.org:thermal-framework/thermal-framework.git thermal_work/omap/ti-thermal-rename
https://git.gitorious.org/thermal-framework/thermal-framework.git thermal_work/omap/ti-thermal-rename

BR,

Eduardo Valentin (8):
  staging: omap-thermal: fix return value
  staging: omap-thermal: use spin_lock_irqsave inside IRQ handler
  staging: omap-thermal: rename bg_ptr to bgp
  staging: rename omap-thermal driver to ti-soc-thermal
  staging: ti-soc-thermal: make unexported functions local
  staging: ti-soc-thermal: split writable data from readonly data
  stating: ti-soc-thermal: use sizeof(*pointer) while allocating
  staging: ti-soc-thermal: fix several kernel-doc warnings and error

 drivers/staging/Kconfig                            |    2 +-
 drivers/staging/Makefile                           |    2 +-
 drivers/staging/omap-thermal/Makefile              |    5 -
 drivers/staging/omap-thermal/omap-bandgap.c        | 1300 --------------------
 drivers/staging/omap-thermal/omap-thermal-common.c |  338 -----
 .../{omap-thermal => ti-soc-thermal}/Kconfig       |   14 +-
 drivers/staging/ti-soc-thermal/Makefile            |    5 +
 .../staging/{omap-thermal => ti-soc-thermal}/TODO  |    0
 .../omap4-thermal-data.c                           |   68 +-
 .../omap4xxx-bandgap.h                             |    0
 .../omap5-thermal-data.c                           |   20 +-
 .../omap5xxx-bandgap.h                             |    0
 .../omap_bandgap.txt                               |    0
 drivers/staging/ti-soc-thermal/ti-bandgap.c        | 1299 +++++++++++++++++++
 .../omap-bandgap.h => ti-soc-thermal/ti-bandgap.h} |  181 ++--
 drivers/staging/ti-soc-thermal/ti-thermal-common.c |  338 +++++
 .../omap-thermal.h => ti-soc-thermal/ti-thermal.h} |   30 +-
 17 files changed, 1803 insertions(+), 1799 deletions(-)
 delete mode 100644 drivers/staging/omap-thermal/Makefile
 delete mode 100644 drivers/staging/omap-thermal/omap-bandgap.c
 delete mode 100644 drivers/staging/omap-thermal/omap-thermal-common.c
 rename drivers/staging/{omap-thermal => ti-soc-thermal}/Kconfig (82%)
 create mode 100644 drivers/staging/ti-soc-thermal/Makefile
 rename drivers/staging/{omap-thermal => ti-soc-thermal}/TODO (100%)
 rename drivers/staging/{omap-thermal => ti-soc-thermal}/omap4-thermal-data.c (85%)
 rename drivers/staging/{omap-thermal => ti-soc-thermal}/omap4xxx-bandgap.h (100%)
 rename drivers/staging/{omap-thermal => ti-soc-thermal}/omap5-thermal-data.c (96%)
 rename drivers/staging/{omap-thermal => ti-soc-thermal}/omap5xxx-bandgap.h (100%)
 rename drivers/staging/{omap-thermal => ti-soc-thermal}/omap_bandgap.txt (100%)
 create mode 100644 drivers/staging/ti-soc-thermal/ti-bandgap.c
 rename drivers/staging/{omap-thermal/omap-bandgap.h => ti-soc-thermal/ti-bandgap.h} (75%)
 create mode 100644 drivers/staging/ti-soc-thermal/ti-thermal-common.c
 rename drivers/staging/{omap-thermal/omap-thermal.h => ti-soc-thermal/ti-thermal.h} (72%)

-- 
1.7.7.1.488.ge8e1c

