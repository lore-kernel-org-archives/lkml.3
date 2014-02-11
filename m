Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbaBKTGr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:06:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40010 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbaBKTGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:06:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.12 045/107] NFSv4: Fix a slot leak in nfs40_sequence_done
Date: Tue, 11 Feb 2014 11:05:11 -0800
Message-Id: <20140211184749.475394162@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184748.191276235@linuxfoundation.org>
References: <20140211184748.191276235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit cab92c19821a814ecf5a5279e2699bf28e66caee upstream.

The check for whether or not we sent an RPC call in nfs40_sequence_done
is insufficient to decide whether or not we are holding a session slot,
and thus should not be used to decide when to free that slot.

This patch replaces the RPC_WAS_SENT() test with the correct test for
whether or not slot == NULL.

Cc: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -532,7 +532,7 @@ static int nfs40_sequence_done(struct rp
 	struct nfs4_slot *slot = res->sr_slot;
 	struct nfs4_slot_table *tbl;
 
-	if (!RPC_WAS_SENT(task))
+	if (slot == NULL)
 		goto out;
 
 	tbl = slot->table;


