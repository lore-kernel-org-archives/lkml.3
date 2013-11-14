Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab3KNQtE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:49:04 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:38792 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243Ab3KNQoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:44:23 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Keith Mannthey <keith.mannthey@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 14/26] staging/lustre/ptlrpc: skip rpcs that fail ptl_send_rpc
Date: Fri, 15 Nov 2013 00:43:01 +0800
Message-Id: <1384447393-13838-15-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
References: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keith Mannthey <keith.mannthey@intel.com>

ptl_send_rpc is not dealing with -ENOMEM in some
situations.  When the ptl_send_rpc fails we need
set error and skip further processing or trigger
and LBUG

Original patch from Peng Tao.

Lustre-change: http://review.whamcloud.com/7411
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3698
Signed-off-by: Keith Mannthey <keith.mannthey@intel.com>
Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
Reviewed-by: Mike Pershin <mike.pershin@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/ptlrpc/client.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/lustre/lustre/ptlrpc/client.c b/drivers/staging/lustre/lustre/ptlrpc/client.c
index 9cdee5e..81ffe5c 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/client.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/client.c
@@ -1715,6 +1715,7 @@ int ptlrpc_check_set(const struct lu_env *env, struct ptlrpc_request_set *set)
 					spin_lock(&req->rq_lock);
 					req->rq_net_err = 1;
 					spin_unlock(&req->rq_lock);
+					continue;
 				}
 				/* need to reset the timeout */
 				force_timer_recalc = 1;
-- 
1.7.9.5

