Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbaFMROQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 13:14:16 -0400
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:45610 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbaFMROL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 13:14:11 -0400
X-IronPort-AV: E=Sophos;i="5.01,472,1400050800"; 
   d="scan'208";a="34295398"
From: Markus Mayer <markus.mayer@linaro.org>
To: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
CC: Tim Kryger <tim.kryger@gmail.com>,
        Mike Looijmans <mike.looijmans@topic.nl>,
        Andrew Bresticker <abrestic@chromium.org>,
        "Linux MMC List" <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 0/2] mmc: sdhci: Use mmc core regulator infrastucture
Date: Fri, 13 Jun 2014 10:13:55 -0700
Message-ID: <1402679637-27611-1-git-send-email-markus.mayer@linaro.org>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series switches the common SDHCI code over to use mmc_host's
regulator pointers rather than keeping its own set.

In addition, we can now re-use the newly introduced local "mmc" pointer
in several function calls in lieu of using host->mmc.

The first patch in the series has been posted before
(https://lkml.org/lkml/2014/4/24/947). The follow-on patch has not.

This series is based on mainline (commit 16b9057804).

Changes from v3:
  - Squashed patches 2 & 3 together. The series now has only 2 parts,
    but is otherwise unchanged.

Changes from v2:
  - Replaced a few more host->mmc references with mmc in
    sdhci_add_host(). This change affects PATCH 3/3 only. The other two
    patches are unchanged from v2.
  - Rebased the series on mainline (rather than mmc-next). Doing so did
    not affect the patches themselves. They applied cleanly as-is.

Changes from v1:
  - Resolved merge conflicts resulting from RMK's MMC series. The most
    significant conflict was the move of regulator code from
    sdhci_do_set_ios() to sdhci_set_power().
  - Added follow-on patches 2 & 3 of the series.
  - Updated Tim Kryger's e-mail address.

Markus Mayer (1):
  mmc: sdhci: Replace host->mmc with mmc where possible

Tim Kryger (1):
  mmc: sdhci: Use mmc core regulator infrastucture

 drivers/mmc/host/sdhci.c  | 123 ++++++++++++++++++----------------------------
 include/linux/mmc/sdhci.h |   3 --
 2 files changed, 49 insertions(+), 77 deletions(-)

-- 
1.9.1

