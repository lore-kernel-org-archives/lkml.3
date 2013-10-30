Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab3J3MJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 08:09:31 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:55609 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab3J3MJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 08:09:30 -0400
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
To: <linux-kernel@vger.kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH rebased] sysfs: return correct error code on unimplemented mmap()
Date: Wed, 30 Oct 2013 14:08:32 +0200
Message-ID: <1383134912-31152-1-git-send-email-vladimir_zapolskiy@mentor.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20131029230524.GA14393@kroah.com>
References: <20131029230524.GA14393@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [137.202.0.76]
X-OriginalArrivalTime: 30 Oct 2013 12:09:29.0661 (UTC) FILETIME=[E2ACBED0:01CED568]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both POSIX.1-2008 and Linux Programmer's Manual have a dedicated return
error code for a case, when a file doesn't support mmap(), it's ENODEV.

This change replaces overloaded EINVAL with ENODEV in a situation
described above for sysfs binary files.

Signed-off-by: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/sysfs/file.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 0d7368d4..382db3c 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -477,7 +477,6 @@ static int sysfs_bin_mmap(struct file *file, struct vm_area_struct *vma)
 	if (!sysfs_get_active(of->sd))
 		goto out_unlock;
 
-	rc = -EINVAL;
 	if (!battr->mmap)
 		goto out_put;
 
-- 
1.7.10.4

