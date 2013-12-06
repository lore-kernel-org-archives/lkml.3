Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161676Ab3LFWKE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:10:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60977 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759412Ab3LFVxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:53:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Tluka <jtluka@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 37/58] team: fix master carrier set when user linkup is enabled
Date: Fri,  6 Dec 2013 13:52:08 -0800
Message-Id: <20131206214848.339105976@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214844.906193530@linuxfoundation.org>
References: <20131206214844.906193530@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Pirko <jiri@resnulli.us>

[ Upstream commit f5e0d34382e18f396d7673a84df8e3342bea7eb6 ]

When user linkup is enabled and user sets linkup of individual port,
we need to recompute linkup (carrier) of master interface so the change
is reflected. Fix this by calling __team_carrier_check() which does the
needed work.

Please apply to all stable kernels as well. Thanks.

Reported-by: Jan Tluka <jtluka@redhat.com>
Signed-off-by: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/team/team.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1217,6 +1217,8 @@ static int team_user_linkup_option_get(s
 	return 0;
 }
 
+static void __team_carrier_check(struct team *team);
+
 static int team_user_linkup_option_set(struct team *team,
 				       struct team_gsetter_ctx *ctx)
 {
@@ -1224,6 +1226,7 @@ static int team_user_linkup_option_set(s
 
 	port->user.linkup = ctx->data.bool_val;
 	team_refresh_port_linkup(port);
+	__team_carrier_check(port->team);
 	return 0;
 }
 
@@ -1243,6 +1246,7 @@ static int team_user_linkup_en_option_se
 
 	port->user.linkup_enabled = ctx->data.bool_val;
 	team_refresh_port_linkup(port);
+	__team_carrier_check(port->team);
 	return 0;
 }
 


