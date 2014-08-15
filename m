Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494AbaHOJ1l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 05:27:41 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:43539 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaHOJ10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 05:27:26 -0400
From: Zhu Yanjun <zyjzyj2000@gmail.com>
X-Google-Original-From: Zhu Yanjun <Yanjun.Zhu@windriver.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, vyasevich@gmail.com,
        tuexen@fh-muenster.de, khandelwal.deepak.1987@gmail.com,
        Yue.Tao@windriver.com, alexandre.dietsch@windriver.com,
        davem@davemloft.net, zyjzyj2000@gmail.com
Cc: Zhu Yanjun <Yanjun.Zhu@windriver.com>
Subject: [PATCH 1/1] sctp: not send SCTP_PEER_ADDR_CHANGE notifications with failed probe
Date: Fri, 15 Aug 2014 17:27:00 +0800
Message-Id: <1408094820-11725-2-git-send-email-Yanjun.Zhu@windriver.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408094820-11725-1-git-send-email-Yanjun.Zhu@windriver.com>
References: <1408094820-11725-1-git-send-email-Yanjun.Zhu@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a failed probe comes along UNCONFIRMED path, it is not necessary
to send SCTP_PEER_ADDR_CHANGE notification.

Reported-by: DEEPAK KHANDELWAL <khandelwal.deepak.1987@gmail.com>  
Suggested-by: Vlad Yasevich <vyasevich@gmail.com> 
Suggested-by: Michael Tuexen <tuexen@fh-muenster.de>
Signed-off-by: Zhu Yanjun <Yanjun.Zhu@windriver.com>
---
 net/sctp/associola.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 9de23a2..2e23f6b 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -813,6 +813,7 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
 		else {
 			dst_release(transport->dst);
 			transport->dst = NULL;
+			ulp_notify = false;
 		}
 
 		spc_state = SCTP_ADDR_UNREACHABLE;
-- 
1.9.1

