Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbbALSKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:10:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57787 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbbALSGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:06:47 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Benjamin Coddington <bcodding@redhat.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 105/216] nfsd4: fix xdr4 inclusion of escaped char
Date: Mon, 12 Jan 2015 18:03:42 +0000
Message-Id: <1421085933-32536-106-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Coddington <bcodding@redhat.com>

commit 5a64e56976f1ba98743e1678c0029a98e9034c81 upstream.

Fix a bug where nfsd4_encode_components_esc() includes the esc_end char as
an additional string encoding.

Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Fixes: e7a0444aef4a "nfsd: add IPv6 addr escaping to fs_location hosts"
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/nfsd/nfs4xdr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 96338175a2fe..69f15dc9e16b 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1777,6 +1777,9 @@ static __be32 nfsd4_encode_components_esc(struct xdr_stream *xdr, char sep,
 		}
 		else
 			end++;
+		if (found_esc)
+			end = next;
+
 		str = end;
 	}
 	pathlen = htonl(xdr->buf->len - pathlen_offset);
-- 
2.1.4

