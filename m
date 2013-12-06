Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162230Ab3LFWWz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:22:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60759 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161232Ab3LFVxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:53:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>,
        Benjamin LaHaise <bcrl@kvack.org>
Subject: [PATCH 3.12 80/83] aio: nullify aio->ring_pages after freeing it
Date: Fri,  6 Dec 2013 13:52:10 -0800
Message-Id: <20131206214647.480375104@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214640.002320724@linuxfoundation.org>
References: <20131206214640.002320724@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sasha Levin <sasha.levin@oracle.com>

commit ddb8c45ba15149ebd41d7586261c05f7ca37f9a1 upstream.

After freeing ring_pages we leave it as is causing a dangling pointer. This
has already caused an issue so to help catching any issues in the future
NULL it out.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/aio.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -251,8 +251,10 @@ static void aio_free_ring(struct kioctx
 
 	put_aio_ring_file(ctx);
 
-	if (ctx->ring_pages && ctx->ring_pages != ctx->internal_pages)
+	if (ctx->ring_pages && ctx->ring_pages != ctx->internal_pages) {
 		kfree(ctx->ring_pages);
+		ctx->ring_pages = NULL;
+	}
 }
 
 static int aio_ring_mmap(struct file *file, struct vm_area_struct *vma)


