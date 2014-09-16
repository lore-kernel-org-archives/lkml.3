Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbaIPV5D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 17:57:03 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:48457 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbaIPV5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 17:57:00 -0400
From: Darren Hart <dvhart@infradead.org>
To: Randy Dunlap <rdunlap@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Azael Avalos <coproscefalo@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Frans Klaver <fransklaver@gmail.com>
Subject: [PATCH] Documentation/sysfs-rules.txt: Add device attribute error code documentation
Date: Tue, 16 Sep 2014 14:56:37 -0700
Message-Id: <933ed4c751511b0b4a6665b7d4ca90d54d1111cb.1410904597.git.dvhart@linux.intel.com>
X-Mailer: git-send-email 2.1.0.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Darren Hart <dvhart@linux.intel.com>

Provide some entry-level statements about what to expect from sysfs
device attribute read/store return codes, both for users and kernel
developers.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Azael Avalos <coproscefalo@gmail.com>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Frans Klaver <fransklaver@gmail.com>
---
 Documentation/sysfs-rules.txt | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/Documentation/sysfs-rules.txt b/Documentation/sysfs-rules.txt
index a5f985e..ce60ffa 100644
--- a/Documentation/sysfs-rules.txt
+++ b/Documentation/sysfs-rules.txt
@@ -161,3 +161,24 @@ versions of the sysfs interface.
   the device that matches the expected subsystem. Depending on a specific
   position of a parent device or exposing relative paths using "../" to
   access the chain of parents is a bug in the application.
+
+- When reading and writing sysfs device attribute files, avoid dependency
+  on specific error codes wherever possible. This minimizes coupling to
+  the error handling implementation within the kernel.
+
+  In general, failures to read or write sysfs device attributes shall
+  propagate errors wherever possible. Common errors include, but are not
+  limited to:
+
+  -EIO: The read or store operation is not supported, typically returned by
+        the sysfs system itself if the read or store pointer is NULL.
+
+  -ENXIO: The read or store operation failed
+
+  Error codes will not be changed without good reason, and should a change
+  to error codes result in user-space breakage, it will be fixed, or the
+  the offending change will be reverted.
+
+  Userspace applications can, however, expect the format and contents of
+  the attribute files to remain consistent in the absence of a version
+  attribute change in the context of a given attribute.
-- 
2.1.0.rc1

