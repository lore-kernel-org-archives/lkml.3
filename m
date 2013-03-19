Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867Ab3CSOy4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 10:54:56 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37557 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756654Ab3CSOyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:54:54 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCHv2 00/12] staging: [omap,ti-soc]-thermal: fixes and renaming
Date: Tue, 19 Mar 2013 10:54:16 -0400
Message-ID: <1363704868-11843-1-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg,

This is version 2 of this series to rename omap-thermal driver
inside staging tree. V1 is found here:
http://lkml.org/lkml/2013/3/18/357

The idea of the series is the same. It includes several fixes, but
the major change is that now the driver will be named ti-soc-thermal,
because it will support not only OMAP chips.

Difference from previous version is that:
. now PATCHv1 02/08 has been dropped (based on discussions),
. PATCHv1 04/08 has been split, to make review process easier
. last tree patch of this series are new fixes.


For those interested in testing and trying the driver, these patches are
also available, as usual, here:
git@gitorious.org:thermal-framework/thermal-framework.git thermal_work/omap/ti-thermal-rename
https://git.gitorious.org/thermal-framework/thermal-framework.git thermal_work/omap/ti-thermal-rename


All best,

Eduardo Valentin (12):
  staging: omap-thermal: fix return value
  staging: omap-thermal: rename bg_ptr to bgp
  staging: rename omap-thermal driver to ti-soc-thermal
  staging: ti-soc-thermal: rename Kconfig options
  staging: ti-soc-thermal: rename symbols to use better prefix
  staging: ti-soc-thermal: make unexported functions local
  staging: ti-soc-thermal: split writable data from readonly data
  stating: ti-soc-thermal: use sizeof(*pointer) while allocating
  staging: ti-soc-thermal: fix several kernel-doc warnings and error
  staging: ti-soc-thermal: fix condition to apply hyst
  staging: ti-soc-thermal: fix bitfield writing while updating
    thresholds
  staging: ti-soc-thermal: propagate error code

 drivers/staging/Kconfig                            |    2 +-
 drivers/staging/Makefile                           |    2 +-
 drivers/staging/omap-thermal/Makefile              |    5 -
 drivers/staging/omap-thermal/omap-bandgap.c        | 1300 --------------------
 drivers/staging/omap-thermal/omap-thermal-common.c |  338 -----
 .../{omap-thermal => ti-soc-thermal}/Kconfig       |   20 +-
 drivers/staging/ti-soc-thermal/Makefile            |    5 +
 .../staging/{omap-thermal => ti-soc-thermal}/TODO  |    4 +-
 .../omap4-thermal-data.c                           |   68 +-
 .../omap4xxx-bandgap.h                             |    0
 .../omap5-thermal-data.c                           |   20 +-
 .../omap5xxx-bandgap.h                             |    0
 drivers/staging/ti-soc-thermal/ti-bandgap.c        | 1297 +++++++++++++++++++
 .../omap-bandgap.h => ti-soc-thermal/ti-bandgap.h} |  190 ++--
 drivers/staging/ti-soc-thermal/ti-thermal-common.c |  338 +++++
 .../omap-thermal.h => ti-soc-thermal/ti-thermal.h} |   34 +-
 .../ti_soc_thermal.txt}                            |    0
 17 files changed, 1813 insertions(+), 1810 deletions(-)
 delete mode 100644 drivers/staging/omap-thermal/Makefile
 delete mode 100644 drivers/staging/omap-thermal/omap-bandgap.c
 delete mode 100644 drivers/staging/omap-thermal/omap-thermal-common.c
 rename drivers/staging/{omap-thermal => ti-soc-thermal}/Kconfig (72%)
 create mode 100644 drivers/staging/ti-soc-thermal/Makefile
 rename drivers/staging/{omap-thermal => ti-soc-thermal}/TODO (90%)
 rename drivers/staging/{omap-thermal => ti-soc-thermal}/omap4-thermal-data.c (85%)
 rename drivers/staging/{omap-thermal => ti-soc-thermal}/omap4xxx-bandgap.h (100%)
 rename drivers/staging/{omap-thermal => ti-soc-thermal}/omap5-thermal-data.c (96%)
 rename drivers/staging/{omap-thermal => ti-soc-thermal}/omap5xxx-bandgap.h (100%)
 create mode 100644 drivers/staging/ti-soc-thermal/ti-bandgap.c
 rename drivers/staging/{omap-thermal/omap-bandgap.h => ti-soc-thermal/ti-bandgap.h} (74%)
 create mode 100644 drivers/staging/ti-soc-thermal/ti-thermal-common.c
 rename drivers/staging/{omap-thermal/omap-thermal.h => ti-soc-thermal/ti-thermal.h} (71%)
 rename drivers/staging/{omap-thermal/omap_bandgap.txt => ti-soc-thermal/ti_soc_thermal.txt} (100%)

-- 
1.7.7.1.488.ge8e1c

