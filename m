Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab3LGC2L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 21:28:11 -0500
Received: from dmz-mailsec-scanner-5.mit.edu ([18.7.68.34]:64941 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754913Ab3LGC2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 21:28:06 -0500
X-AuditID: 12074422-b7f9d6d000000bc0-a6-52a287b56a11
Date: Fri, 6 Dec 2013 21:28:03 -0500
From: Greg Price <price@MIT.EDU>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] random: clarify bits/bytes in wakeup thresholds
Message-ID: <20131207022803.GZ16018@ringworld.MIT.EDU>
References: <cover.1386382885.git.price@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1386382885.git.price@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsUixG6nrru1fVGQwZoWTYvLu+awOTB6fN4k
	F8AYxWWTkpqTWZZapG+XwJVx531wwXW1ip7dF9gaGHvkuxg5OSQETCSa+uYzQthiEhfurWfr
	YuTiEBKYzSTx7M1GFghnA6PE5/MHmCCcn4wSK+6tZQZpYRFQkbjUsQGsnU1AQeLH/HVgcREB
	ZYlVMzcxgdjMQPFf9zaxgtjCAi4Sn1bvB7N5BcwkFn3vZwexhQQMJNpm3GOHiAtKnJz5hAWi
	V0vixr+XQHM4gGxpieX/OEDCnAKGEr3fjoKViAKdMOXkNrYJjIKzkHTPQtI9C6F7ASPzKkbZ
	lNwq3dzEzJzi1GTd4uTEvLzUIl1TvdzMEr3UlNJNjOAwdVHawfjzoNIhRgEORiUe3gtWi4KE
	WBPLiitzDzFKcjApifK6twGF+JLyUyozEosz4otKc1KLDzFKcDArifDuVAPK8aYkVlalFuXD
	pKQ5WJTEeW9x2AcJCaQnlqRmp6YWpBbBZGU4OJQkeE+BDBUsSk1PrUjLzClBSDNxcIIM5wEa
	nghSw1tckJhbnJkOkT/FqCglznsAJCEAksgozYPrhaWRV4ziQK8I894GqeIBpiC47ldAg5mA
	Bjc/mAcyuCQRISXVwKjuejWj1zLkTqmiQdClh+ey3vT1TnzgukZir1w3p83+IssQv23LSwMZ
	5rbcOr+ikyvzfHBOyo7Uv41W5ubvpJgL+PZ/0rI9UXP7e3H1zlVcaZpKriqfVPPZ3OvvsBmH
	z3uaYbPIWin2uWJIV/vHz3evTowuWfjlqQFbbrlIjcvuR299J/5iUGIpzkg01GIuKk4EALls
	sBn+AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are a recurring cause of confusion, so rename them to
hopefully be clearer.

Signed-off-by: Greg Price <price@mit.edu>
---
 drivers/char/random.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index dc9b9af20..3f87a7e88 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -295,14 +295,14 @@
  * The minimum number of bits of entropy before we wake up a read on
  * /dev/random.  Should be enough to do a significant reseed.
  */
-static int random_read_wakeup_thresh = 64;
+static int random_read_wakeup_bits = 64;
 
 /*
  * If the entropy count falls under this number of bits, then we
  * should wake up processes which are selecting or polling on write
  * access to /dev/random.
  */
-static int random_write_wakeup_thresh = 28 * OUTPUT_POOL_WORDS;
+static int random_write_wakeup_bits = 28 * OUTPUT_POOL_WORDS;
 
 /*
  * The minimum number of seconds between urandom pool resending.  We
@@ -669,7 +669,7 @@ retry:
 		int entropy_bits = entropy_count >> ENTROPY_SHIFT;
 
 		/* should we wake readers? */
