Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbaCVHAd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 03:00:33 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:54079 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbaCVHAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 03:00:31 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-3e-532d350d88e5
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev] [PATCH 2/2] f2fs: avoid unneeded lookup when xattr name
 length is too long
Date: Sat, 22 Mar 2014 14:59:45 +0800
Message-id: <000d01cf459c$68d4e070$3a7ea150$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9FlxtPPlLHTdgKS0qLM4P37OLaCg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t9jAV1eU91gg2PPTC2u7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgyni+dQ9bwQHWip3/
	GhgbGLexdDFyckgImEgsXbuRFcIWk7hwbz1bFyMXh5DAIkaJuTPnMUI4PxgljrctZwepYhNQ
	kVje8Z8JxBYRUJTY8H4DWJxZIFPiXtMM5i5GDg5hgQSJe9/KQcIsAqoSn2asAlvAK2ApceXt
	YyhbUOLH5HssEK1aEut3HmeCsOUlNq95ywxxkILEjrOvGSFW6Ums657PClEjLrHxyC2WCYwC
	s5CMmoVk1Cwko2YhaVnAyLKKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIziQn0nvYFzVYHGI
	UYCDUYmH94a8brAQa2JZcWXuIUYJDmYlEd4TCkAh3pTEyqrUovz4otKc1OJDjNIcLErivAdb
	rQOFBNITS1KzU1MLUotgskwcnFINjJ1BAWf0dRvYDdK9r4aWSr9KU9MI9jJPuTVJ/oaSxfkm
	t+fPEtUZFkXN5InO79h9OnriC+4CqQnvT2jGiFw7dT7dR+X2iVVbQ66rp8vONX+o/M5/7ZyF
	s0uOvfN6t8Rrt8gjZiMZdo7v7Ze6D77nPftn/qTXBXF/i84Ge5z4pVKfrvPWLJ3njBJLcUai
	oRZzUXEiAKNeWj5gAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In f2fs_setxattr we have limit this attribute name length, so we should also
check it in f2fs_getxattr to avoid useless lookup caused by invalid name length.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/xattr.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
index 0121e45..503c245 100644
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -407,6 +407,8 @@ int f2fs_getxattr(struct inode *inode, int name_index, const char *name,
 	if (name == NULL)
 		return -EINVAL;
 	name_len = strlen(name);
+	if (name_len > F2FS_NAME_LEN)
+		return -ERANGE;
 
 	base_addr = read_all_xattrs(inode, NULL);
 	if (!base_addr)
-- 
1.7.9.5


