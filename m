Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526Ab3CRDMz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 23:12:55 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59008 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab3CRDMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 23:12:52 -0400
MIME-Version: 1.0
Date: Mon, 18 Mar 2013 11:12:51 +0800
Message-ID: <CAPgLHd8Uj4-OWahuXSMxcb4Z3siukbveTm=bWNO1toatPwwcmg@mail.gmail.com>
Subject: [PATCH -next] UBIFS: fix missing unlock on error in ubifs_remount_rw()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: dedekind1@gmail.com, adrian.hunter@intel.com
Cc: yongjun_wei@trendmicro.com.cn, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add the missing unlock before return from function ubifs_remount_rw()
in the error handling case.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 fs/ubifs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index f21acf0..9791b3c 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1571,7 +1571,7 @@ static int ubifs_remount_rw(struct ubifs_info *c)
 	if (c->space_fixup) {
 		err = ubifs_fixup_free_space(c);
 		if (err)
-			return err;
+			goto out;
 	}
 
 	err = check_free_space(c);

