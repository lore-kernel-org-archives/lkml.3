Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420AbaHAWN3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 18:13:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53401 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755872AbaHAWNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 18:13:25 -0400
Date: Fri, 1 Aug 2014 15:12:39 -0700
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-5e3bf215f4f2efc0af89e6dbc5da789744aeb5d7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        oren@scalemp.com, shai@scalemp.com, tglx@linutronix.de,
        hpa@linux.intel.com, fengguang.wu@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        oren@scalemp.com, shai@scalemp.com, tglx@linutronix.de,
        hpa@linux.intel.com, fengguang.wu@intel.com
In-Reply-To: <1404036068-11674-1-git-send-email-oren@scalemp.com>
References: <1404036068-11674-1-git-send-email-oren@scalemp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/apic/vsmp: Make is_vsmp_box() static
Git-Commit-ID: 5e3bf215f4f2efc0af89e6dbc5da789744aeb5d7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5e3bf215f4f2efc0af89e6dbc5da789744aeb5d7
Gitweb:     http://git.kernel.org/tip/5e3bf215f4f2efc0af89e6dbc5da789744aeb5d7
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Fri, 1 Aug 2014 14:47:56 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 1 Aug 2014 15:09:45 -0700

x86/apic/vsmp: Make is_vsmp_box() static

Since checkin

411cf9ee2946 x86, vsmp: Remove is_vsmp_box() from apic_is_clustered_box()

... is_vsmp_box() is only used in vsmp_64.c and does not have any
header file declaring it, so make it explicitly static.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Cc: Shai Fultheim <shai@scalemp.com>
Cc: Oren Twaig <oren@scalemp.com>
Link: http://lkml.kernel.org/r/1404036068-11674-1-git-send-email-oren@scalemp.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/vsmp_64.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
index b99b9ad..ee22c1d 100644
--- a/arch/x86/kernel/vsmp_64.c
+++ b/arch/x86/kernel/vsmp_64.c
@@ -152,7 +152,7 @@ static void __init detect_vsmp_box(void)
 		is_vsmp = 1;
 }
 
-int is_vsmp_box(void)
+static int is_vsmp_box(void)
 {
 	if (is_vsmp != -1)
 		return is_vsmp;
@@ -166,7 +166,7 @@ int is_vsmp_box(void)
 static void __init detect_vsmp_box(void)
 {
 }
-int is_vsmp_box(void)
+static int is_vsmp_box(void)
 {
 	return 0;
 }
