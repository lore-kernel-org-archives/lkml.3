Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbaIHWzP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 18:55:15 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:37942 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755330AbaIHWzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 18:55:11 -0400
From: Peter Foley <pefoley2@pefoley.com>
To: linux-kernel@vger.kernel.org, rdunlap@infradead.org,
        linux-doc@vger.kernel.org
Cc: Peter Foley <pefoley2@pefoley.com>
Subject: [PATCH 2/2] [PATCH] Documentation: update vDSO makefile to build portable examples
Date: Mon,  8 Sep 2014 18:55:00 -0400
Message-Id: <1410216900-22390-2-git-send-email-pefoley2@pefoley.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410216900-22390-1-git-send-email-pefoley2@pefoley.com>
References: <1410216900-22390-1-git-send-email-pefoley2@pefoley.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter Foley <pefoley2@pefoley.com>
---
 Documentation/vDSO/Makefile | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/Documentation/vDSO/Makefile b/Documentation/vDSO/Makefile
index 6cbd612..d87bb29 100644
--- a/Documentation/vDSO/Makefile
+++ b/Documentation/vDSO/Makefile
@@ -1,9 +1,12 @@
 # List of programs to build
-hostprogs-$(CONFIG_X86) := vdso_test
+hostprogs-y := vdso_test
+hostprogs-$(CONFIG_X86) := vdso_standalone_test_x86
+vdso_standalone_test_x86-objs := vdso_standalone_test_x86.o parse_vdso.o
 vdso_test-objs := parse_vdso.o vdso_test.o
 
 # Tell kbuild to always build the programs
-##always := $(hostprogs-y)
+always := $(hostprogs-y)
 
 HOSTCFLAGS := -I$(objtree)/usr/include -std=gnu99
-HOSTLDFLAGS = -nostdlib -fno-asynchronous-unwind-tables
+HOSTCFLAGS_vdso_standalone_test_x86.o := -fno-asynchronous-unwind-tables -fno-stack-protector
+HOSTLOADLIBES_vdso_standalone_test_x86 := -nostdlib
-- 
2.1.0

