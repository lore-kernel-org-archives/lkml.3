Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbaJTVG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 17:06:27 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:40342 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbaJTVGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 17:06:24 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Doug Anderson <dianders@chromium.org>, Mark Brown <broonie@kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v3 0/2] ARM: EXYNOS: Call regulator suspend prepare/finish
Date: Mon, 20 Oct 2014 23:05:49 +0200
Message-Id: <1413839151-10875-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This series add support for Exynos platforms to prepare regulators for
system suspend. The regulator core has a set of helpers functions to be
used when the system is entering and leaving from a suspend state but
currently there is only one user in mainline.

This user is drivers/mfd/sec-core.c but it calls regulator_suspend_prepare()
from within the driver power-management suspend function. This does not
seems to be correct since the regulator suspend prepare function affects all
regulators in the system and not only the ones managed by this device.

So patch #1 in this series revert the commit that introduced that change and
patch #2 calls the regulator framework suspend/finish functions from the
Exynos platform power-management code. The first patch should be queued through
the mfd tree and the second through the linux-samsung tree.

Changes since v2:
 - Check for regulator_suspend_finish() return value for an error.
   Suggested by Doug Anderson.

Changes since v1:
 - Remove the call to regulator_suspend_prepare() from drivers/mfd/sec-core.c
   as suggested by Doug Anderson.
 - Call regulator_suspend_prepare() before s3c_pm_check_prepare() as suggested
   by Doug Anderson.
 - Added Lee Jones to cc list since there is a change for the mfd framework.

Javier Martinez Canillas (2):
  Revert "mfd: sec-core: Prepare regulators for suspend state to reduce
    power-consumption"
  ARM: EXYNOS: Call regulator core suspend prepare and finish functions

 arch/arm/mach-exynos/suspend.c | 23 +++++++++++++++++++++++
 drivers/mfd/Kconfig            |  1 -
 drivers/mfd/sec-core.c         | 10 ----------
 3 files changed, 23 insertions(+), 11 deletions(-)

-- 
2.1.0

