Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932736Ab3KHCdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:33:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34648 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932364Ab3KHCS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:18:28 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Vlad Yasevich <vyasevic@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 31/91] bridge: Correctly clamp MAX forward_delay when enabling STP
Date: Thu,  7 Nov 2013 18:14:46 -0800
Message-Id: <1383876946-2396-32-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Yasevich <vyasevic@redhat.com>

[ Upstream commit 4b6c7879d84ad06a2ac5b964808ed599187a188d ]

Commit be4f154d5ef0ca147ab6bcd38857a774133f5450
	bridge: Clamp forward_delay when enabling STP
had a typo when attempting to clamp maximum forward delay.

It is possible to set bridge_forward_delay to be higher then
permitted maximum when STP is off.  When turning STP on, the
higher then allowed delay has to be clamed down to max value.

CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: Vlad Yasevich <vyasevic@redhat.com>
Reviewed-by: Veaceslav Falico <vfalico@redhat.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/bridge/br_stp_if.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_stp_if.c b/net/bridge/br_stp_if.c
index 7ba2ed5..5bb38cd 100644
--- a/net/bridge/br_stp_if.c
+++ b/net/bridge/br_stp_if.c
@@ -134,7 +134,7 @@ static void br_stp_start(struct net_bridge *br)
 
 	if (br->bridge_forward_delay < BR_MIN_FORWARD_DELAY)
 		__br_set_forward_delay(br, BR_MIN_FORWARD_DELAY);
-	else if (br->bridge_forward_delay < BR_MAX_FORWARD_DELAY)
+	else if (br->bridge_forward_delay > BR_MAX_FORWARD_DELAY)
 		__br_set_forward_delay(br, BR_MAX_FORWARD_DELAY);
 
 	if (r == 0) {
-- 
1.8.1.2

