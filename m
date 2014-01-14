Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbaANAjl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:39:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54417 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926AbaANA2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:28:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Fan Du <fan.du@windriver.com>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 17/77] vxlan: release rt when found circular route
Date: Mon, 13 Jan 2014 16:27:38 -0800
Message-Id: <20140114002752.989605355@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002752.497010554@linuxfoundation.org>
References: <20140114002752.497010554@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Du <fan.du@windriver.com>

[ Upstream commit fffc15a5012e9052d3b236efc56840841a125416 ]

Otherwise causing dst memory leakage.
Have Checked all other type tunnel device transmit implementation,
no such things happens anymore.

Signed-off-by: Fan Du <fan.du@windriver.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -1672,7 +1672,7 @@ static void vxlan_xmit_one(struct sk_buf
 			netdev_dbg(dev, "circular route to %pI4\n",
 				   &dst->sin.sin_addr.s_addr);
 			dev->stats.collisions++;
-			goto tx_error;
+			goto rt_tx_error;
 		}
 
 		/* Bypass encapsulation if the destination is local */


