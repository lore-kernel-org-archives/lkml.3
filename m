Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab3JNJej (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 05:34:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51370 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571Ab3JNJeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 05:34:36 -0400
Date: Mon, 14 Oct 2013 02:34:17 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-80030e3d8ec6414790a5ec67ae4c5eeee82aba98@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@suse.de
In-Reply-To: <1381682189-14470-1-git-send-email-bp@alien8.de>
References: <1381682189-14470-1-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/microcode: Correct Kconfig dependencies
Git-Commit-ID: 80030e3d8ec6414790a5ec67ae4c5eeee82aba98
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 02:34:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  80030e3d8ec6414790a5ec67ae4c5eeee82aba98
Gitweb:     http://git.kernel.org/tip/80030e3d8ec6414790a5ec67ae4c5eeee82aba98
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Sun, 13 Oct 2013 18:36:29 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 14 Oct 2013 09:24:27 +0200

x86/microcode: Correct Kconfig dependencies

I have a randconfig here which has enabled only

  CONFIG_MICROCODE=y
  CONFIG_MICROCODE_OLD_INTERFACE=y

with both

  # CONFIG_MICROCODE_INTEL is not set
  # CONFIG_MICROCODE_AMD is not set

off. Which makes building the microcode functionality a little
pointless. Don't do that in such cases then.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1381682189-14470-1-git-send-email-bp@alien8.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 145d703..f67e839 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1033,6 +1033,7 @@ config X86_REBOOTFIXUPS
 
 config MICROCODE
 	tristate "CPU microcode loading support"
+	depends on CPU_SUP_AMD || CPU_SUP_INTEL
 	select FW_LOADER
 	---help---
 
