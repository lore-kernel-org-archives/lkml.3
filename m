Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbaJ1Dhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:37:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44452 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044AbaJ1Dhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:37:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Olga Kornievskaia <kolga@netapp.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.17 053/146] Fixing lease renewal
Date: Tue, 28 Oct 2014 11:33:15 +0800
Message-Id: <20141028033345.705955922@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033343.441992423@linuxfoundation.org>
References: <20141028033343.441992423@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olga Kornievskaia <kolga@netapp.com>

commit 8faaa6d5d48b201527e0451296d9e71d23afb362 upstream.

Commit c9fdeb28 removed a 'continue' after checking if the lease needs
to be renewed. However, if client hasn't moved, the code falls down to
starting reboot recovery erroneously (ie., sends open reclaim and gets
back stale_clientid error) before recovering from getting stale_clientid
on the renew operation.

Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Fixes: c9fdeb280b8c (NFS: Add basic migration support to state manager thread)
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4state.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -2345,6 +2345,7 @@ static void nfs4_state_manager(struct nf
 			status = nfs4_check_lease(clp);
 			if (status < 0)
 				goto out_error;
+			continue;
 		}
 
 		if (test_and_clear_bit(NFS4CLNT_MOVED, &clp->cl_state)) {


