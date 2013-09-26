Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab3IZTXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 15:23:34 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:43181 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab3IZTXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 15:23:32 -0400
From: Grant Grundler <grundler@chromium.org>
To: Chris Ball <cjb@laptop.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Grant Grundler <grundler@chromium.org>
Subject: [PATCH 0/7] mmc: core: cleanup and locking patches description
Date: Thu, 26 Sep 2013 12:22:53 -0700
Message-Id: <1380223380-22451-1-git-send-email-grundler@chromium.org>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following 7 patches are mostly cleanup with one key patch around host->areq
locking.  The host->areq locking problem description is here:
	http://www.spinics.net/lists/linux-mmc/msg21644.html

I do believe this preposed host->areq locking patch is a complete fix.
But it appears to fix the problem and is better than nothing.

This patch sequence applies clean to linus' 3.12-rc2 branch and only compile
tested in this form. This is a forward port (and cleanup) of the
same patch I've been testing on ChromeOS-3.4 tree using Exynos5250 chipset.

cheers,
grant

0000-mmc-core-cleanups-and-locking-description (this email)
0001-mmc-core-rename-data-to-saved_areq.patch
0002-mmc-core-rename-local-var-err-to-saved_err.patch
0003-mmc-core-restructure-error-handling-for-start-req.patch
0004-mmc-core-use-common-code-path-to-return-error.patch
0005-mmc-core-handling-polling-more-gracefully.patch
0006-mmc-core-protect-references-to-host-areq-with-host-l.patch
0007-mmc-core-mmc_start_req-is-a-misnomer-mmc_process_are.patch


 drivers/mmc/card/block.c    |   8 ++--
 drivers/mmc/card/mmc_test.c |   4 +-
 drivers/mmc/core/core.c     | 103 +++++++++++++++++++++++++-------------------
 include/linux/mmc/core.h    |   2 +-
 4 files changed, 66 insertions(+), 51 deletions(-)
