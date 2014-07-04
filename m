Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760818AbaGDWWw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 18:22:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57722 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760801AbaGDWWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:22:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jeff Layton <jeff.layton@primarydata.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 3.10 24/46] nfsd4: fix FREE_STATEID lockowner leak
Date: Fri,  4 Jul 2014 15:19:28 -0700
Message-Id: <20140704221603.371910035@linuxfoundation.org>
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

From: "J. Bruce Fields" <bfields@redhat.com>

commit 48385408b45523d9a432c66292d47ef43efcbb94 upstream.

27b11428b7de ("nfsd4: remove lockowner when removing lock stateid")
introduced a memory leak.

Reported-by: Jeff Layton <jeff.layton@primarydata.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -3608,7 +3608,7 @@ nfsd4_free_lock_stateid(struct nfs4_ol_s
 	 * correspondance, and we have to delete the lockowner when we
 	 * delete the lock stateid:
 	 */
-	unhash_lockowner(lo);
+	release_lockowner(lo);
 	return nfs_ok;
 }
 


