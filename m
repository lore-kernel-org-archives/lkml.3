Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921Ab3KYORz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:17:55 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59002 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754456Ab3KYNxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:42 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jonathan Nieder" <jrnieder@gmail.com>,
        "Bernd Schubert" <bernd.schubert@itwm.fraunhofer.de>,
        "Theodore Ts'o" <tytso@mit.edu>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.292682909@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 22/87] fs: add new FMODE flags: FMODE_32bithash and
 FMODE_64bithash
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>

commit 6a8a13e03861c0ab83ab07d573ca793cff0e5d00 upstream.

Those flags are supposed to be set by NFS readdir() to tell ext3/ext4
to 32bit (NFSv2) or 64bit hash values (offsets) in seekdir().

Signed-off-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/fs.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -92,6 +92,10 @@ struct inodes_stat_t {
 /* File is opened using open(.., 3, ..) and is writeable only for ioctls
    (specialy hack for floppy.c) */
 #define FMODE_WRITE_IOCTL	((__force fmode_t)0x100)
+/* 32bit hashes as llseek() offset (for directories) */
+#define FMODE_32BITHASH         ((__force fmode_t)0x200)
+/* 64bit hashes as llseek() offset (for directories) */
+#define FMODE_64BITHASH         ((__force fmode_t)0x400)
 
 /*
  * Don't update ctime and mtime.

