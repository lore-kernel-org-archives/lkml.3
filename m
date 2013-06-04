Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab3FDW6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:58:24 -0400
Received: from 1wt.eu ([62.212.114.60]:35726 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398Ab3FDWnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:43:24 -0400
Message-Id: <20130604172137.561062802@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:24:25 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 175/184] atm: fix info leak in getsockopt(SO_ATMPVC)
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

commit e862f1a9b7df4e8196ebec45ac62295138aa3fc2 upstream.

The ATM code fails to initialize the two padding bytes of struct
sockaddr_atmpvc inserted for alignment. Add an explicit memset(0)
before filling the structure to avoid the info leak.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 2.6.32: adjust context, indentation]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/atm/common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/atm/common.c b/net/atm/common.c
index 6c82d72..65737b8 100644
--- a/net/atm/common.c
+++ b/net/atm/common.c
@@ -751,6 +751,7 @@ int vcc_getsockopt(struct socket *sock, int level, int optname,
 				if (!vcc->dev ||
 				    !test_bit(ATM_VF_ADDR,&vcc->flags))
 					return -ENOTCONN;
+				memset(&pvc, 0, sizeof(pvc));
 				pvc.sap_family = AF_ATMPVC;
 				pvc.sap_addr.itf = vcc->dev->number;
 				pvc.sap_addr.vpi = vcc->vpi;
-- 
1.7.12.2.21.g234cd45.dirty



