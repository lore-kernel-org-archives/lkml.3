Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967753Ab3HICM4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:12:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55761 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967555Ab3HIB7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:59:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 054/102] svcrpc: fix gss_rpc_upcall create error
Date: Thu,  8 Aug 2013 18:57:30 -0700
Message-Id: <20130809015022.812190530@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit 9f96392b0ae6aefc02a9b900c3f4889dfafc8402 upstream.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/auth_gss/gss_rpc_upcall.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sunrpc/auth_gss/gss_rpc_upcall.c
+++ b/net/sunrpc/auth_gss/gss_rpc_upcall.c
@@ -120,7 +120,7 @@ static int gssp_rpc_create(struct net *n
 	if (IS_ERR(clnt)) {
 		dprintk("RPC:       failed to create AF_LOCAL gssproxy "
 				"client (errno %ld).\n", PTR_ERR(clnt));
-		result = -PTR_ERR(clnt);
+		result = PTR_ERR(clnt);
 		*_clnt = NULL;
 		goto out;
 	}


