Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758994Ab3K0BDx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:03:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39701 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758891Ab3K0BAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 20:00:02 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bruce Fields <bfields@fieldses.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH 3.12 095/116] SUNRPC: gss_alloc_msg - choose _either_ a v0 message or a v1 message
Date: Tue, 26 Nov 2013 16:57:48 -0800
Message-Id: <20131127005743.471012959@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 5fccc5b52ee07d07a74ce53c6f174bff81e26a16 upstream.

Add the missing 'break' to ensure that we don't corrupt a legacy 'v0' type
message by appending the 'v1'.

Cc: Bruce Fields <bfields@fieldses.org>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/auth_gss/auth_gss.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/sunrpc/auth_gss/auth_gss.c
+++ b/net/sunrpc/auth_gss/auth_gss.c
@@ -482,6 +482,7 @@ gss_alloc_msg(struct gss_auth *gss_auth,
 	switch (vers) {
 	case 0:
 		gss_encode_v0_msg(gss_msg);
+		break;
 	default:
 		gss_encode_v1_msg(gss_msg, service_name, gss_auth->target_name);
 	};


