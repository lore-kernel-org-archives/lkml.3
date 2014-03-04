Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757716AbaCDVZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:25:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40942 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756055AbaCDUDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:03:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Antonio Quartulli <antonio@meshcoding.com>,
        Marek Lindner <mareklindner@neomailbox.ch>
Subject: [PATCH 3.13 066/172] batman-adv: properly check pskb_may_pull return value
Date: Tue,  4 Mar 2014 12:02:30 -0800
Message-Id: <20140304200301.849227524@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antonio Quartulli <antonio@meshcoding.com>

[ Upstream commit f1791425cf0bcda43ab9a9a37df1ad3ccb1f6654 ]

pskb_may_pull() returns 1 on success and 0 in case of failure,
therefore checking for the return value being negative does
not make sense at all.

This way if the function fails we will probably read beyond the current
skb data buffer. Fix this by doing the proper check.

Signed-off-by: Antonio Quartulli <antonio@meshcoding.com>
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/routing.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/batman-adv/routing.c
+++ b/net/batman-adv/routing.c
@@ -833,7 +833,7 @@ static int batadv_check_unicast_ttvn(str
 	int is_old_ttvn;
 
 	/* check if there is enough data before accessing it */
-	if (pskb_may_pull(skb, hdr_len + ETH_HLEN) < 0)
+	if (!pskb_may_pull(skb, hdr_len + ETH_HLEN))
 		return 0;
 
 	/* create a copy of the skb (in case of for re-routing) to modify it. */


