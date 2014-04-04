Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbaDDIZE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 04:25:04 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:46920 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbaDDIZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 04:25:00 -0400
From: Andrey Vagin <avagin@openvz.org>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: linux-man@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrey Vagin <avagin@openvz.org>
Subject: [PATCH] maps.2: fd for a file mapping must be opened for reading
Date: Fri,  4 Apr 2014 12:24:35 +0400
Message-Id: <1396599875-10562-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is no difference between MAP_SHARED and MAP_PRIVATE.

do_mmap_pgoff()
	switch (flags & MAP_TYPE) {
	case MAP_SHARED:
	...
	/* fall through */
	case MAP_PRIVATE:
		if (!(file->f_mode & FMODE_READ))
			return -EACCES;

Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 man2/mmap.2 | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/man2/mmap.2 b/man2/mmap.2
index c0fd321..b469f84 100644
--- a/man2/mmap.2
+++ b/man2/mmap.2
@@ -393,9 +393,7 @@ is set (probably to
 .TP
 .B EACCES
 A file descriptor refers to a non-regular file.
-Or
-.B MAP_PRIVATE
-was requested, but
+Or a file mapping was requested, but
 .I fd
 is not open for reading.
 Or
-- 
1.8.5.3

