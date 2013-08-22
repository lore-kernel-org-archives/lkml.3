Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab3HVQTW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 12:19:22 -0400
Received: from mail-yh0-f74.google.com ([209.85.213.74]:35053 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367Ab3HVQTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 12:19:19 -0400
From: Doug Anderson <dianders@chromium.org>
To: Chris Ball <cjb@laptop.org>
Cc: Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        James Hogan <james.hogan@imgtec.com>,
        Grant Grundler <grundler@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Olof Johansson <olof@lixom.net>,
        Doug Anderson <dianders@chromium.org>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v6 0/3] mmc: dw_mmc: fixes for suspend/resume on exynos
Date: Thu, 22 Aug 2013 09:19:05 -0700
Message-Id: <1377188348-3418-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches addresses some suspend/resume problems with
dw_mmc on exynos platforms, espeically exynos5420.  This patchset was
tested on the current ToT Chromeos 3.8 tree (which has lots of
backports from 3.10/3.11) and on ToT Linux (v3.11-rc6).  I have
confirmed basic booting and that SD cards work across suspend/resume
(both if they are plugged in and if they are not plugged in).

I have received confirmation from Samsung that the problem solved for
exynos5420 is a silicon errata and that this is a good fix.

Changes in v6:
- Took out TODO comment copied from main platform code.
- Replaces previous pathes that ensured saving/restoring clocks.

Changes in v5:
- Cleaned up dw_mci_exynos_resume_noirq() comment as per Seungwon.
- Don't memcpy dev_pm_ops structure, define a new one.

Changes in v4:
- Take Seungwon's suggestion and don't add any dw_mmc-pltfm code.

Changes in v3:
- Add freeze/thaw and poweroff/restore noirq entries.

Changes in v2:
- Use suspend_noirq as per James Hogan.

Doug Anderson (3):
  mmc: dw_mmc: Add exynos resume_noirq callback to clear WAKEUP_INT
  mmc: dw_mmc: Honor requests to set the clock to 0 (turn off clock)
  mmc: dw_mmc: Set timeout to max upon resume

 drivers/mmc/host/dw_mmc-exynos.c | 53 +++++++++++++++++++++++++++++++++++++++-
 drivers/mmc/host/dw_mmc.c        | 24 ++++++++++--------
 2 files changed, 66 insertions(+), 11 deletions(-)

-- 
1.8.3

