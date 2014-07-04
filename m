Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031564AbaGDW17 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 18:27:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57711 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760781AbaGDWWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:22:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.10 23/46] pNFS: Handle allocation errors correctly in filelayout_alloc_layout_hdr()
Date: Fri,  4 Jul 2014 15:19:27 -0700
Message-Id: <20140704221603.329521956@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140704221602.280733370@linuxfoundation.org>
References: <20140704221602.280733370@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit 6df200f5d5191bdde4d2e408215383890f956781 upstream.

Return the NULL pointer when the allocation fails.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4filelayout.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/nfs4filelayout.c
+++ b/fs/nfs/nfs4filelayout.c
@@ -1300,7 +1300,7 @@ filelayout_alloc_layout_hdr(struct inode
 	struct nfs4_filelayout *flo;
 
 	flo = kzalloc(sizeof(*flo), gfp_flags);
-	return &flo->generic_hdr;
+	return flo != NULL ? &flo->generic_hdr : NULL;
 }
 
 static void


