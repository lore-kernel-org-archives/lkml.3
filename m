Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbaBUMtj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:49:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46788 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755737AbaBUMtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:49:36 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Airlie <airlied@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 020/121] drm/mgag200: fix typo causing bw limits to be ignored on some chips
Date: Fri, 21 Feb 2014 12:47:24 +0000
Message-Id: <1392986945-9693-21-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit ec22b4aa993abbd18f5bbbcb20a1c56be3b1d38b upstream.

mode->mdev otherwise the bw limits never kick in.

Reported in RHEL testing.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/mgag200/mgag200_mode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/mgag200/mgag200_mode.c b/drivers/gpu/drm/mgag200/mgag200_mode.c
index 503a414..1288cd9 100644
--- a/drivers/gpu/drm/mgag200/mgag200_mode.c
+++ b/drivers/gpu/drm/mgag200/mgag200_mode.c
@@ -1521,11 +1521,11 @@ static int mga_vga_mode_valid(struct drm_connector *connector,
 		(mga_vga_calculate_mode_bandwidth(mode, bpp)
 			> (32700 * 1024))) {
 		return MODE_BANDWIDTH;
-	} else if (mode->type == G200_EH &&
+	} else if (mdev->type == G200_EH &&
 		(mga_vga_calculate_mode_bandwidth(mode, bpp)
 			> (37500 * 1024))) {
 		return MODE_BANDWIDTH;
-	} else if (mode->type == G200_ER &&
+	} else if (mdev->type == G200_ER &&
 		(mga_vga_calculate_mode_bandwidth(mode,
 			bpp) > (55000 * 1024))) {
 		return MODE_BANDWIDTH;
-- 
1.9.0

