Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016Ab3LSNBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 08:01:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44576 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215Ab3LSL4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:56:16 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiri Pirko <jiri@resnulli.us>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 040/208] team: fix master carrier set when user linkup is enabled
Date: Thu, 19 Dec 2013 11:52:18 +0000
Message-Id: <1387454106-19326-41-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Pirko <jiri@resnulli.us>

commit f5e0d34382e18f396d7673a84df8e3342bea7eb6 upstream.

When user linkup is enabled and user sets linkup of individual port,
we need to recompute linkup (carrier) of master interface so the change
is reflected. Fix this by calling __team_carrier_check() which does the
needed work.

Please apply to all stable kernels as well. Thanks.

Reported-by: Jan Tluka <jtluka@redhat.com>
Signed-off-by: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/team/team.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index bff7e0b..8aa3540 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1235,6 +1235,8 @@ static int team_user_linkup_option_get(struct team *team,
 	return 0;
 }
 
+static void __team_carrier_check(struct team *team);
+
 static int team_user_linkup_option_set(struct team *team,
 				       struct team_gsetter_ctx *ctx)
 {
@@ -1242,6 +1244,7 @@ static int team_user_linkup_option_set(struct team *team,
 
 	port->user.linkup = ctx->data.bool_val;
 	team_refresh_port_linkup(port);
+	__team_carrier_check(port->team);
 	return 0;
 }
 
@@ -1261,6 +1264,7 @@ static int team_user_linkup_en_option_set(struct team *team,
 
 	port->user.linkup_enabled = ctx->data.bool_val;
 	team_refresh_port_linkup(port);
+	__team_carrier_check(port->team);
 	return 0;
 }
 
-- 
1.8.3.2

