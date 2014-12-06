Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbaLFPYw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:24:52 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:47681 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752039AbaLFPIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:08:02 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        "J. Bruce Fields" <bfields@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 58/66] nfsd: correctly define v4.2 support attributes
Date: Sat,  6 Dec 2014 16:07:50 +0100
Message-Id: <e030e3fc04533f70a52584ff4a54a33014286340.1417878427.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
References: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
In-Reply-To: <cover.1417878427.git.jslaby@suse.cz>
References: <cover.1417878427.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 6d0ba0432a5e10bc714ba9c5adc460e726e5fbb4 upstream.

Even when security labels are disabled we support at least the same
attributes as v4.1.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/nfsd/nfsd.h | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/nfsd.h b/fs/nfsd/nfsd.h
index 479eb681c27c..f417fef17118 100644
--- a/fs/nfsd/nfsd.h
+++ b/fs/nfsd/nfsd.h
@@ -328,12 +328,15 @@ void		nfsd_lockd_shutdown(void);
 	(NFSD4_SUPPORTED_ATTRS_WORD2 | FATTR4_WORD2_SUPPATTR_EXCLCREAT)
 
 #ifdef CONFIG_NFSD_V4_SECURITY_LABEL
-#define NFSD4_2_SUPPORTED_ATTRS_WORD2 \
-	(NFSD4_1_SUPPORTED_ATTRS_WORD2 | FATTR4_WORD2_SECURITY_LABEL)
+#define NFSD4_2_SECURITY_ATTRS		FATTR4_WORD2_SECURITY_LABEL
 #else
-#define NFSD4_2_SUPPORTED_ATTRS_WORD2 0
+#define NFSD4_2_SECURITY_ATTRS		0
 #endif
 
+#define NFSD4_2_SUPPORTED_ATTRS_WORD2 \
+	(NFSD4_1_SUPPORTED_ATTRS_WORD2 | \
+	NFSD4_2_SECURITY_ATTRS)
+
 static inline u32 nfsd_suppattrs0(u32 minorversion)
 {
 	return minorversion ? NFSD4_1_SUPPORTED_ATTRS_WORD0
-- 
2.1.3

