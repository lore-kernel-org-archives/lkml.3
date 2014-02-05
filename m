Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651AbaBEVMv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 16:12:51 -0500
Received: from mail1.windriver.com ([147.11.146.13]:47941 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965AbaBEUDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:03:51 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 030/213] atm: fix info leak via getsockname()
Date: Wed, 5 Feb 2014 14:59:45 -0500
Message-ID: <1391630568-49251-31-git-send-email-paul.gortmaker@windriver.com>
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

commit 3c0c5cfdcd4d69ffc4b9c0907cec99039f30a50a upstream.

The ATM code fails to initialize the two padding bytes of struct
sockaddr_atmpvc inserted for alignment. Add an explicit memset(0)
before filling the structure to avoid the info leak.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/atm/pvc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/atm/pvc.c b/net/atm/pvc.c
index 437ee70c5e62..db0dd47de61b 100644
--- a/net/atm/pvc.c
+++ b/net/atm/pvc.c
@@ -94,6 +94,7 @@ static int pvc_getname(struct socket *sock, struct sockaddr *sockaddr,
 		return -ENOTCONN;
 	*sockaddr_len = sizeof(struct sockaddr_atmpvc);
 	addr = (struct sockaddr_atmpvc *)sockaddr;
+	memset(addr, 0, sizeof(*addr));
 	addr->sap_family = AF_ATMPVC;
 	addr->sap_addr.itf = vcc->dev->number;
 	addr->sap_addr.vpi = vcc->vpi;
-- 
1.8.5.2

