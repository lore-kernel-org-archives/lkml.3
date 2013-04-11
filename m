Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935532Ab3DKVSK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:18:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9226 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935510Ab3DKUs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:48:57 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=silpL3BumXEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=gmFzNEmpJjkA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=kt-8OUm0sC5qQgQqp2YA:9 a=jEp0ucaQiEUA:10 a=_RhRFcbxBZMA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202609.286802595@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:27:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: =?UTF-8?q?Toralf=20F=C3=B6rster?= <toralf.foerster@gmx.de>,
        <stable@kernel.org>, "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 140/171 ] nfsd4: reject "negative" acl lengths
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0140-nfsd4-reject-negative-acl-lengths.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

[ Upstream commit 64a817cfbded8674f345d1117b117f942a351a69 ]

Since we only enforce an upper bound, not a lower bound, a "negative"
length can get through here.

The symptom seen was a warning when we attempt to a kmalloc with an
excessive size.

Reported-by: Toralf Förster <toralf.foerster@gmx.de>
Cc: stable@kernel.org
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/nfsd/nfs4xdr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 6322df3..551b061 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -263,7 +263,7 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
 		iattr->ia_valid |= ATTR_SIZE;
 	}
 	if (bmval[0] & FATTR4_WORD0_ACL) {
-		int nace;
+		u32 nace;
 		struct nfs4_ace *ace;
 
 		READ_BUF(4); len += 4;
-- 
1.7.10.4


