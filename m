Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967684Ab3HICMf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:12:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55765 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967635Ab3HIB7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:59:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 055/102] svcrpc: fix kfree oops in gss-proxy code
Date: Thu,  8 Aug 2013 18:57:31 -0700
Message-Id: <20130809015023.057062372@linuxfoundation.org>
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

commit 743e217129f69aab074abe520a464fd0c6b1cca1 upstream.

mech_oid.data is an array, not kmalloc()'d memory.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/auth_gss/gss_rpc_upcall.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/sunrpc/auth_gss/gss_rpc_upcall.c
+++ b/net/sunrpc/auth_gss/gss_rpc_upcall.c
@@ -328,7 +328,6 @@ void gssp_free_upcall_data(struct gssp_u
 	kfree(data->in_handle.data);
 	kfree(data->out_handle.data);
 	kfree(data->out_token.data);
-	kfree(data->mech_oid.data);
 	free_svc_cred(&data->creds);
 }
 


