Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbaIQAJt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 20:09:49 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:36229 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502AbaIQAJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 20:09:48 -0400
From: Peter Foley <pefoley2@pefoley.com>
To: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        rdunlap@infradead.org
Cc: sfr@canb.auug.org.au, Peter Foley <pefoley2@pefoley.com>
Subject: [PATCH] Documentation: disable vdso_test to avoid breakage with old glibc
Date: Tue, 16 Sep 2014 20:09:25 -0400
Message-Id: <1410912565-26085-1-git-send-email-pefoley2@pefoley.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

glibc versions older than 2.16 don't include sys/auxv.h which this
executable uses.
Since we don't have a good way to test for specific glibc versions in
kbuild, just disable it for now.

Signed-off-by: Peter Foley <pefoley2@pefoley.com>
---
 Documentation/vDSO/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/vDSO/Makefile b/Documentation/vDSO/Makefile
index d87bb29..2b99e57 100644
--- a/Documentation/vDSO/Makefile
+++ b/Documentation/vDSO/Makefile
@@ -1,5 +1,5 @@
-# List of programs to build
-hostprogs-y := vdso_test
+# vdso_test won't build for glibc < 2.16, so disable it
+# hostprogs-y := vdso_test
 hostprogs-$(CONFIG_X86) := vdso_standalone_test_x86
 vdso_standalone_test_x86-objs := vdso_standalone_test_x86.o parse_vdso.o
 vdso_test-objs := parse_vdso.o vdso_test.o
-- 
2.1.0

