Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049AbaD1BcL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:32:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42867 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752478AbaD1B3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:20 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org
Date: Mon, 28 Apr 2014 02:11:22 +0100
Message-ID: <lsq.1398647482.806216234@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 63/94] nfsd: Add fh_{want,drop}_write()
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

Part of commit bad0dcffc21d17a07dbb83a2bf764f35a57feba5
('new helpers: fh_{want,drop}_write()') upstream.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/fs/nfsd/vfs.h
+++ b/fs/nfsd/vfs.h
@@ -108,4 +108,14 @@ struct posix_acl *nfsd_get_posix_acl(str
 int nfsd_set_posix_acl(struct svc_fh *, int, struct posix_acl *);
 #endif
 
+static inline int fh_want_write(struct svc_fh *fh)
+{
+	return mnt_want_write(fh->fh_export->ex_path.mnt);
+}
+
+static inline void fh_drop_write(struct svc_fh *fh)
+{
+	mnt_drop_write(fh->fh_export->ex_path.mnt);
+}
+
 #endif /* LINUX_NFSD_VFS_H */