-		if (entropy_bits >= random_read_wakeup_thresh) {
+		if (entropy_bits >= random_read_wakeup_bits) {
 			wake_up_interruptible(&random_read_wait);
 			kill_fasync(&fasync, SIGIO, POLL_IN);
 		}
@@ -678,9 +678,9 @@ retry:
 		 * forth between them, until the output pools are 75%
 		 * full.
 		 */
-		if (entropy_bits > random_write_wakeup_thresh &&
+		if (entropy_bits > random_write_wakeup_bits &&
 		    r->initialized &&
-		    r->entropy_total >= 2*random_read_wakeup_thresh) {
+		    r->entropy_total >= 2*random_read_wakeup_bits) {
 			static struct entropy_store *last = &blocking_pool;
 			struct entropy_store *other = &blocking_pool;
 
@@ -924,19 +924,19 @@ static void _xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
 {
 	__u32	tmp[OUTPUT_POOL_WORDS];
 
-	/* For /dev/random's pool, always leave two wakeup worth's BITS */
-	int rsvd = r->limit ? 0 : random_read_wakeup_thresh/4;
+	/* For /dev/random's pool, always leave two wakeups' worth */
+	int rsvd_bytes = r->limit ? 0 : random_read_wakeup_bits / 4;
 	int bytes = nbytes;
 
-	/* pull at least as many as BYTES as wakeup BITS */
-	bytes = max_t(int, bytes, random_read_wakeup_thresh / 8);
+	/* pull at least as much as a wakeup */
+	bytes = max_t(int, bytes, random_read_wakeup_bits / 8);
 	/* but never more than the buffer size */
 	bytes = min_t(int, bytes, sizeof(tmp));
 
 	trace_xfer_secondary_pool(r->name, bytes * 8, nbytes * 8,
 				  ENTROPY_BITS(r), ENTROPY_BITS(r->pull));
 	bytes = extract_entropy(r->pull, tmp, bytes,
-				random_read_wakeup_thresh / 8, rsvd);
+				random_read_wakeup_bits / 8, rsvd_bytes);
 	mix_pool_bytes(r, tmp, bytes, NULL);
 	credit_entropy_bits(r, bytes*8);
 }
@@ -952,7 +952,7 @@ static void push_to_pool(struct work_struct *work)
 	struct entropy_store *r = container_of(work, struct entropy_store,
 					      push_work);
 	BUG_ON(!r);
-	_xfer_secondary_pool(r, random_read_wakeup_thresh/8);
+	_xfer_secondary_pool(r, random_read_wakeup_bits/8);
 	trace_push_to_pool(r->name, r->entropy_count >> ENTROPY_SHIFT,
 			   r->pull->entropy_count >> ENTROPY_SHIFT);
 }
@@ -1004,7 +1004,7 @@ retry:
 			goto retry;
 
 		if ((r->entropy_count >> ENTROPY_SHIFT)
-		    < random_write_wakeup_thresh)
+		    < random_write_wakeup_bits)
 			wakeup_write = 1;
 	}
 	spin_unlock_irqrestore(&r->lock, flags);
@@ -1313,7 +1313,7 @@ random_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 
 			wait_event_interruptible(random_read_wait,
 				ENTROPY_BITS(&input_pool) >=
-				random_read_wakeup_thresh);
+				random_read_wakeup_bits);
 
 			if (signal_pending(current)) {
 				retval = -ERESTARTSYS;
@@ -1358,9 +1358,9 @@ random_poll(struct file *file, poll_table * wait)
 	poll_wait(file, &random_read_wait, wait);
 	poll_wait(file, &random_write_wait, wait);
 	mask = 0;
-	if (ENTROPY_BITS(&input_pool) >= random_read_wakeup_thresh)
+	if (ENTROPY_BITS(&input_pool) >= random_read_wakeup_bits)
 		mask |= POLLIN | POLLRDNORM;
-	if (ENTROPY_BITS(&input_pool) < random_write_wakeup_thresh)
+	if (ENTROPY_BITS(&input_pool) < random_write_wakeup_bits)
 		mask |= POLLOUT | POLLWRNORM;
 	return mask;
 }
@@ -1583,7 +1583,7 @@ struct ctl_table random_table[] = {
 	},
 	{
 		.procname	= "read_wakeup_threshold",
-		.data		= &random_read_wakeup_thresh,
+		.data		= &random_read_wakeup_bits,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
@@ -1592,7 +1592,7 @@ struct ctl_table random_table[] = {
 	},
 	{
 		.procname	= "write_wakeup_threshold",
-		.data		= &random_write_wakeup_thresh,
+		.data		= &random_write_wakeup_bits,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-- 
1.8.3.2
