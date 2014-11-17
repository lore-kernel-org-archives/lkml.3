Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920AbaKQU6o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 15:58:44 -0500
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:50750 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752001AbaKQU6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 15:58:43 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4SAK5galRXQyyZ/2dsb2JhbABbgw6BLrhwBQF1mg8EAoEbFwEBAQEBfYQwLyOBGjeIRQHCYZBJhj6KAGQdhDUFnkyNEologUcBgjU8MIEGgUUBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        "David S. Miller" <davem@davemloft.net>, dccp@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 1/1 net-next] dccp: replace min/casting by min_t
Date: Mon, 17 Nov 2014 21:58:37 +0100
Message-Id: <1416257917-7041-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/dccp/ackvec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dccp/ackvec.c b/net/dccp/ackvec.c
index ba07824..bd9e718 100644
--- a/net/dccp/ackvec.c
+++ b/net/dccp/ackvec.c
@@ -218,7 +218,7 @@ static void dccp_ackvec_add_new(struct dccp_ackvec *av, u32 num_packets,
 		 * different underlying data structure.
 		 */
 		for (num_packets = num_cells = 1; lost_packets; ++num_cells) {
-			u8 len = min(lost_packets, (u32)DCCPAV_MAX_RUNLEN);
+			u8 len = min_t(u32, lost_packets, DCCPAV_MAX_RUNLEN);
 
 			av->av_buf_head = __ackvec_idx_sub(av->av_buf_head, 1);
 			av->av_buf[av->av_buf_head] = DCCPAV_NOT_RECEIVED | len;
-- 
1.9.3

