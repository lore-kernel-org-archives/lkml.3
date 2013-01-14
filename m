Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671Ab3ANFMD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 00:12:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46567 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab3ANFMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 00:12:01 -0500
Date: Sun, 13 Jan 2013 21:11:28 -0800
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-ab3cd8670e0b3fcde7f029e1503ed3c5138e9571@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        minipli@googlemail.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        minipli@googlemail.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <75F4BEE6-CB0E-4426-B40B-697451677738@googlemail.com>
References: <75F4BEE6-CB0E-4426-B40B-697451677738@googlemail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/Sandy Bridge:
  mark arrays in __init functions as __initconst
Git-Commit-ID: ab3cd8670e0b3fcde7f029e1503ed3c5138e9571
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sun, 13 Jan 2013 21:11:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ab3cd8670e0b3fcde7f029e1503ed3c5138e9571
Gitweb:     http://git.kernel.org/tip/ab3cd8670e0b3fcde7f029e1503ed3c5138e9571
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Sun, 13 Jan 2013 20:36:39 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sun, 13 Jan 2013 20:36:39 -0800

x86/Sandy Bridge: mark arrays in __init functions as __initconst

Mark static arrays as __initconst so they get removed when the init
sections are flushed.

Reported-by: Mathias Krause <minipli@googlemail.com>
Link: http://lkml.kernel.org/r/75F4BEE6-CB0E-4426-B40B-697451677738@googlemail.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/setup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 9dcb325..18182d1 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -614,7 +614,7 @@ static bool __init snb_gfx_workaround_needed(void)
 {
 	int i;
 	u16 vendor, devid;
-	static const u16 snb_ids[] = {
+	static const __initconst u16 snb_ids[] = {
 		0x0102,
 		0x0112,
 		0x0122,
@@ -646,7 +646,7 @@ static bool __init snb_gfx_workaround_needed(void)
  */
 static void __init trim_snb_memory(void)
 {
-	static const unsigned long bad_pages[] = {
+	static const __initconst unsigned long bad_pages[] = {
 		0x20050000,
 		0x20110000,
 		0x20130000,
