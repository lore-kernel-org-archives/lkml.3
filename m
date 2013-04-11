Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211Ab3DKU1W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:27:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28406 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924Ab3DKU0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:26:23 -0400
X-Authority-Analysis: v=2.0 cv=aOZyWMBm c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=VMoV8ZE0el8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KRV2VWv1AFIA:10 a=t7CeM3EgAAAA:8 a=vmLDa1wCAAAA:8 a=pGLkceISAAAA:8 a=J1Y8HTJGAAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=2e6ZYRoF4I4A:10 a=gv_BBZfBKR8A:10 a=MSl-tDqOz04A:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202548.072043166@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Xufeng Zhang <xufeng.zhang@windriver.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 011/171 ] sctp: dont break the loop while meeting the active_path so as to
 find the matched transport
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0011-sctp-don-t-break-the-loop-while-meeting-the-active_p.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Xufeng Zhang <xufeng.zhang@windriver.com>

[ Upstream commit 2317f449af30073cfa6ec8352e4a65a89e357bdd ]

sctp_assoc_lookup_tsn() function searchs which transport a certain TSN
was sent on, if not found in the active_path transport, then go search
all the other transports in the peer's transport_addr_list, however, we
should continue to the next entry rather than break the loop when meet
the active_path transport.

Signed-off-by: Xufeng Zhang <xufeng.zhang@windriver.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Acked-by: Vlad Yasevich <vyasevich@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/sctp/associola.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index ebaef3e..247abb9 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1074,7 +1074,7 @@ struct sctp_transport *sctp_assoc_lookup_tsn(struct sctp_association *asoc,
 			transports) {
 
 		if (transport == active)
-			break;
+			continue;
 		list_for_each_entry(chunk, &transport->transmitted,
 				transmitted_list) {
 			if (key == chunk->subh.data_hdr->tsn) {
-- 
1.7.10.4


