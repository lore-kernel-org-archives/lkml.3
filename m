Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbaFEEzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:55:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43970 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbaFEEUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:20:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Ben Hutchings <ben@decadent.org.uk>, Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH 3.4 091/214] NFS: nfs_getaclargs.acl_len is a size_t
Date: Wed,  4 Jun 2014 21:17:34 -0700
Message-Id: <20140605041651.874561732@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit 56d08fef2369d5ca9ad2e1fc697f5379fd8af751 upstream.

Squelch compiler warnings:

fs/nfs/nfs4proc.c: In function ‘__nfs4_get_acl_uncached’:
fs/nfs/nfs4proc.c:3811:14: warning: comparison between signed and
	unsigned integer expressions [-Wsign-compare]
fs/nfs/nfs4proc.c:3818:15: warning: comparison between signed and
	unsigned integer expressions [-Wsign-compare]

Introduced by commit bf118a34 "NFSv4: include bitmap in nfsv4 get
acl data", Dec 7, 2011.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Rui Xiang <rui.xiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3724,7 +3724,8 @@ static ssize_t __nfs4_get_acl_uncached(s
 		.rpc_argp = &args,
 		.rpc_resp = &res,
 	};
-	int ret = -ENOMEM, npages, i, acl_len = 0;
+	int ret = -ENOMEM, npages, i;
+	size_t acl_len = 0;
 
 	npages = (buflen + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	/* As long as we're doing a round trip to the server anyway,


