Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759721Ab3FNCj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 22:39:28 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:47943 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759702Ab3FNCjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 22:39:24 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [Trivial PATCH 08/33] x86: vdso: Convert use of typedef ctl_table to struct ctl_table
Date: Thu, 13 Jun 2013 19:37:33 -0700
Message-Id: <a756fa0060e8eea25e8c1863c2764e86c2823617.1371177118.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1371177118.git.joe@perches.com>
References: <cover.1371177118.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/x86/vdso/vdso32-setup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index 0faad64..d6bfb87 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -372,7 +372,7 @@ subsys_initcall(sysenter_setup);
 /* Register vsyscall32 into the ABI table */
 #include <linux/sysctl.h>
 
-static ctl_table abi_table2[] = {
+static struct ctl_table abi_table2[] = {
 	{
 		.procname	= "vsyscall32",
 		.data		= &sysctl_vsyscall32,
@@ -383,7 +383,7 @@ static ctl_table abi_table2[] = {
 	{}
 };
 
-static ctl_table abi_root_table2[] = {
+static struct ctl_table abi_root_table2[] = {
 	{
 		.procname = "abi",
 		.mode = 0555,
-- 
1.8.1.2.459.gbcd45b4.dirty

