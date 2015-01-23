Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbbAWJjz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 04:39:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35509 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbbAWJjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 04:39:51 -0500
Date: Fri, 23 Jan 2015 01:39:36 -0800
From: tip-bot for Colin King <tipbot@zytor.com>
Message-ID: <tip-d505ad1d66c9cd31db5ab0d2c7bcb2a47e5bb29e@git.kernel.org>
Cc: tglx@linutronix.de, colin.king@canonical.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Reply-To: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        colin.king@canonical.com, tglx@linutronix.de
In-Reply-To: <1421244475-313-1-git-send-email-colin.king@canonical.com>
References: <1421244475-313-1-git-send-email-colin.king@canonical.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86/rtc: Remove duplicate const specifier
Git-Commit-ID: d505ad1d66c9cd31db5ab0d2c7bcb2a47e5bb29e
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

Commit-ID:  d505ad1d66c9cd31db5ab0d2c7bcb2a47e5bb29e
Gitweb:     http://git.kernel.org/tip/d505ad1d66c9cd31db5ab0d2c7bcb2a47e5bb29e
Author:     Colin King <colin.king@canonical.com>
AuthorDate: Wed, 14 Jan 2015 14:07:55 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 23 Jan 2015 10:35:51 +0100

x86/rtc: Remove duplicate const specifier

Building with clang:

  CC      arch/x86/kernel/rtc.o
arch/x86/kernel/rtc.c:173:29: warning: duplicate 'const' declaration
  specifier [-Wduplicate-decl-specifier]
        static const char * const  const ids[] __initconst =

Remove the duplicate const, it is not needed and causes a warning.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Link: http://lkml.kernel.org/r/1421244475-313-1-git-send-email-colin.king@canonical.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/rtc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
index ca9622a..fe3dbfe 100644
--- a/arch/x86/kernel/rtc.c
+++ b/arch/x86/kernel/rtc.c
@@ -170,7 +170,7 @@ static struct platform_device rtc_device = {
 static __init int add_rtc_cmos(void)
 {
 #ifdef CONFIG_PNP
-	static const char * const  const ids[] __initconst =
+	static const char * const ids[] __initconst =
 	    { "PNP0b00", "PNP0b01", "PNP0b02", };
 	struct pnp_dev *dev;
 	struct pnp_id *id;
