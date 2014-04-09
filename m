Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933424AbaDIOF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 10:05:57 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:50563 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932866AbaDIOFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 10:05:55 -0400
Message-ID: <1397052353.22767.31.camel@x220>
Subject: [PATCH] NFS/RDMA: Document separate Kconfig symbols
From: Paul Bolle <pebolle@tiscali.nl>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Jeff Layton <jlayton@redhat.com>, "J. Bruce Fields" <bfields@redhat.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 09 Apr 2014 16:05:53 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Apr 2014 14:05:53.0672 (UTC) FILETIME=[D1FA0080:01CF53FC]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The NFS/RDMA Kconfig symbol was split into separate options for client
and server in commit 2e8c12e1b765 ("xprtrdma: add separate Kconfig
options for NFSoRDMA client and server support"). Update the
documentation to reflect this split.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Should Documentation/ describe the current release, or the current
and previous releases? For these paragraphs I choose only the current
release.

1) Another approach could be to not document the Kconfig setup at all,
because the Kconfig system should, in theory, provide all help needed to
correctly configure the build for (in this case) NFS/RDMA. But is that
true?

2) By the way: what's the purpose of INFINIBAND_ADDR_TRANS?

 Documentation/filesystems/nfs/nfs-rdma.txt | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/Documentation/filesystems/nfs/nfs-rdma.txt b/Documentation/filesystems/nfs/nfs-rdma.txt
index e386f7e4bcee..724043858b08 100644
--- a/Documentation/filesystems/nfs/nfs-rdma.txt
+++ b/Documentation/filesystems/nfs/nfs-rdma.txt
@@ -138,9 +138,9 @@ Installation
   - Build, install, reboot
 
     The NFS/RDMA code will be enabled automatically if NFS and RDMA
-    are turned on. The NFS/RDMA client and server are configured via the hidden
-    SUNRPC_XPRT_RDMA config option that depends on SUNRPC and INFINIBAND. The
-    value of SUNRPC_XPRT_RDMA will be:
+    are turned on. The NFS/RDMA client and server are configured via the
+    SUNRPC_XPRT_RDMA_CLIENT and SUNRPC_XPRT_RDMA_SERVER config options that both
+    depend on SUNRPC and INFINIBAND. The default value of both options will be:
 
      - N if either SUNRPC or INFINIBAND are N, in this case the NFS/RDMA client
        and server will not be built
@@ -235,8 +235,9 @@ NFS/RDMA Setup
 
   - Start the NFS server
 
-    If the NFS/RDMA server was built as a module (CONFIG_SUNRPC_XPRT_RDMA=m in
-    kernel config), load the RDMA transport module:
+    If the NFS/RDMA server was built as a module
+    (CONFIG_SUNRPC_XPRT_RDMA_SERVER=m in kernel config), load the RDMA
+    transport module:
 
     $ modprobe svcrdma
 
@@ -255,8 +256,9 @@ NFS/RDMA Setup
 
   - On the client system
 
-    If the NFS/RDMA client was built as a module (CONFIG_SUNRPC_XPRT_RDMA=m in
-    kernel config), load the RDMA client module:
+    If the NFS/RDMA client was built as a module
+    (CONFIG_SUNRPC_XPRT_RDMA_CLIENT=m in kernel config), load the RDMA client
+    module:
 
     $ modprobe xprtrdma.ko
 
-- 
1.9.0

