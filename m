Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab3JYHvY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 03:51:24 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:44320 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab3JYHvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 03:51:22 -0400
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH 1/3] vxlan: silence one build warning
Date: Fri, 25 Oct 2013 15:49:18 +0800
Message-Id: <1382687360-27794-1-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.11.7
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102507-9332-0000-0000-000001EB90BF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

drivers/net/vxlan.c: In function ‘vxlan_sock_add’:
drivers/net/vxlan.c:2298:11: warning: ‘sock’ may be used uninitialized in this function [-Wmaybe-uninitialized]
drivers/net/vxlan.c:2275:17: note: ‘sock’ was declared here
  LD      drivers/net/built-in.o

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 drivers/net/vxlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 2ef5b62..e15f1af 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -2272,7 +2272,7 @@ static struct vxlan_sock *vxlan_socket_create(struct net *net, __be16 port,
 {
 	struct vxlan_net *vn = net_generic(net, vxlan_net_id);
 	struct vxlan_sock *vs;
-	struct socket *sock;
+	struct socket *sock = NULL;
 	struct sock *sk;
 	int rc = 0;
 	unsigned int h;
-- 
1.7.11.7

