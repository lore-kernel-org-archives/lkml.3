Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbbANIVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:21:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58028 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553AbbANH3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:29:02 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Benjamin Coddington <bcodding@redhat.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 3.18 104/150] nfsd4: fix xdr4 count of server in fs_location4
Date: Tue, 13 Jan 2015 23:22:55 -0800
Message-Id: <20150114072100.572143607@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Coddington <bcodding@redhat.com>

commit bf7491f1be5e125eece2ec67e0f79d513caa6c7e upstream.

Fix a bug where nfsd4_encode_components_esc() incorrectly calculates the
length of server array in fs_location4--note that it is a count of the
number of array elements, not a length in bytes.

Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Fixes: 082d4bd72a45 (nfsd4: "backfill" using write_bytes_to_xdr_buf)
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4xdr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1800,7 +1800,7 @@ static __be32 nfsd4_encode_components_es
 
 		str = end;
 	}
-	pathlen = htonl(xdr->buf->len - pathlen_offset);
+	pathlen = htonl(count);
 	write_bytes_to_xdr_buf(xdr->buf, pathlen_offset, &pathlen, 4);
 	return 0;
 }


