Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbbAKWp4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 17:45:56 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:61768 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbbAKWpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 17:45:54 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Anton Altaparmakov <anton@tuxera.com>,
        linux-ntfs-dev@lists.sourceforge.net
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ntfs: attrib: Remove unused function
Date: Sun, 11 Jan 2015 23:48:59 +0100
Message-Id: <1421016539-25918-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function ntfs_attr_can_be_resident() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 fs/ntfs/attrib.c |   25 -------------------------
 fs/ntfs/attrib.h |    2 --
 2 files changed, 27 deletions(-)

diff --git a/fs/ntfs/attrib.c b/fs/ntfs/attrib.c
index 250ed5b..2c83e66 100644
--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -1390,31 +1390,6 @@ int ntfs_attr_can_be_non_resident(const ntfs_volume *vol, const ATTR_TYPE type)
 }
 
 /**
- * ntfs_attr_can_be_resident - check if an attribute can be resident
- * @vol:	ntfs volume to which the attribute belongs
- * @type:	attribute type which to check
- *
- * Check whether the attribute of @type on the ntfs volume @vol is allowed to
- * be resident.  This information is derived from our ntfs knowledge and may
- * not be completely accurate, especially when user defined attributes are
- * present.  Basically we allow everything to be resident except for index
- * allocation and $EA attributes.
- *
- * Return 0 if the attribute is allowed to be non-resident and -EPERM if not.
- *
- * Warning: In the system file $MFT the attribute $Bitmap must be non-resident
- *	    otherwise windows will not boot (blue screen of death)!  We cannot
- *	    check for this here as we do not know which inode's $Bitmap is
- *	    being asked about so the caller needs to special case this.
- */
-int ntfs_attr_can_be_resident(const ntfs_volume *vol, const ATTR_TYPE type)
-{
-	if (type == AT_INDEX_ALLOCATION)
-		return -EPERM;
-	return 0;
-}
-
-/**
  * ntfs_attr_record_resize - resize an attribute record
  * @m:		mft record containing attribute record
  * @a:		attribute record to resize
diff --git a/fs/ntfs/attrib.h b/fs/ntfs/attrib.h
index 3c8b74c..bfc1829 100644
--- a/fs/ntfs/attrib.h
+++ b/fs/ntfs/attrib.h
@@ -96,8 +96,6 @@ extern int ntfs_attr_size_bounds_check(const ntfs_volume *vol,
 		const ATTR_TYPE type, const s64 size);
 extern int ntfs_attr_can_be_non_resident(const ntfs_volume *vol,
 		const ATTR_TYPE type);
-extern int ntfs_attr_can_be_resident(const ntfs_volume *vol,
-		const ATTR_TYPE type);
 
 extern int ntfs_attr_record_resize(MFT_RECORD *m, ATTR_RECORD *a, u32 new_size);
 extern int ntfs_resident_attr_value_resize(MFT_RECORD *m, ATTR_RECORD *a,
-- 
1.7.10.4

