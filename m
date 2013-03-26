Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab3CZRjY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:39:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31047 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754347Ab3CZRge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:34 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=lUpsUe8tFxsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=y6LpG6CRC4AA:10 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=J1Y8HTJGAAAA:8 a=GZK3lcuhIWR5GrNAc6YA:9 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173609.642256748@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:22:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Vlad Yasevich <vyasevich@gmail.com>, Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 61/86] sctp: jsctp_sf_eat_sack: fix jprobes function signature mismatch
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0061-sctp-jsctp_sf_eat_sack-fix-jprobes-function-signatur.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <dborkman@redhat.com>

[ Upstream commit c5b1825fa547eb475ca8936f6f346c18b1ece298 ]

Commit 24cb81a6a (sctp: Push struct net down into all of the
state machine functions) introduced the net structure into all
state machine functions, but jsctp_sf_eat_sack was not updated,
hence when SCTP association probing is enabled in the kernel,
any simple SCTP client/server program from userspace will panic
the kernel.

Cc: Vlad Yasevich <vyasevich@gmail.com>
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Acked-by: Vlad Yasevich <vyasevich@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/sctp/probe.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sctp/probe.c b/net/sctp/probe.c
index bc6cd75..5f7518d 100644
--- a/net/sctp/probe.c
+++ b/net/sctp/probe.c
@@ -122,7 +122,8 @@ static const struct file_operations sctpprobe_fops = {
 	.llseek = noop_llseek,
 };
 
-sctp_disposition_t jsctp_sf_eat_sack(const struct sctp_endpoint *ep,
+sctp_disposition_t jsctp_sf_eat_sack(struct net *net,
+				     const struct sctp_endpoint *ep,
 				     const struct sctp_association *asoc,
 				     const sctp_subtype_t type,
 				     void *arg,
-- 
1.7.10.4


