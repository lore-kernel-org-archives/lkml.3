Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135AbbA2JEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:04:22 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44815 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759360AbbA2JEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:04:15 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Benjamin Coddington <bcodding@redhat.com>,
        "J. Bruce Fields" <bfields@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 041/176] nfsd4: fix xdr4 inclusion of escaped char
Date: Wed, 28 Jan 2015 15:27:51 +0100
Message-Id: <03e6a1dc9b69bed1e6c98ddfeb5232208f79e7a0.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Coddington <bcodding@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 5a64e56976f1ba98743e1678c0029a98e9034c81 upstream.

Fix a bug where nfsd4_encode_components_esc() includes the esc_end char as
an additional string encoding.

Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Fixes: e7a0444aef4a "nfsd: add IPv6 addr escaping to fs_location hosts"
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/nfsd/nfs4xdr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 42c8c8aeb465..1c825aee736d 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1786,6 +1786,9 @@ static __be32 nfsd4_encode_components_esc(char sep, char *components,
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
2.2.2

