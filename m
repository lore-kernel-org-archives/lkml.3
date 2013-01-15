Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab3AOV2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 16:28:19 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:50621 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756106Ab3AOV1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 16:27:36 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 2/4] Export get_random_int()
Date: Tue, 15 Jan 2013 13:25:40 -0800
Message-Id: <1358285142-10576-2-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1358285142-10576-1-git-send-email-koverstreet@google.com>
References: <1358285142-10576-1-git-send-email-koverstreet@google.com>
In-Reply-To: <20130114223202.GV26407@google.com>
References: <20130114223202.GV26407@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Needed for bcache - need a cheap source of random numbers for perturbing
IO sizes, for rate limiting IO to the SSD.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: "Theodore Ts'o" <tytso@mit.edu>
---
 drivers/char/random.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 85e81ec..d6f673e 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1481,6 +1481,7 @@ unsigned int get_random_int(void)
 
 	return ret;
 }
+EXPORT_SYMBOL(get_random_int);
 
 /*
  * randomize_range() returns a start address such that
-- 
1.7.12

