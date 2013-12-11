Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946Ab3LKCJf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 21:09:35 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:33699 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab3LKCJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 21:09:33 -0500
Message-ID: <52A7C9D9.4080308@gmail.com>
Date: Wed, 11 Dec 2013 10:11:37 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Seth Jennings <sjennings@variantweb.net>
CC: Seth Jennings <sjenning@linux.vnet.ibm.com>, linux-mm@kvack.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v2] mm/zswap.c: add BUG() for default case in zswap_writeback_entry()
References: <52A53024.9090701@gmail.com> <20131209153626.GA3752@cerebellum.variantweb.net> <52A67973.20904@gmail.com>
In-Reply-To: <52A67973.20904@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recommend to add default case to avoid compiler's warning, although at
present, the original implementation is still correct.

The related warning (with allmodconfig for metag):

    CC      mm/zswap.o
  mm/zswap.c: In function 'zswap_writeback_entry':
  mm/zswap.c:537: warning: 'ret' may be used uninitialized in this function


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 mm/zswap.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 5a63f78..f58a001 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -585,6 +585,10 @@ static int zswap_writeback_entry(struct zbud_pool *pool, unsigned long handle)
 
 		/* page is up to date */
 		SetPageUptodate(page);
+		break;
+
+	default:
+		BUG();
 	}
 
 	/* move it to the tail of the inactive list after end_writeback */
-- 
1.7.7.6
