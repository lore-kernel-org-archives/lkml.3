Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbaJHTtr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 15:49:47 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:45959 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbaJHTtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 15:49:46 -0400
From: Peter Foley <pefoley2@pefoley.com>
To: linux-kernel@vger.kernel.org
Cc: rdunlap@infradead.org, jkosina@suse.cz, luto@amacapital.net, hpa@zytor.com,
        jwboyer@fedoraproject.org, linux-doc@vger.kernel.org,
        Peter Foley <pefoley2@pefoley.com>
Subject: [PATCH] Documentation: fix vdso_standalone_test_x86 on 32-bit
Date: Wed,  8 Oct 2014 15:49:24 -0400
Message-Id: <1412797764-11466-1-git-send-email-pefoley2@pefoley.com>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vdso_standalone_test_x86 needs -lgcc_s to build succesfully on 32bit.

Signed-off-by: Peter Foley <pefoley2@pefoley.com>
---
 Documentation/vDSO/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/vDSO/Makefile b/Documentation/vDSO/Makefile
index 2b99e57..5e5ad9f 100644
--- a/Documentation/vDSO/Makefile
+++ b/Documentation/vDSO/Makefile
@@ -10,3 +10,6 @@ always := $(hostprogs-y)
 HOSTCFLAGS := -I$(objtree)/usr/include -std=gnu99
 HOSTCFLAGS_vdso_standalone_test_x86.o := -fno-asynchronous-unwind-tables -fno-stack-protector
 HOSTLOADLIBES_vdso_standalone_test_x86 := -nostdlib
+ifeq($(CONFIG_X86_32),y)
+HOSTLOADLIBES_vdso_standalone_test_x86 += -lgcc_s
+endif
-- 
2.1.2

