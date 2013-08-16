Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477Ab3HPWlE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:41:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51860 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756389Ab3HPWk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:40:59 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 070/133] drm/radeon/atom: initialize more atom interpretor elements to 0
Date: Fri, 16 Aug 2013 15:33:32 -0700
Message-Id: <1376692475-28413-71-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 42a21826dc54583cdb79cc8477732e911ac9c376 upstream.

The ProcessAuxChannel table on some rv635 boards assumes
the divmul members are initialized to 0 otherwise we get
an invalid fb offset since it has a bad mask set when
setting the fb base.  While here initialize all the
atom interpretor elements to 0.

Fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=60639

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/atom.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/radeon/atom.c b/drivers/gpu/drm/radeon/atom.c
index 43672b6..daa1e34 100644
--- a/drivers/gpu/drm/radeon/atom.c
+++ b/drivers/gpu/drm/radeon/atom.c
@@ -1222,12 +1222,17 @@ int atom_execute_table(struct atom_context *ctx, int index, uint32_t * params)
 	int r;
 
 	mutex_lock(&ctx->mutex);
+	/* reset data block */
+	ctx->data_block = 0;
 	/* reset reg block */
 	ctx->reg_block = 0;
 	/* reset fb window */
 	ctx->fb_base = 0;
 	/* reset io mode */
 	ctx->io_mode = ATOM_IO_MM;
+	/* reset divmul */
+	ctx->divmul[0] = 0;
+	ctx->divmul[1] = 0;
 	r = atom_execute_table_locked(ctx, index, params);
 	mutex_unlock(&ctx->mutex);
 	return r;
-- 
1.8.1.2

