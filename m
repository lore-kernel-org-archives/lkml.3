Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762301AbbA2Ci1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:38:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47039 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681AbbA2CiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:38:23 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Benjamin Coddington <bcodding@redhat.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 095/139] nfsd4: fix xdr4 inclusion of escaped char
Date: Wed, 28 Jan 2015 14:20:38 -0800
Message-Id: <1422483682-15393-96-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Coddington <bcodding@redhat.com>

commit 5a64e56976f1ba98743e1678c0029a98e9034c81 upstream.

Fix a bug where nfsd4_encode_components_esc() includes the esc_end char as
an additional string encoding.

Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Fixes: e7a0444aef4a "nfsd: add IPv6 addr escaping to fs_location hosts"
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/nfsd/nfs4xdr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index ab38bc4..65569f9 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1801,6 +1801,9 @@ static __be32 nfsd4_encode_components_esc(char sep, char *components,
 		}
 		else
 			end++;
+		if (found_esc)
+			end = next;
+
 		str = end;
 	}
 	*pp = p;
-- 
1.9.1

