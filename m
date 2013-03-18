Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515Ab3CRVKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:10:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46089 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756707Ab3CRVKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:10:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        James Morris <james.l.morris@oracle.com>
Subject: [ 21/40] selinux: use GFP_ATOMIC under spin_lock
Date: Mon, 18 Mar 2013 14:10:59 -0700
Message-Id: <20130318211017.768253164@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318211016.254453918@linuxfoundation.org>
References: <20130318211016.254453918@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 4502403dcf8f5c76abd4dbab8726c8e4ecb5cd34 upstream.

The call tree here is:

sk_clone_lock()              <- takes bh_lock_sock(newsk);
xfrm_sk_clone_policy()
__xfrm_sk_clone_policy()
clone_policy()               <- uses GFP_ATOMIC for allocations
security_xfrm_policy_clone()
security_ops->xfrm_policy_clone_security()
selinux_xfrm_policy_clone()

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: James Morris <james.l.morris@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/selinux/xfrm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/security/selinux/xfrm.c
+++ b/security/selinux/xfrm.c
@@ -310,7 +310,7 @@ int selinux_xfrm_policy_clone(struct xfr
 
 	if (old_ctx) {
 		new_ctx = kmalloc(sizeof(*old_ctx) + old_ctx->ctx_len,
-				  GFP_KERNEL);
+				  GFP_ATOMIC);
 		if (!new_ctx)
 			return -ENOMEM;
 


