Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932970AbaFJUao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:30:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35018 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730AbaFJTrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:47:14 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>, matthias.graf@st.ovqu.de,
        bp@alien8.de, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 073/160] drm/radeon: disable dpm on rv770 by default
Date: Tue, 10 Jun 2014 12:45:13 -0700
Message-Id: <1402429600-20477-74-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 76e6dcece841faebbee78895780e8209ff40d922 upstream.

There seem to be stability issues on a number of cards.

bugs:
https://bugs.freedesktop.org/show_bug.cgi?id=76286
https://bugzilla.redhat.com/show_bug.cgi?id=1085785
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=741619

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: matthias.graf@st.ovqu.de
Cc: bp@alien8.de
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_pm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_pm.c b/drivers/gpu/drm/radeon/radeon_pm.c
index 524b091..d7e631b 100644
--- a/drivers/gpu/drm/radeon/radeon_pm.c
+++ b/drivers/gpu/drm/radeon/radeon_pm.c
@@ -1230,6 +1230,7 @@ int radeon_pm_init(struct radeon_device *rdev)
 	case CHIP_RV670:
 	case CHIP_RS780:
 	case CHIP_RS880:
+	case CHIP_RV770:
 	case CHIP_BARTS:
 	case CHIP_TURKS:
 	case CHIP_CAICOS:
@@ -1250,7 +1251,6 @@ int radeon_pm_init(struct radeon_device *rdev)
 		else
 			rdev->pm.pm_method = PM_METHOD_PROFILE;
 		break;
-	case CHIP_RV770:
 	case CHIP_RV730:
 	case CHIP_RV710:
 	case CHIP_RV740:
-- 
1.9.1

