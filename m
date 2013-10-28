Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757166Ab3J1Q2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 12:28:50 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:62851 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757140Ab3J1Q2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 12:28:48 -0400
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
To: <linux-kernel@vger.kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] sysfs: return correct error code on unimplemented mmap()
Date: Mon, 28 Oct 2013 18:28:30 +0200
Message-ID: <1382977710-1966-1-git-send-email-vladimir_zapolskiy@mentor.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [137.202.0.76]
X-OriginalArrivalTime: 28 Oct 2013 16:28:47.0670 (UTC) FILETIME=[C7250560:01CED3FA]
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
 fs/sysfs/bin.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index c590cab..d37433c 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -350,7 +350,6 @@ static int mmap(struct file *file, struct vm_area_struct *vma)
 	if (!sysfs_get_active(attr_sd))
 		goto out_unlock;
 
-	rc = -EINVAL;
 	if (!attr->mmap)
 		goto out_put;
 
-- 
1.7.10.4

