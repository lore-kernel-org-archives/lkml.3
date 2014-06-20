Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966406AbaFTJFw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 05:05:52 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:60658 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965860AbaFTJFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 05:05:50 -0400
From: Sachin Kamat <sachin.kamat@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, andreas.noever@gmail.com, spk.linux@gmail.com
Subject: [PATCH 3/6] thunderbolt: Use NULL instead of 0 in switch.c
Date: Fri, 20 Jun 2014 14:32:31 +0530
Message-Id: <1403254954-14429-3-git-send-email-sachin.kamat@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403254954-14429-1-git-send-email-sachin.kamat@samsung.com>
References: <1403254954-14429-1-git-send-email-sachin.kamat@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function returns a pointer. Hence return NULL instead of 0.

Signed-off-by: Sachin Kamat <sachin.kamat@samsung.com>
---
 drivers/thunderbolt/switch.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/thunderbolt/switch.c b/drivers/thunderbolt/switch.c
index 26e76e4aa835..aeb982969629 100644
--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -260,11 +260,11 @@ struct tb_switch *get_switch_at_route(struct tb_switch *sw, u64 route)
 	if (route == 0)
 		return sw;
 	if (next_port > sw->config.max_port_number)
-		return 0;
+		return NULL;
 	if (tb_is_upstream_port(&sw->ports[next_port]))
-		return 0;
+		return NULL;
 	if (!sw->ports[next_port].remote)
-		return 0;
+		return NULL;
 	return get_switch_at_route(sw->ports[next_port].remote->sw,
 				   route >> TB_ROUTE_SHIFT);
 }
-- 
1.7.9.5

