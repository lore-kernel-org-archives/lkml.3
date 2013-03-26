Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965376Ab3CZPfK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:35:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54086 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965324Ab3CZPXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:23:42 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Torsten Duwe <duwe@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 120/150] KMS: fix EDID detailed timing frame rate
Date: Tue, 26 Mar 2013 15:20:19 +0000
Message-Id: <1364311249-14454-121-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Torsten Duwe <torsten@lst.de>

commit c19b3b0f6eed552952845e4ad908dba2113d67b4 upstream.

When KMS has parsed an EDID "detailed timing", it leaves the frame rate
zeroed.  Consecutive (debug-) output of that mode thus yields 0 for
vsync.  This simple fix also speeds up future invocations of
drm_mode_vrefresh().

While it is debatable whether this qualifies as a -stable fix I'd apply
it for consistency's sake; drm_helper_probe_single_connector_modes()
does the same thing already for all probed modes.

Signed-off-by: Torsten Duwe <duwe@lst.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/drm_edid.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index f689958..c674823 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -957,6 +957,7 @@ set_size:
 	}
 
 	mode->type = DRM_MODE_TYPE_DRIVER;
+	mode->vrefresh = drm_mode_vrefresh(mode);
 	drm_mode_set_name(mode);
 
 	return mode;
-- 
1.8.1.2

