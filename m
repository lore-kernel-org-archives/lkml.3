Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbaLEWtd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 17:49:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53900 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbaLEWqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:46:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 3.17 096/122] nfsd: correctly define v4.2 support attributes
Date: Fri,  5 Dec 2014 14:44:30 -0800
Message-Id: <20141205223320.411688976@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit 6d0ba0432a5e10bc714ba9c5adc460e726e5fbb4 upstream.

Even when security labels are disabled we support at least the same
attributes as v4.1.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfsd.h |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/fs/nfsd/nfsd.h
+++ b/fs/nfsd/nfsd.h
@@ -335,12 +335,15 @@ void		nfsd_lockd_shutdown(void);
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


