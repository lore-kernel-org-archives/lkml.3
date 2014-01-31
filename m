Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198AbaAaKZa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 05:25:30 -0500
Received: from top.free-electrons.com ([176.31.233.9]:42888 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754182AbaAaKZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 05:25:25 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 0/3] spi: core: Introduce devm_spi_alloc_master
Date: Fri, 31 Jan 2014 11:23:09 +0100
Message-Id: <1391163792-21819-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

This patchset introduces a devm_spi_alloc_master to the spi core. While most of
the drivers have a spi_master_put call in the probe, a lot of them using the
devm_spi_register_master function are missing it in the remove function,
leading to leaked resources.

Hence, we introduced a devm_spi_alloc_master, and converted the users of
devm_spi_register_master to use it.

Maxime Ripard (3):
  spi: core: Add devm_spi_alloc_master
  spi: core: Update the devm_spi_register_master documentation
  spi: switch to devm_spi_alloc_master

 drivers/spi/spi-atmel.c          |  8 +++-----
 drivers/spi/spi-bcm2835.c        | 15 +++++----------
 drivers/spi/spi-bcm63xx-hsspi.c  |  8 +++-----
 drivers/spi/spi-bcm63xx.c        | 16 ++++++----------
 drivers/spi/spi-bfin-v3.c        | 13 ++++---------
 drivers/spi/spi-clps711x.c       | 37 +++++++++++++++----------------------
 drivers/spi/spi-coldfire-qspi.c  | 15 +++++----------
 drivers/spi/spi-dw.c             |  6 ++----
 drivers/spi/spi-ep93xx.c         | 15 +++++----------
 drivers/spi/spi-falcon.c         |  5 ++---
 drivers/spi/spi-mpc512x-psc.c    | 19 ++++++++-----------
 drivers/spi/spi-mxs.c            |  9 +++------
 drivers/spi/spi-octeon.c         | 12 ++++--------
 drivers/spi/spi-omap-100k.c      | 16 +++++-----------
 drivers/spi/spi-omap2-mcspi.c    | 18 ++++++------------
 drivers/spi/spi-orion.c          | 10 +++-------
 drivers/spi/spi-pl022.c          |  3 +--
 drivers/spi/spi-pxa2xx.c         |  3 +--
 drivers/spi/spi-rspi.c           | 13 ++++---------
 drivers/spi/spi-s3c64xx.c        | 23 ++++++++---------------
 drivers/spi/spi-sc18is602.c      | 12 ++----------
 drivers/spi/spi-sh-hspi.c        |  7 ++-----
 drivers/spi/spi-tegra114.c       | 15 +++++----------
 drivers/spi/spi-tegra20-sflash.c | 12 ++++--------
 drivers/spi/spi-tegra20-slink.c  | 15 +++++----------
 drivers/spi/spi-ti-qspi.c        | 32 +++++++++-----------------------
 drivers/spi/spi-txx9.c           |  3 +--
 drivers/spi/spi-xcomm.c          |  8 ++------
 drivers/spi/spi.c                | 38 +++++++++++++++++++++++++++++++++++++-
 include/linux/spi/spi.h          |  2 ++
 30 files changed, 162 insertions(+), 246 deletions(-)

-- 
1.8.4.2

