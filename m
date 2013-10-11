Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab3JKTfb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:35:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45068 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab3JKTf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:35:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Healy <cphealy@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 07/39] resubmit bridge: fix message_age_timer calculation
Date: Fri, 11 Oct 2013 12:34:51 -0700
Message-Id: <20131011193211.684991682@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193210.843963685@linuxfoundation.org>
References: <20131011193210.843963685@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Healy <cphealy@gmail.com>

[ Upstream commit 9a0620133ccce9dd35c00a96405c8d80938c2cc0 ]

This changes the message_age_timer calculation to use the BPDU's max age as
opposed to the local bridge's max age.  This is in accordance with section
8.6.2.3.2 Step 2 of the 802.1D-1998 sprecification.

With the current implementation, when running with very large bridge
diameters, convergance will not always occur even if a root bridge is
configured to have a longer max age.

Tested successfully on bridge diameters of ~200.

Signed-off-by: Chris Healy <cphealy@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_stp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bridge/br_stp.c
+++ b/net/bridge/br_stp.c
@@ -191,7 +191,7 @@ static inline void br_record_config_info
 	p->designated_age = jiffies + bpdu->message_age;
 
 	mod_timer(&p->message_age_timer, jiffies
-		  + (p->br->max_age - bpdu->message_age));
+		  + (bpdu->max_age - bpdu->message_age));
 }
 
 /* called under bridge lock */


