Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719AbaDRJnF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:43:05 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45931 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752188AbaDRJWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:48 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Erik Hugne <erik.hugne@ericsson.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 31/72] tipc: don't log disabled tasklet handler errors
Date: Fri, 18 Apr 2014 11:22:04 +0200
Message-Id: <d80441c0019881e72774fa3f51a09997b8214a46.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erik Hugne <erik.hugne@ericsson.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 2892505ea170094f982516bb38105eac45f274b1 ]

Failure to schedule a TIPC tasklet with tipc_k_signal because the
tasklet handler is disabled is not an error. It means TIPC is
currently in the process of shutting down. We remove the error
logging in this case.

Signed-off-by: Erik Hugne <erik.hugne@ericsson.com>
Reviewed-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/tipc/handler.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/tipc/handler.c b/net/tipc/handler.c
index b36f0fcd9bdf..79b991e044a9 100644
--- a/net/tipc/handler.c
+++ b/net/tipc/handler.c
@@ -57,7 +57,6 @@ unsigned int tipc_k_signal(Handler routine, unsigned long argument)
 	struct queue_item *item;
 
 	if (!handler_enabled) {
-		pr_err("Signal request ignored by handler\n");
 		return -ENOPROTOOPT;
 	}
 
-- 
1.9.2

