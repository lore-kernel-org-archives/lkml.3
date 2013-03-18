Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702Ab3CRVKP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:10:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46053 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756311Ab3CRVKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:10:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>, Jan Kara <jack@suse.cz>
Subject: [ 12/40] ext3: Fix format string issues
Date: Mon, 18 Mar 2013 14:10:50 -0700
Message-Id: <20130318211017.148730823@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318211016.254453918@linuxfoundation.org>
References: <20130318211016.254453918@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext3/super.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -371,7 +371,7 @@ static struct block_device *ext3_blkdev_
 	return bdev;
 
 fail:
-	ext3_msg(sb, "error: failed to open journal device %s: %ld",
+	ext3_msg(sb, KERN_ERR, "error: failed to open journal device %s: %ld",
 		__bdevname(dev, b), PTR_ERR(bdev));
 
 	return NULL;
@@ -892,7 +892,7 @@ static ext3_fsblk_t get_sb_block(void **
 	/*todo: use simple_strtoll with >32bit ext3 */
 	sb_block = simple_strtoul(options, &options, 0);
 	if (*options && *options != ',') {
-		ext3_msg(sb, "error: invalid sb specification: %s",
+		ext3_msg(sb, KERN_ERR, "error: invalid sb specification: %s",
 		       (char *) *data);
 		return 1;
 	}


