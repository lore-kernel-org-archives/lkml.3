Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446AbaH1Ty1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 15:54:27 -0400
Received: from mx02.posteo.de ([89.146.194.165]:53878 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbaH1Ty0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 15:54:26 -0400
From: Mario Schlegel <m.schlegel@posteo.de>
To: gregkh@linuxfoundation.org
Cc: green@linuxhacker.ru, andreas.dilger@intel.com, john.hammond@intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: lustre: osc: add blank line after declarations
Date: Thu, 28 Aug 2014 21:54:18 +0200
Message-Id: <1409255658-20019-1-git-send-email-m.schlegel@posteo.de>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed a coding style issue

Signed-off-by: Mario Schlegel <m.schlegel@posteo.de>
---
 drivers/staging/lustre/lustre/osc/osc_io.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/lustre/lustre/osc/osc_io.c b/drivers/staging/lustre/lustre/osc/osc_io.c
index 886b1ef..fad4c13 100644
--- a/drivers/staging/lustre/lustre/osc/osc_io.c
+++ b/drivers/staging/lustre/lustre/osc/osc_io.c
@@ -63,6 +63,7 @@ static struct osc_io *cl2osc_io(const struct lu_env *env,
 				const struct cl_io_slice *slice)
 {
 	struct osc_io *oio = container_of0(slice, struct osc_io, oi_cl);
+
 	LINVRNT(oio == osc_env_io(env));
 	return oio;
 }
@@ -360,6 +361,7 @@ static int trunc_check_cb(const struct lu_env *env, struct cl_io *io,
 
 	{
 		struct page *vmpage = cl_page_vmpage(env, page);
+
 		if (PageLocked(vmpage))
 			CDEBUG(D_CACHE, "page %p index %lu locked for %d.\n",
 			       ops, page->cp_index,
@@ -498,6 +500,7 @@ static void osc_io_setattr_end(const struct lu_env *env,
 
 	if (cl_io_is_trunc(io)) {
 		__u64 size = io->u.ci_setattr.sa_attr.lvb_size;
+
 		osc_trunc_check(env, io, oio, size);
 		if (oio->oi_trunc != NULL) {
 			osc_cache_truncate_end(env, oio, cl2osc(obj));
-- 
2.1.0

