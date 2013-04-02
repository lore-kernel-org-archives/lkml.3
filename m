Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933633Ab3DBWOi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:14:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33517 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933728Ab3DBWOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:14:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Toralf=20F=C3=B6rster?= <toralf.foerster@gmx.de>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 35/68] nfsd4: reject "negative" acl lengths
Date: Tue,  2 Apr 2013 15:13:24 -0700
Message-Id: <20130402221334.009995941@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221329.915209206@linuxfoundation.org>
References: <20130402221329.915209206@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit 64a817cfbded8674f345d1117b117f942a351a69 upstream.

Since we only enforce an upper bound, not a lower bound, a "negative"
length can get through here.

The symptom seen was a warning when we attempt to a kmalloc with an
excessive size.

Reported-by: Toralf Förster <toralf.foerster@gmx.de>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4xdr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -263,7 +263,7 @@ nfsd4_decode_fattr(struct nfsd4_compound
 		iattr->ia_valid |= ATTR_SIZE;
 	}
 	if (bmval[0] & FATTR4_WORD0_ACL) {
-		int nace;
+		u32 nace;
 		struct nfs4_ace *ace;
 
 		READ_BUF(4); len += 4;


