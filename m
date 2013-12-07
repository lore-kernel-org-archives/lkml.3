Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab3LGC15 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 21:27:57 -0500
Received: from dmz-mailsec-scanner-3.mit.edu ([18.9.25.14]:45370 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754229Ab3LGC1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 21:27:55 -0500
X-AuditID: 1209190e-b7efb6d000000bb9-1d-52a287aa9cd2
Date: Fri, 6 Dec 2013 21:27:52 -0500
From: Greg Price <price@MIT.EDU>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Cc: linux-kernel@vger.kernel.org
Subject: [3.13 PATCH 1/2] random: entropy_bytes is actually bits
Message-ID: <20131207022751.GY16018@ringworld.MIT.EDU>
References: <cover.1386382885.git.price@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1386382885.git.price@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsUixCmqrbuqfVGQQdtaPovLu+awOTB6fN4k
	F8AYxWWTkpqTWZZapG+XwJWx6OpL1oIOrorPjyayNDB2cnQxcnJICJhInJz4jB3CFpO4cG89
	WxcjF4eQwGwmiX83HjGCJIQENjBKTOrjhbB/Mkqsv+AMYrMIqEi8X7WXDcRmE1CQ+DF/HTOI
	LSKgLLFq5iYmEJsZKP7r3iZWEFtYwEHi8Z6tYPW8AmYSSzuXsUHMNJBom3GPHSIuKHFy5hMW
	iF4tiRv/XgLN4QCypSWW/wO7mVPAUKL321GwElGgE6ac3MY2gVFwFpLuWUi6ZyF0L2BkXsUo
	m5JbpZubmJlTnJqsW5ycmJeXWqRrrJebWaKXmlK6iREcpJJ8Oxi/HlQ6xCjAwajEw1thsShI
	iDWxrLgy9xCjJAeTkiivextQiC8pP6UyI7E4I76oNCe1+BCjBAezkgjvTjWgHG9KYmVValE+
	TEqag0VJnPcmh32QkEB6YklqdmpqQWoRTFaGg0NJgrcXZKhgUWp6akVaZk4JQpqJgxNkOA/Q
	cFWQGt7igsTc4sx0iPwpRkUpcd4DIAkBkERGaR5cLyyJvGIUB3pFmFcDpIoHmIDgul8BDWYC
	Gtz8YB7I4JJEhJRUA2PjlhcbZS2D32gx53y/VLdLpG/2o8S1cw4Wl8ox3hYx4/wyd0EO4w8G
	2e7+PXY/m3eukS+7f3cTX+BFNquoC+c/iXh2561SXBd4YM977S7uGEMD7d1aXF3znuVYpH+6
	eUPR4eyDR3fCvnvOzpK3zq0LWrSpufru2w1zNzkcqG1pEmcXnBJ2zlOJpTgj0VCLuag4EQAN
	Gqq0/QIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable 'entropy_bytes' is set from an expression that actually
counts bits.  Fortunately it's also only compared to values that also
count bits.  Rename it accordingly.

Signed-off-by: Greg Price <price@mit.edu>
---
 drivers/char/random.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 429b75bb6..dc9b9af20 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -666,10 +666,10 @@ retry:
 				  r->entropy_total, _RET_IP_);
 
 	if (r == &input_pool) {
-		int entropy_bytes = entropy_count >> ENTROPY_SHIFT;
+		int entropy_bits = entropy_count >> ENTROPY_SHIFT;
 
 		/* should we wake readers? */
-		if (entropy_bytes >= random_read_wakeup_thresh) {
+		if (entropy_bits >= random_read_wakeup_thresh) {
 			wake_up_interruptible(&random_read_wait);
 			kill_fasync(&fasync, SIGIO, POLL_IN);
 		}
@@ -678,7 +678,7 @@ retry:
 		 * forth between them, until the output pools are 75%
 		 * full.
 		 */
-		if (entropy_bytes > random_write_wakeup_thresh &&
+		if (entropy_bits > random_write_wakeup_thresh &&
 		    r->initialized &&
 		    r->entropy_total >= 2*random_read_wakeup_thresh) {
 			static struct entropy_store *last = &blocking_pool;
-- 
1.8.3.2

