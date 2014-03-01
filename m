Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbaCACS6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 21:18:58 -0500
Received: from linuxhacker.ru ([217.76.32.60]:42618 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753044AbaCACRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 21:17:25 -0500
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Peng Tao <bergwolf@gmail.com>, Keith Mannthey <keith.mannthey@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 12/17] lustre/ptlrpc: skip rpcs that fail ptl_send_rpc
Date: Fri, 28 Feb 2014 21:16:41 -0500
Message-Id: <1393640206-20286-13-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393640206-20286-1-git-send-email-green@linuxhacker.ru>
References: <1393640206-20286-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peng Tao <bergwolf@gmail.com>

ptl_send_rpc is not dealing with -ENOMEM in some
situations.  When the ptl_send_rpc fails we need
set error and skip further processing or trigger
and LBUG

Signed-off-by: Keith Mannthey <keith.mannthey@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Reviewed-on: http://review.whamcloud.com/7411
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3698
Reviewed-by: Mike Pershin <mike.pershin@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/ptlrpc/client.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/lustre/lustre/ptlrpc/client.c b/drivers/staging/lustre/lustre/ptlrpc/client.c
index b6d831a..98041e8 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/client.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/client.c
@@ -1692,6 +1692,7 @@ int ptlrpc_check_set(const struct lu_env *env, struct ptlrpc_request_set *set)
 					spin_lock(&req->rq_lock);
 					req->rq_net_err = 1;
 					spin_unlock(&req->rq_lock);
+					continue;
 				}
 				/* need to reset the timeout */
 				force_timer_recalc = 1;
-- 
1.8.5.3

