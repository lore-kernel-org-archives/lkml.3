Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab3EYD1e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 23:27:34 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:43258 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409Ab3EYD1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 23:27:33 -0400
Message-ID: <51A02F9B.6020904@gmail.com>
Date: Sat, 25 May 2013 11:27:23 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Simon Horman <horms@verge.net.au>
CC: "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/7] Documentation/kdump/kdump.txt: Remove /dev/oldmem description
References: <51A02E50.5020507@gmail.com>
In-Reply-To: <51A02E50.5020507@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 Documentation/kdump/kdump.txt |   31 ++++++-------------------------
 1 files changed, 6 insertions(+), 25 deletions(-)

diff --git a/Documentation/kdump/kdump.txt b/Documentation/kdump/kdump.txt
index 9c7fd98..bec123e 100644
--- a/Documentation/kdump/kdump.txt
+++ b/Documentation/kdump/kdump.txt
@@ -47,19 +47,12 @@ parameter. Optionally the size of the ELF header can also be passed
 when using the elfcorehdr=[size[KMG]@]offset[KMG] syntax.
 
 
-With the dump-capture kernel, you can access the memory image, or "old
-memory," in two ways:
-
-- Through a /dev/oldmem device interface. A capture utility can read the
-  device file and write out the memory in raw format. This is a raw dump
-  of memory. Analysis and capture tools must be intelligent enough to
-  determine where to look for the right information.
-
-- Through /proc/vmcore. This exports the dump as an ELF-format file that
-  you can write out using file copy commands such as cp or scp. Further,
-  you can use analysis tools such as the GNU Debugger (GDB) and the Crash
-  tool to debug the dump file. This method ensures that the dump pages are
-  correctly ordered.
+With the dump-capture kernel, you can access the memory image through
+/proc/vmcore. This exports the dump as an ELF-format file that you can
+write out using file copy commands such as cp or scp. Further, you can
+use analysis tools such as the GNU Debugger (GDB) and the Crash tool to
+debug the dump file. This method ensures that the dump pages are correctly
+ordered.
 
 
 Setup and Installation
@@ -423,18 +416,6 @@ the following command:
 
    cp /proc/vmcore <dump-file>
 
-You can also access dumped memory as a /dev/oldmem device for a linear
-and raw view. To create the device, use the following command:
-
-    mknod /dev/oldmem c 1 12
-
-Use the dd command with suitable options for count, bs, and skip to
-access specific portions of the dump.
-
-To see the entire memory, use the following command:
-
-   dd if=/dev/oldmem of=oldmem.001
-
 
 Analysis
 ========
-- 
1.7.1
