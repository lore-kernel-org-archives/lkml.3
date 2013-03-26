Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab3CZXB6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:01:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53340 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244Ab3CZXB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 19:01:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Xufeng Zhang <xufeng.zhang@windriver.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 05/49] sctp: dont break the loop while meeting the active_path so as to find the matched transport
Date: Tue, 26 Mar 2013 16:01:02 -0700
Message-Id: <20130326225840.143093369@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326225839.554028294@linuxfoundation.org>
References: <20130326225839.554028294@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/associola.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1043,7 +1043,7 @@ struct sctp_transport *sctp_assoc_lookup
 			transports) {
 
 		if (transport == active)
-			break;
+			continue;
 		list_for_each_entry(chunk, &transport->transmitted,
 				transmitted_list) {
 			if (key == chunk->subh.data_hdr->tsn) {


