Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbaFRQWK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 12:22:10 -0400
Received: from smtp2.macqel.be ([109.135.2.61]:57503 "EHLO smtp2.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779AbaFRQWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 12:22:08 -0400
X-Greylist: delayed 533 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Jun 2014 12:22:08 EDT
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org
Cc: Philippe De Muyter <phdm@macqel.be>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] init/do_mounts.c: treat EROFS like EACCES
Date: Wed, 18 Jun 2014 18:12:44 +0200
Message-Id: <1403107964-1082-1-git-send-email-phdm@macqel.be>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

some combinations of filesystem and block device (at least vfat on mmc)
yield -EROFS instead of -EACCES when the device is read-only.  Retry
mounting with MS_RDONLY set, just like for the EACCES case, instead of
failing directly.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 init/do_mounts.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index 82f2288..af7b9b8 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -394,6 +394,7 @@ retry:
 			case 0:
 				goto out;
 			case -EACCES:
+			case -EROFS:
 				flags |= MS_RDONLY;
 				goto retry;
 			case -EINVAL:
-- 
1.7.5.3

