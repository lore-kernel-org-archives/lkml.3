Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759218Ab3IHDTu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:19:50 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56108 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755982Ab3IHDSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:46 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Alex Deucher" <alexander.deucher@amd.com>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.644794477@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [051/121] drm/radeon/atom: initialize more atom interpretor
 elements to 0
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/atom.c | 5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/radeon/atom.c
+++ b/drivers/gpu/drm/radeon/atom.c
@@ -1220,12 +1220,17 @@ int atom_execute_table(struct atom_conte
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

