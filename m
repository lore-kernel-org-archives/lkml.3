Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab3KVCn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 21:43:26 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:62242 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136Ab3KVCnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 21:43:22 -0500
MIME-Version: 1.0
Date: Fri, 22 Nov 2013 10:43:20 +0800
Message-ID: <CAPgLHd9uPqx0fY7DQp2gWESb-yUZraWh7tpdMW6ao2Bq=DwYCA@mail.gmail.com>
Subject: [PATCH -next] ocfs2: fix sparse non static symbol warning
From: Wei Yongjun <weiyj.lk@gmail.com>
To: mfasheh@suse.com, jlbec@evilplan.org
Cc: yongjun_wei@trendmicro.com.cn, ocfs2-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fixes the following sparse warning:

fs/ocfs2/stack_user.c:930:32: warning:
 symbol 'ocfs2_ls_ops' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 fs/ocfs2/stack_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index eca3f93..9b18f4e 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -927,7 +927,7 @@ static void user_recover_done(void *arg, struct dlm_slot *slots,
 	wake_up(&lc->oc_wait);
 }
 
-const struct dlm_lockspace_ops ocfs2_ls_ops = {
+static const struct dlm_lockspace_ops ocfs2_ls_ops = {
 	.recover_prep = user_recover_prep,
 	.recover_slot = user_recover_slot,
 	.recover_done = user_recover_done,

