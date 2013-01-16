Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072Ab3APQ0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:26:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36682 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932576Ab3APQIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:08:23 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 169/222] drm/radeon: add WAIT_UNTIL to evergreen VM safe reg list
Date: Wed, 16 Jan 2013 13:56:09 -0200
Message-Id: <1358351822-7675-170-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 668bbc81baf0f34df832d8aca5c7d5e19a493c68 upstream.

It's used in a recent mesa commit:
http://cgit.freedesktop.org/mesa/mesa/commit/?id=24b1206ab2dcd506aaac3ef656aebc8bc20cd27a
and there may be some other cases in the future where it's required.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/radeon/evergreen_cs.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/radeon/evergreen_cs.c b/drivers/gpu/drm/radeon/evergreen_cs.c
index 33aeaa5..4324c0d 100644
--- a/drivers/gpu/drm/radeon/evergreen_cs.c
+++ b/drivers/gpu/drm/radeon/evergreen_cs.c
@@ -2672,6 +2672,7 @@ static bool evergreen_vm_reg_valid(u32 reg)
 
 	/* check config regs */
 	switch (reg) {
+	case WAIT_UNTIL:
 	case GRBM_GFX_INDEX:
 	case CP_STRMOUT_CNTL:
 	case CP_COHER_CNTL:
-- 
1.7.9.5

