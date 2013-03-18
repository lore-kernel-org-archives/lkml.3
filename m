Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab3CREbq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:31:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33607 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752008Ab3CREar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:30:47 -0400
Message-Id: <20130318042149.650481196@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:22:40 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Lars-Peter Clausen <lars@metafoo.de>,
        Jan Kara <jack@suse.cz>
Subject: [ 56/82] ext3: Fix format string issues
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit 8d0c2d10dd72c5292eda7a06231056a4c972e4cc upstream.

ext3_msg() takes the printk prefix as the second parameter and the
format string as the third parameter. Two callers of ext3_msg omit the
prefix and pass the format string as the second parameter and the first
parameter to the format string as the third parameter. In both cases
this string comes from an arbitrary source. Which means the string may
contain format string characters, which will
lead to undefined and potentially harmful behavior.

The issue was introduced in commit 4cf46b67eb("ext3: Unify log messages
in ext3") and is fixed by this patch.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext3/super.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -374,7 +374,7 @@ static struct block_device *ext3_blkdev_
 	return bdev;
 
 fail:
-	ext3_msg(sb, "error: failed to open journal device %s: %ld",
+	ext3_msg(sb, KERN_ERR, "error: failed to open journal device %s: %ld",
 		__bdevname(dev, b), PTR_ERR(bdev));
 
 	return NULL;
@@ -902,7 +902,7 @@ static ext3_fsblk_t get_sb_block(void **
 	/*todo: use simple_strtoll with >32bit ext3 */
 	sb_block = simple_strtoul(options, &options, 0);
 	if (*options && *options != ',') {
-		ext3_msg(sb, "error: invalid sb specification: %s",
+		ext3_msg(sb, KERN_ERR, "error: invalid sb specification: %s",
 		       (char *) *data);
 		return 1;
 	}


