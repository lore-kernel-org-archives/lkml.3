Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228Ab3HNKh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:37:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34430 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759799Ab3HNKhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:37:25 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 14/75] drm/radeon/atom: initialize more atom interpretor elements to 0
Date: Wed, 14 Aug 2013 11:36:03 +0100
Message-Id: <1376476624-10011-15-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
References: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.19 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
1.8.3.2

