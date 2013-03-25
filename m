Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354Ab3CYLCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 07:02:33 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36605 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756939Ab3CYLCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 07:02:30 -0400
From: zhouzhouyi@gmail.com
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, vgoyal@redhat.com, yizhouzhou@ict.ac.cn
Subject: [PATCH 1/1 v1] the recommended crash memory reservation is too small for x86_64.
Date: Mon, 25 Mar 2013 18:56:49 +0800
Message-Id: <1364209009-11592-1-git-send-email-zhouzhouyi@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: root <root@zzy-Lenovo.(none)>


 On Documentation/kdump/kdump.txt, section Boot into  System Kernel: On x86 and x86_64, use
 "crashkernel=64M@16M", but some OSes like ubuntu 12.10 use ram fs larger than 64M, so in these cases the
 memory reserved for crashkernel should be at least 128M.


Signed-off-by: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
---
 Documentation/kdump/kdump.txt |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/kdump/kdump.txt b/Documentation/kdump/kdump.txt
index 13f1aa0..1e850e0 100644
--- a/Documentation/kdump/kdump.txt
+++ b/Documentation/kdump/kdump.txt
@@ -290,7 +290,9 @@ Boot into System Kernel
    "crashkernel=64M@16M" tells the system kernel to reserve 64 MB of memory
    starting at physical address 0x01000000 (16MB) for the dump-capture kernel.
 
-   On x86 and x86_64, use "crashkernel=64M@16M".
+   On x86 and x86_64, use "crashkernel=64M@16M" (some OSes use init ram fs larger
+than 64M, for example ubuntu-12.10, use crashkernel=128M@16M instead, or dump-capture
+kernel will out of memory).
 
    On ppc64, use "crashkernel=128M@32M".
 
-- 
1.7.10.4

