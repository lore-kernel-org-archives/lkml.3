Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab3KHAEL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 19:04:11 -0500
Received: from dmz-mailsec-scanner-8.mit.edu ([18.7.68.37]:46263 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756037Ab3KHADq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 19:03:46 -0500
X-AuditID: 12074425-b7fc88e000004601-f7-527c292d2363
Date: Thu, 7 Nov 2013 18:58:35 -0500
From: Greg Price <price@MIT.EDU>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 03/11] random: fix description of get_random_bytes
Message-ID: <20131107235834.GF16018@ringworld.MIT.EDU>
References: <cover.1383868558.git.price@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1383868558.git.price@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsUixCmqraurWRNkMPkyq8XlXXPYHBg9Pm+S
	C2CM4rJJSc3JLEst0rdL4Mp4ev4EU0ErZ8XshaeYGhh3sncxcnJICJhIvJz4jxHCFpO4cG89
	G4gtJDCbSeLM9YouRi4gewOjxNrG+ywQzk9GiYYJfcwgVSwCKhILHy8Gm8QmoCDxY/46sLiI
	gLLEqpmbmEBsZqD4r3ubWEFsYQEnib4/R8HivAJmEs/ar7NCbDOQ+Dn9LQtEXFDi5MwnLBC9
	WhI3/r0EqucAsqUllv/jAAlzChhKtDdfAWsVBTphysltbBMYBWch6Z6FpHsWQvcCRuZVjLIp
	uVW6uYmZOcWpybrFyYl5ealFuhZ6uZkleqkppZsYQWHK7qK6g3HCIaVDjAIcjEo8vAUXqoOE
	WBPLiitzDzFKcjApifJOVK8JEuJLyk+pzEgszogvKs1JLT7EKMHBrCTC+0wRKMebklhZlVqU
	D5OS5mBREue9xWEfJCSQnliSmp2aWpBaBJOV4eBQkuD9ADJUsCg1PbUiLTOnBCHNxMEJMpwH
	aLisBsjw4oLE3OLMdIj8KUZFKXHe7yDNAiCJjNI8uF5YGnnFKA70ijCvCkg7DzAFwXW/AhrM
	BDQ45FclyOCSRISUVANjyLWAvWK/uCZrF5ycOOfqxl7Bj5tuqP68yTyRI9Ff89wZgYkJpf1u
	zBwXf8xz/Le55WNh5J3Yvrgvkga8E3X/9b54vcp98nyd3U51Jas3FF+6Y3Uub739i8c7mT9a
	PzCsveAcyvFfTlnuWMok0cKvBbfSdrxZM3vTp6lsQtIHv+h6vz5633i9uRJLcUaioRZzUXEi
	AN8WPf7+AgAA
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
index a89ba74..d1466c9 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1048,8 +1048,9 @@ static ssize_t extract_entropy_user(struct entropy_store *r, void __user *buf,
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

