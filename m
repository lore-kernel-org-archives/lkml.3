Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbbAPIH7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 03:07:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59544 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbbAPIHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 03:07:55 -0500
Date: Fri, 16 Jan 2015 00:07:41 -0800
From: tip-bot for Alexander Kuleshov <tipbot@zytor.com>
Message-ID: <tip-b34630014dad0ba69aadd8deb231ddc6d2efcf53@git.kernel.org>
Cc: bp@suse.de, hpa@zytor.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, mingo@kernel.org, kuleshovmail@gmail.com
Reply-To: linux-kernel@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de,
        bp@suse.de, hpa@zytor.com, kuleshovmail@gmail.com
In-Reply-To: <1420009958-4803-1-git-send-email-kuleshovmail@gmail.com>
References: <1420009958-4803-1-git-send-email-kuleshovmail@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86, early_serial_console:
  Remove unnecessary check
Git-Commit-ID: b34630014dad0ba69aadd8deb231ddc6d2efcf53
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

Commit-ID:  b34630014dad0ba69aadd8deb231ddc6d2efcf53
Gitweb:     http://git.kernel.org/tip/b34630014dad0ba69aadd8deb231ddc6d2efcf53
Author:     Alexander Kuleshov <kuleshovmail@gmail.com>
AuthorDate: Wed, 31 Dec 2014 13:12:38 +0600
Committer:  Borislav Petkov <bp@suse.de>
CommitDate: Tue, 13 Jan 2015 12:14:44 +0100

x86, early_serial_console: Remove unnecessary check

We do this check already a couple of lines up.

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
Link: http://lkml.kernel.org/r/1420009958-4803-1-git-send-email-kuleshovmail@gmail.com
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/boot/early_serial_console.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/boot/early_serial_console.c b/arch/x86/boot/early_serial_console.c
index 790586d..45a0768 100644
--- a/arch/x86/boot/early_serial_console.c
+++ b/arch/x86/boot/early_serial_console.c
@@ -72,8 +72,8 @@ static void parse_earlyprintk(void)
 			static const int bases[] = { 0x3f8, 0x2f8 };
 			int idx = 0;
 
-			if (!strncmp(arg + pos, "ttyS", 4))
-				pos += 4;
+			/* += strlen("ttyS"); */
+			pos += 4;
 
 			if (arg[pos++] == '1')
 				idx = 1;
