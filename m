Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab3LRGkE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 01:40:04 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:39546 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320Ab3LRGkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 01:40:01 -0500
Date: Wed, 18 Dec 2013 12:09:53 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, josh@joshtriplett.org
Subject: [PATCH] drivers: base: Add prototype declaration in memory.c
Message-ID: <20131218063953.GA3180@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the prototype declaration of function memory_block_size_bytes() in
memory.c.

This eliminates the following warning in memory.c:
drivers/base/memory.c:87:1: warning: no previous prototype for ‘memory_block_size_bytes’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/base/memory.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index bece691..cfa03de 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -83,6 +83,7 @@ static void memory_block_release(struct device *dev)
 	kfree(mem);
 }
 
+unsigned long __weak memory_block_size_bytes(void);
 unsigned long __weak memory_block_size_bytes(void)
 {
 	return MIN_MEMORY_BLOCK_SIZE;
-- 
1.7.9.5

