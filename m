Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780Ab3KMIHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 03:07:50 -0500
Received: from dmz-mailsec-scanner-5.mit.edu ([18.7.68.34]:64046 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758639Ab3KMIHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 03:07:37 -0500
X-AuditID: 12074422-b7f9d6d000000bc0-71-528333493d2a
Date: Wed, 13 Nov 2013 03:07:32 -0500
From: Greg Price <price@MIT.EDU>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/9] random: fix description of get_random_bytes
Message-ID: <20131113080732.GQ16018@ringworld.MIT.EDU>
References: <cover.1384329436.git.price@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1384329436.git.price@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsUixCmqretp3Bxk8GkXp8XlXXPYHBg9Pm+S
	C2CM4rJJSc3JLEst0rdL4Mo4/qOPpaCVs2LJ3G3sDYw72bsYOTkkBEwk/t/eAmWLSVy4t56t
	i5GLQ0hgNpPEh2vtrBDORkaJO3e3s4BUCQn8YpR4PS8ZxGYRUJVY3nqXFcRmE1CQ+DF/HTOI
	LSKgLLFq5iYmEJsZKP7r3iawGmEBB4mpJxuANnBw8AqYSaxrjYEYaSCxcf8EsFZeAUGJkzOf
	sEC0aknc+PeSCaScWUBaYvk/DpAwp4ChxKQNR8EmigqoSEw5uY1tAqPgLCTds5B0z0LoXsDI
	vIpRNiW3Sjc3MTOnODVZtzg5MS8vtUjXVC83s0QvNaV0EyMoSNldlHYw/jyodIhRgINRiYfX
	IqYpSIg1say4MvcQoyQHk5Ior5NOc5AQX1J+SmVGYnFGfFFpTmrxIUYJDmYlEd4DwkA53pTE
	yqrUonyYlDQHi5I47y0O+yAhgfTEktTs1NSC1CKYrAwHh5IEr4URUKNgUWp6akVaZk4JQpqJ
	gxNkOA/QcBGQGt7igsTc4sx0iPwpRkUpcd4YkIQASCKjNA+uF5ZEXjGKA70izCsKUsUDTEBw
	3a+ABjMBDbYobgIZXJKIkJJqYOTcOuXhxdLm1b5vQ2996j7alaasIsGvGvSiLLut2ji8gt//
	sKP0RbMVz3wK4pTfrDv/xGTX47Wzk4UnJy7kbGRwL/pVy8ztcrLKItJi5705r/ZkVM0L2VWx
	44Gw09pdN+QEnlw9s+FE+vGq2KMH5UqMF+VkTTtR4LzcTV9Yda/gDU7OxGtanUosxRmJhlrM
	RcWJAMVIczr9AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After this remark was written, commit d2e7c96af added a use of
arch_get_random_long() inside the get_random_bytes codepath.
The main point stands, but it needs to be reworded.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Price <price@mit.edu>
---
 drivers/char/random.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index e11ee4e..6d3627d 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1174,8 +1174,9 @@ static ssize_t extract_entropy_user(struct entropy_store *r, void __user *buf,
 /*
  * This function is the exported kernel interface.  It returns some
  * number of good random numbers, suitable for key generation, seeding
- * TCP sequence numbers, etc.  It does not use the hw random number
- * generator, if available; use get_random_bytes_arch() for that.
+ * TCP sequence numbers, etc.  It does not rely on the hardware random
+ * number generator.  For random bytes direct from the hardware RNG
+ * (when available), use get_random_bytes_arch().
  */
 void get_random_bytes(void *buf, int nbytes)
 {
-- 
1.8.3.2

