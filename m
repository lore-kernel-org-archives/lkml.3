Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbaC1RiF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 13:38:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51433 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbaC1RbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 13:31:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Jones <davej@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        Paul Mackerras <paulus@samba.org>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.13 34/46] fs/proc/proc_devtree.c: remove empty /proc/device-tree when no openfirmware exists.
Date: Fri, 28 Mar 2014 10:32:18 -0700
Message-Id: <20140328173139.299972241@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140328173134.630198216@linuxfoundation.org>
References: <20140328173134.630198216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/proc/proc_devtree.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/proc/proc_devtree.c
+++ b/fs/proc/proc_devtree.c
@@ -232,6 +232,7 @@ void __init proc_device_tree_init(void)
 		return;
 	root = of_find_node_by_path("/");
 	if (root == NULL) {
+		remove_proc_entry("device-tree", NULL);
 		pr_debug("/proc/device-tree: can't find root\n");
 		return;
 	}


