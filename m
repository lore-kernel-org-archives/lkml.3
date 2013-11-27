Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759611Ab3K0BWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:22:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39489 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758738Ab3K0A7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:59:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jeff Layton <jlayton@redhat.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 3.12 069/116] nfsd4: fix discarded security labels on setattr
Date: Tue, 26 Nov 2013 16:57:22 -0800
Message-Id: <20131127005741.708139125@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit 3378b7f40d79930f0f447a164c7e8fcbe4480e40 upstream.

Security labels in setattr calls are currently ignored because we forget
to set label->len.

Reported-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4xdr.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -411,6 +411,7 @@ nfsd4_decode_fattr(struct nfsd4_compound
 		label->data = kzalloc(dummy32 + 1, GFP_KERNEL);
 		if (!label->data)
 			return nfserr_jukebox;
+		label->len = dummy32;
 		defer_free(argp, kfree, label->data);
 		memcpy(label->data, buf, dummy32);
 	}


