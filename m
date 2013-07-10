Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab3GJPs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 11:48:27 -0400
Received: from mail-ve0-f202.google.com ([209.85.128.202]:51661 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab3GJPs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 11:48:26 -0400
From: Doug Anderson <dianders@chromium.org>
To: Chris Ball <cjb@laptop.org>
Cc: Olof Johansson <olof@lixom.net>, Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        James Hogan <james.hogan@imgtec.com>,
        Grant Grundler <grundler@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Doug Anderson <dianders@chromium.org>,
        linux-samsung-soc@vger.kernel.org, linux-mmc@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 0/5] mmc: dw_mmc: fixes for suspend/resume on exynos
Date: Wed, 10 Jul 2013 08:42:01 -0700
Message-Id: <1373470926-19314-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1373411961-23812-1-git-send-email-dianders@chromium.org>
References: <1373411961-23812-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches addresses some suspend/resume problems with
dw_mmc on exynos platforms.  Since suspend/resume is not fully working
on ToT Linux (3.10) on exynos5250-snow, this series was tested against
the current ToT ChromeOS 3.8 tree.  I have confirmed basic booting
and eMMC / SD card usage (and compiling, honest!) against ToT Linux.

Changes in v3:
- Add freeze/thaw and poweroff/restore noirq entries.

Changes in v2:
- Fix typo (some -> come)
- Use ~0 instead of 0xFFFFFFFF; add comment about value
- Use suspend_noirq as per James Hogan.

Doug Anderson (5):
  mmc: dw_mmc: Invalidate cache of current_speed after suspend/resume
  mmc: dw_mmc: Add suspend_noirq/resume_noirq callbacks for dw_mmc-pltfm
  mmc: dw_mmc: Add exynos resume_noirq callback to clear WAKEUP_INT
  mmc: dw_mmc: Always setup the bus after suspend/resume
  mmc: dw_mmc: Set timeout to max upon resume

 drivers/mmc/host/dw_mmc-exynos.c | 23 ++++++++++++++++++++++
 drivers/mmc/host/dw_mmc-pltfm.c  | 41 +++++++++++++++++++++++++++++++++++++---
 drivers/mmc/host/dw_mmc.c        | 15 +++++++++++----
 drivers/mmc/host/dw_mmc.h        |  4 ++++
 4 files changed, 76 insertions(+), 7 deletions(-)

-- 
1.8.3

