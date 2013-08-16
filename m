Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435Ab3HPWjP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:39:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51597 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756399Ab3HPWjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:39:10 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Sandeen <sandeen@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 087/133] ext4: destroy ext4_es_cachep on module unload
Date: Fri, 16 Aug 2013 15:33:49 -0700
Message-Id: <1376692475-28413-88-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Sandeen <sandeen@redhat.com>

commit dd12ed144e9797094c04736f97aa27d5fe401476 upstream.

Without this, module can't be reloaded.

[  500.521980] kmem_cache_sanity_check (ext4_extent_status): Cache name already exists.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ext4/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index f036930..d757050 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5370,6 +5370,7 @@ static void __exit ext4_exit_fs(void)
 	kset_unregister(ext4_kset);
 	ext4_exit_system_zone();
 	ext4_exit_pageio();
+	ext4_exit_es();
 }
 
 MODULE_AUTHOR("Remy Card, Stephen Tweedie, Andrew Morton, Andreas Dilger, Theodore Ts'o and others");
-- 
1.8.1.2

