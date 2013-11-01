Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224Ab3KAWel (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:34:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55003 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165Ab3KAWEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:04:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vlad Yasevich <vyasevic@redhat.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Veaceslav Falico <vfalico@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 27/54] bridge: Correctly clamp MAX forward_delay when enabling STP
Date: Fri,  1 Nov 2013 15:03:55 -0700
Message-Id: <20131101220214.374893230@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131101220211.311926234@linuxfoundation.org>
References: <20131101220211.311926234@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Yasevich <vyasevic@redhat.com>

[ Upstream commit 4b6c7879d84ad06a2ac5b964808ed599187a188d ]

Commit be4f154d5ef0ca147ab6bcd38857a774133f5450
	bridge: Clamp forward_delay when enabling STP
had a typo when attempting to clamp maximum forward delay.

It is possible to set bridge_forward_delay to be higher then
permitted maximum when STP is off.  When turning STP on, the
higher then allowed delay has to be clamed down to max value.

Signed-off-by: Vlad Yasevich <vyasevic@redhat.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: Stephen Hemminger <shemminger@vyatta.com>
Reviewed-by: Veaceslav Falico <vfalico@redhat.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_stp_if.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bridge/br_stp_if.c
+++ b/net/bridge/br_stp_if.c
@@ -134,7 +134,7 @@ static void br_stp_start(struct net_brid
 
 	if (br->bridge_forward_delay < BR_MIN_FORWARD_DELAY)
 		__br_set_forward_delay(br, BR_MIN_FORWARD_DELAY);
-	else if (br->bridge_forward_delay < BR_MAX_FORWARD_DELAY)
+	else if (br->bridge_forward_delay > BR_MAX_FORWARD_DELAY)
 		__br_set_forward_delay(br, BR_MAX_FORWARD_DELAY);
 
 	if (r == 0) {


