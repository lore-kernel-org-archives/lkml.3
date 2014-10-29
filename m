Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934262AbaJ2PvH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:51:07 -0400
Received: from mx.mylinuxtime.de ([148.251.109.235]:52366 "EHLO
	mx.mylinuxtime.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933822AbaJ2PvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:51:05 -0400
X-Greylist: delayed 363 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Oct 2014 11:51:05 EDT
DKIM-Filter: OpenDKIM Filter v2.9.2 mx.mylinuxtime.de 30B51215F2
From: Christian Hesse <mail@eworm.de>
To: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Christian Hesse <mail@eworm.de>
Subject: [PATCH 1/1] Documentation: image containing ucode needs to be uncompressed
Date: Wed, 29 Oct 2014 16:44:18 +0100
Message-Id: <1414597458-8938-1-git-send-email-mail@eworm.de>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While the regular initramfs is allowed to be compressed, the image
containing microcode is not.

Signed-off-by: Christian Hesse <mail@eworm.de>
---
 Documentation/x86/early-microcode.txt | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/x86/early-microcode.txt b/Documentation/x86/early-microcode.txt
index d62bea6..da6ded3 100644
--- a/Documentation/x86/early-microcode.txt
+++ b/Documentation/x86/early-microcode.txt
@@ -8,9 +8,10 @@ can fix CPU issues before they are observed during kernel boot time.
 Microcode is stored in an initrd file. The microcode is read from the initrd
 file and loaded to CPUs during boot time.
 
-The format of the combined initrd image is microcode in cpio format followed by
-the initrd image (maybe compressed). Kernel parses the combined initrd image
-during boot time. The microcode file in cpio name space is:
+The format of the combined initrd image is microcode in uncompressed
+cpio format followed by the initrd image (maybe compressed). Kernel
+parses the combined initrd image during boot time. The microcode file in
+cpio name space is:
 on Intel: kernel/x86/microcode/GenuineIntel.bin
 on AMD  : kernel/x86/microcode/AuthenticAMD.bin
 
-- 
2.1.2

