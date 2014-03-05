Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446AbaCEO0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:26:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41141 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757383AbaCEO0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:26:30 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Jones <davej@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        Paul Mackerras <paulus@samba.org>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 085/131] fs/proc/proc_devtree.c: remove empty /proc/device-tree when no openfirmware exists.
Date: Wed,  5 Mar 2014 14:23:29 +0000
Message-Id: <1394029455-23128-86-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jones <davej@redhat.com>

commit c1d867a54d426b45da017fbe8e585f8a3064ce8d upstream.

Distribution kernels might want to build in support for /proc/device-tree
for kernels that might end up running on hardware that doesn't support
openfirmware.  This results in an empty /proc/device-tree existing.
Remove it if the OFW root node doesn't exist.

This situation actually confuses grub2, resulting in install failures.
grub2 sees the /proc/device-tree and picks the wrong install target cf.
http://bzr.savannah.gnu.org/lh/grub/trunk/grub/annotate/4300/util/grub-install.in#L311
grub should be more robust, but still, leaving an empty proc dir seems
pointless.

Addresses https://bugzilla.redhat.com/show_bug.cgi?id=818378.

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/proc/proc_devtree.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/proc/proc_devtree.c b/fs/proc/proc_devtree.c
index 106a835..9fa2154 100644
--- a/fs/proc/proc_devtree.c
+++ b/fs/proc/proc_devtree.c
@@ -235,6 +235,7 @@ void __init proc_device_tree_init(void)
 		return;
 	root = of_find_node_by_path("/");
 	if (root == NULL) {
+		remove_proc_entry("device-tree", NULL);
 		pr_debug("/proc/device-tree: can't find root\n");
 		return;
 	}
-- 
1.9.0

