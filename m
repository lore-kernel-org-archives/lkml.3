Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965457Ab3CZPYL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:24:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54174 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965439Ab3CZPYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:24:06 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Xufeng Zhang <xufeng.zhang@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 139/150] sctp: don't break the loop while meeting the active_path so as to find the matched transport
Date: Tue, 26 Mar 2013 15:20:38 +0000
Message-Id: <1364311249-14454-140-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xufeng Zhang <xufeng.zhang@windriver.com>

commit 2317f449af30073cfa6ec8352e4a65a89e357bdd upstream.

sctp_assoc_lookup_tsn() function searchs which transport a certain TSN
was sent on, if not found in the active_path transport, then go search
all the other transports in the peer's transport_addr_list, however, we
should continue to the next entry rather than break the loop when meet
the active_path transport.

Signed-off-by: Xufeng Zhang <xufeng.zhang@windriver.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Acked-by: Vlad Yasevich <vyasevich@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/sctp/associola.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index b16517e..a4bfaa1 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1051,7 +1051,7 @@ struct sctp_transport *sctp_assoc_lookup_tsn(struct sctp_association *asoc,
 			transports) {
 
 		if (transport == active)
-			break;
+			continue;
 		list_for_each_entry(chunk, &transport->transmitted,
 				transmitted_list) {
 			if (key == chunk->subh.data_hdr->tsn) {
-- 
1.8.1.2

