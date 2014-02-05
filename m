Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679AbaBEVNc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 16:13:32 -0500
Received: from mail.windriver.com ([147.11.1.11]:54255 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbaBEUDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:03:50 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 029/213] atm: fix info leak in getsockopt(SO_ATMPVC)
Date: Wed, 5 Feb 2014 14:59:44 -0500
Message-ID: <1391630568-49251-30-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathias Krause <minipli@googlemail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit e862f1a9b7df4e8196ebec45ac62295138aa3fc2 upstream.

The ATM code fails to initialize the two padding bytes of struct
sockaddr_atmpvc inserted for alignment. Add an explicit memset(0)
before filling the structure to avoid the info leak.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/atm/common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/atm/common.c b/net/atm/common.c
index 97ed94aa0cbc..ec2cb8f3c8d9 100644
--- a/net/atm/common.c
+++ b/net/atm/common.c
@@ -759,6 +759,7 @@ int vcc_getsockopt(struct socket *sock, int level, int optname,
 
 		if (!vcc->dev || !test_bit(ATM_VF_ADDR, &vcc->flags))
 			return -ENOTCONN;
+		memset(&pvc, 0, sizeof(pvc));
 		pvc.sap_family = AF_ATMPVC;
 		pvc.sap_addr.itf = vcc->dev->number;
 		pvc.sap_addr.vpi = vcc->vpi;
-- 
1.8.5.2

