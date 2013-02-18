Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924Ab3BRQIL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 11:08:11 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:33411 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751652Ab3BRQII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 11:08:08 -0500
From: Andy King <acking@vmware.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc: davem@davemloft.net, pv-drivers@vmware.com, kraxel@redhat.com,
        Andy King <acking@vmware.com>
Subject: [PATCH 4/4] VSOCK: Don't reject PF_VSOCK protocol
Date: Mon, 18 Feb 2013 08:04:13 -0800
Message-Id: <1361203453-1347-5-git-send-email-acking@vmware.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1361203453-1347-1-git-send-email-acking@vmware.com>
References: <1361203453-1347-1-git-send-email-acking@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow our own family as the protocol value for socket creation.

Reported-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Andy King <acking@vmware.com>
---
 net/vmw_vsock/af_vsock.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index c1b9e55..ca511c4 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1860,7 +1860,7 @@ static int vsock_create(struct net *net, struct socket *sock,
 	if (!sock)
 		return -EINVAL;
 
-	if (protocol)
+	if (protocol && protocol != PF_VSOCK)
 		return -EPROTONOSUPPORT;
 
 	switch (sock->type) {
-- 
1.7.4.1

