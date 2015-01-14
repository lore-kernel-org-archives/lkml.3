Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074AbbANH3H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:29:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58026 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505AbbANH3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:29:02 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Benjamin Coddington <bcodding@redhat.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 3.18 103/150] nfsd4: fix xdr4 inclusion of escaped char
Date: Tue, 13 Jan 2015 23:22:54 -0800
Message-Id: <20150114072100.528871728@linuxfoundation.org>
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

commit 5a64e56976f1ba98743e1678c0029a98e9034c81 upstream.

Fix a bug where nfsd4_encode_components_esc() includes the esc_end char as
an additional string encoding.

Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Fixes: e7a0444aef4a "nfsd: add IPv6 addr escaping to fs_location hosts"
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4xdr.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1795,6 +1795,9 @@ static __be32 nfsd4_encode_components_es
 		}
 		else
 			end++;
+		if (found_esc)
+			end = next;
+
 		str = end;
 	}
 	pathlen = htonl(xdr->buf->len - pathlen_offset);


