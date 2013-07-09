Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703Ab3GIXTc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 19:19:32 -0400
Received: from mail-yh0-f74.google.com ([209.85.213.74]:58544 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab3GIXT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 19:19:29 -0400
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
Subject: [PATCH v2 0/5] mmc: dw_mmc: fixes for suspend/resume on exynos
Date: Tue,  9 Jul 2013 16:19:16 -0700
Message-Id: <1373411961-23812-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1373391071-6312-1-git-send-email-dianders@chromium.org>
References: <1373391071-6312-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches addresses some suspend/resume problems with
dw_mmc on exynos platforms.  Since suspend/resume is not fully working
on ToT Linux (3.10) on exynos5250-snow, this series was tested against
the current ToT ChromeOS 3.8 tree.  I have confirmed basic booting
and eMMC / SD card usage (and compiling, honest!) against ToT Linux.

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

 drivers/mmc/host/dw_mmc-exynos.c | 23 +++++++++++++++++++++++
 drivers/mmc/host/dw_mmc-pltfm.c  | 37 ++++++++++++++++++++++++++++++++++---
 drivers/mmc/host/dw_mmc.c        | 15 +++++++++++----
 drivers/mmc/host/dw_mmc.h        |  4 ++++
 4 files changed, 72 insertions(+), 7 deletions(-)

-- 
1.8.3

