Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776Ab3IKFYt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:24:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32814 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744Ab3IKE50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:26 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=6v3lcRCgyHgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=U8iOyFITau0A:10 a=zd2uoN0lAAAA:8 a=VwQbUJbxAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=wu_e27o_rKQA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042911.092514104@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:29:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Alex Deucher <alexander.deucher@amd.com>
Subject: [113/251] drm/radeon/atom: initialize more atom interpretor elements to 0
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0113-drm-radeon-atom-initialize-more-atom-interpretor-ele.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 42a21826dc54583cdb79cc8477732e911ac9c376 ]

The ProcessAuxChannel table on some rv635 boards assumes
the divmul members are initialized to 0 otherwise we get
an invalid fb offset since it has a bad mask set when
setting the fb base.  While here initialize all the
atom interpretor elements to 0.

Fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=60639

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/radeon/atom.c |    5 +++++
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
1.7.10.4


