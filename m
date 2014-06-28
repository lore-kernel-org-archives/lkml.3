Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbaF1N3Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 09:29:16 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:44325 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbaF1N3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 09:29:14 -0400
Date: Sat, 28 Jun 2014 18:59:07 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Matthew Wilcox <matthew@wil.cx>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] isym53c8xx_2/sym_malloc: Drop cast
Message-ID: <20140628132907.GA4635@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does away with cast on void * and the if as it is unnecessary.

The following Coccinelle semantic patch was used for making the change:

@r@
expression x;
void* e;
type T;
identifier f;
@@

(
  *((T *)e)
|
  ((T *)x)[...]
|
  ((T *)x)->f
|
- (T *)
  e
)

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
---
To send to: Matthew Wilcox <matthew@wil.cx>,"James E.J. Bottomley" <JBottomley@parallels.com>,linux-scsi@vger.kernel.org,linux-kernel@vger.kernel.org
 drivers/scsi/sym53c8xx_2/sym_malloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_malloc.c b/drivers/scsi/sym53c8xx_2/sym_malloc.c
index 6f9af0d..1dde1e9 100644
--- a/drivers/scsi/sym53c8xx_2/sym_malloc.c
+++ b/drivers/scsi/sym53c8xx_2/sym_malloc.c
@@ -95,7 +95,7 @@ static void *___sym_malloc(m_pool_p mp, int size)
 		}
 	}
 #ifdef DEBUG
-	printf("___sym_malloc(%d) = %p\n", size, (void *) a);
+	printf("___sym_malloc(%d) = %p\n", size, a);
 #endif
 	return a;
 }
-- 
1.9.1

