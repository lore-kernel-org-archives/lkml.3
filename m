Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbaCXHWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 03:22:20 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:55187 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbaCXHWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 03:22:17 -0400
From: Jakub Sitnicki <jsitnicki@gmail.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Sitnicki <jsitnicki@gmail.com>
Subject: [PATCH 2/2] ext4: acl: remove unneeded include of linux/capability.h
Date: Mon, 24 Mar 2014 08:22:12 +0100
Message-Id: <1395645732-26569-1-git-send-email-jsitnicki@gmail.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acl.c has not been (directly) using the interface defined by
linux/capability.h header since commit 3bd858ab1c451725c07a
("Introduce is_owner_or_cap() to wrap CAP_FOWNER use with fsuid
check"). Remove it.

Signed-off-by: Jakub Sitnicki <jsitnicki@gmail.com>
---
 fs/ext4/acl.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
index d40c8db..26e880e 100644
--- a/fs/ext4/acl.c
+++ b/fs/ext4/acl.c
@@ -7,7 +7,6 @@
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
-#include <linux/capability.h>
 #include <linux/fs.h>
 #include "ext4_jbd2.h"
 #include "ext4.h"
-- 
1.8.5.3

