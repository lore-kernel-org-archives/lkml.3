Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbaGDFkI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 01:40:08 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:53644 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbaGDFkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 01:40:05 -0400
From: pramod.gurav.etc@gmail.com
Cc: Pramod Gurav <pramod.gurav.etc@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fs/direct-io.c: Fix compilation warning for uninitialized variables
Date: Fri,  4 Jul 2014 11:13:52 +0530
Message-Id: <1404452632-10912-1-git-send-email-pramod.gurav.etc@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pramod Gurav <pramod.gurav.etc@gmail.com>

Fixes below warning while compiling the kernel.

fs/direct-io.c: In function ‘__blockdev_direct_IO’:
fs/direct-io.c:1011:12: warning: ‘to’ may be used uninitialized in this function [-Wmaybe-uninitialized]
fs/direct-io.c:913:16: note: ‘to’ was declared here
fs/direct-io.c:1011:12: warning: ‘from’ may be used uninitialized in this function [-Wmaybe-uninitialized]
fs/direct-io.c:913:10: note: ‘from’ was declared here

Signed-off-by: Pramod Gurav <pramod.gurav.etc@gmail.com>

CC: Alexander Viro <viro@zeniv.linux.org.uk>
CC: linux-fsdevel@vger.kernel.org
CC: linux-kernel@vger.kernel.org
---
 fs/direct-io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 98040ba..6ad5d2c 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -910,7 +910,7 @@ static int do_direct_IO(struct dio *dio, struct dio_submit *sdio,
 
 	while (sdio->block_in_file < sdio->final_block_in_request) {
 		struct page *page;
-		size_t from, to;
+		size_t from = 0, to = 0;
 		page = dio_get_page(dio, sdio, &from, &to);
 		if (IS_ERR(page)) {
 			ret = PTR_ERR(page);
-- 
1.7.9.5

