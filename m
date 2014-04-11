Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423099AbaDKQ6b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:58:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56497 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422741AbaDKQIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:08:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Erik Hugne <erik.hugne@ericsson.com>,
        Jon Maloy <jon.maloy@ericsson.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.13 09/65] tipc: dont log disabled tasklet handler errors
Date: Fri, 11 Apr 2014 09:10:41 -0700
Message-Id: <20140411160959.014441260@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140411160957.714773410@linuxfoundation.org>
References: <20140411160957.714773410@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Erik Hugne <erik.hugne@ericsson.com>

[ Upstream commit 2892505ea170094f982516bb38105eac45f274b1 ]

Failure to schedule a TIPC tasklet with tipc_k_signal because the
tasklet handler is disabled is not an error. It means TIPC is
currently in the process of shutting down. We remove the error
logging in this case.

Signed-off-by: Erik Hugne <erik.hugne@ericsson.com>
Reviewed-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/handler.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/tipc/handler.c
+++ b/net/tipc/handler.c
@@ -58,7 +58,6 @@ unsigned int tipc_k_signal(Handler routi
 
 	spin_lock_bh(&qitem_lock);
 	if (!handler_enabled) {
-		pr_err("Signal request ignored by handler\n");
 		spin_unlock_bh(&qitem_lock);
 		return -ENOPROTOOPT;
 	}


