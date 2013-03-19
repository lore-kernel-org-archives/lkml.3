Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933361Ab3CSQwV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 12:52:21 -0400
Received: from mail-qe0-f73.google.com ([209.85.128.73]:46768 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933037Ab3CSQwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 12:52:17 -0400
From: Doug Anderson <dianders@chromium.org>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Jongpill Lee <boyko.lee@samsung.com>, Jaecheol Lee <jc.lee@samsung.com>,
        Thomas Abraham <thomas.ab@samsung.com>,
        Olof Johansson <olof@lixom.net>,
        Jonathan Kliegman <kliegs@chromium.org>,
        Michael Spang <spang@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/2] These two patches to s3c_pm_arch_prepare_irqs() were part of the work
Date: Tue, 19 Mar 2013 09:51:38 -0700
Message-Id: <1363711900-25560-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

to make suspend/resume reliable on the ARM Chromebook
(exynos5250-snow).

A few more details:
- The first patch is not strictly needed but was a nice cleanup.  Our
  understanding was that EINT0 was originally turned on for exynos
  evt0 silicon and not needed for evt1.
- The second patch is more important and (also) more obvious.  The
  function was modifying the S5P_WAKEUP_MASK register and then
  clobbering its own modifications.

For some history, see:
- https://gerrit.chromium.org/gerrit/31337
- https://gerrit.chromium.org/gerrit/31341


Jonathan Kliegman (2):
  arm: exynos: Remove hardcode wakeup unmask for EINT_0
  arm: exynos: Clear ENABLE_WAKEUP_SW bit when entering suspend

 arch/arm/mach-exynos/include/mach/pm-core.h | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

-- 
1.8.1.3

