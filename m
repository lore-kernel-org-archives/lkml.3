Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673Ab3KIHOS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 02:14:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33298 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932629Ab3KIGv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:51:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Colin Ian King <colin.king@canonical.com>,
        Lars Duesing <lars.duesing@camelotsweb.de>,
        Tyler Hicks <tyhicks@canonical.com>
Subject: [PATCH 3.11 34/94] eCryptfs: fix 32 bit corruption issue
Date: Fri,  8 Nov 2013 22:51:40 -0800
Message-Id: <20131109065206.651930839@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065204.252462489@linuxfoundation.org>
References: <20131109065204.252462489@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.king@canonical.com>

commit 43b7c6c6a4e3916edd186ceb61be0c67d1e0969e upstream.

Shifting page->index on 32 bit systems was overflowing, causing
data corruption of > 4GB files. Fix this by casting it first.

https://launchpad.net/bugs/1243636

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reported-by: Lars Duesing <lars.duesing@camelotsweb.de>
Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ecryptfs/crypto.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -408,7 +408,7 @@ static loff_t lower_offset_for_page(stru
 				    struct page *page)
 {
 	return ecryptfs_lower_header_size(crypt_stat) +
-	       (page->index << PAGE_CACHE_SHIFT);
+	       ((loff_t)page->index << PAGE_CACHE_SHIFT);
 }
 
 /**


