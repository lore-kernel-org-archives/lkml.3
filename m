Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637Ab3HNFFR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 01:05:17 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:55169 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab3HNFFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 01:05:15 -0400
Message-ID: <520B0FCF.5080809@huawei.com>
Date: Wed, 14 Aug 2013 13:04:15 +0800
From: Rui Xiang <rui.xiang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <oleg@redhat.com>, <luto@amacapital.net>
Subject: [PATCH] userns: initialize the depth of user_namespace chain
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.188]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The level of init_user_ns shoule be 1.

Signed-off-by: Rui Xiang <rui.xiang@huawei.com>
---
 kernel/user.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/user.c b/kernel/user.c
index 69b4c3d..32da187 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -48,6 +48,7 @@ struct user_namespace init_user_ns = {
 		},
 	},
 	.count = ATOMIC_INIT(3),
+	.level = 1,
 	.owner = GLOBAL_ROOT_UID,
 	.group = GLOBAL_ROOT_GID,
 	.proc_inum = PROC_USER_INIT_INO,
-- 
1.8.2.2

