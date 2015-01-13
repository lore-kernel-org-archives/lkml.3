Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbbAMWco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 17:32:44 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:44701 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347AbbAMWcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 17:32:43 -0500
From: Mark Salyzyn <salyzyn@android.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Salyzyn <salyzyn@android.com>, Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>, Kees Cook <keescook@chromium.org>,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH v2 2/5] pstore: remove superfluous memory size check
Date: Tue, 13 Jan 2015 14:32:35 -0800
Message-Id: <1421188358-1578-1-git-send-email-salyzyn@android.com>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All previous checks will fail with error if memory size
is not sufficient to register a zone, so this legacy
check has become redundant.

Signed-off-by: Mark Salyzyn <salyzyn@android.com>
Acked-by: Kees Cook <keescook@chromium.org>
---
v2: renumber pmsg series dependencies

 fs/pstore/ram.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 8613e5b..34ed8f8 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -474,14 +474,6 @@ static int ramoops_probe(struct platform_device *pdev)
 	if (err)
 		goto fail_init_fprz;
 
-	if (!cxt->przs && !cxt->cprz && !cxt->fprz) {
-		pr_err("memory size too small, minimum is %zu\n",
-			cxt->console_size + cxt->record_size +
-			cxt->ftrace_size);
-		err = -EINVAL;
-		goto fail_cnt;
-	}
-
 	cxt->pstore.data = cxt;
 	/*
 	 * Console can handle any buffer size, so prefer LOG_LINE_MAX. If we
@@ -525,7 +517,6 @@ fail_buf:
 	kfree(cxt->pstore.buf);
 fail_clear:
 	cxt->pstore.bufsize = 0;
-fail_cnt:
 	kfree(cxt->fprz);
 fail_init_fprz:
 	kfree(cxt->cprz);
-- 
2.2.0.rc0.207.ga3a616c

