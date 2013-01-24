Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082Ab3AXULP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:11:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34341 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756192Ab3AXUKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:10:52 -0500
Date: Thu, 24 Jan 2013 12:09:47 -0800
From: tip-bot for Cong Ding <dinggnu@gmail.com>
Message-ID: <tip-585376216a829d1ddfb3e57cb50c72c23adb484f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        slash@ac.auone-net.jp, jkosina@suse.cz, jarkko.sakkinen@intel.com,
        matt.fleming@intel.com, dinggnu@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        slash@ac.auone-net.jp, jarkko.sakkinen@intel.com, jkosina@suse.cz,
        matt.fleming@intel.com, dinggnu@gmail.com, tglx@linutronix.de
In-Reply-To: <1358183628-27784-1-git-send-email-dinggnu@gmail.com>
References: <1358183628-27784-1-git-send-email-dinggnu@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/boot] x86/boot: Fix minor fd leakage in tools/relocs.c
Git-Commit-ID: 585376216a829d1ddfb3e57cb50c72c23adb484f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 12:09:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  585376216a829d1ddfb3e57cb50c72c23adb484f
Gitweb:     http://git.kernel.org/tip/585376216a829d1ddfb3e57cb50c72c23adb484f
Author:     Cong Ding <dinggnu@gmail.com>
AuthorDate: Mon, 14 Jan 2013 17:13:35 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 24 Jan 2013 13:07:23 +0100

x86/boot: Fix minor fd leakage in tools/relocs.c

The opened file should be closed.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
Cc: Kusanagi Kouichi <slash@ac.auone-net.jp>
Cc: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Matt Fleming <matt.fleming@intel.com>
Link: http://lkml.kernel.org/r/1358183628-27784-1-git-send-email-dinggnu@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/tools/relocs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
index 5a1847d..79d67bd 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -814,12 +814,14 @@ int main(int argc, char **argv)
 	read_relocs(fp);
 	if (show_absolute_syms) {
 		print_absolute_symbols();
-		return 0;
+		goto out;
 	}
 	if (show_absolute_relocs) {
 		print_absolute_relocs();
-		return 0;
+		goto out;
 	}
 	emit_relocs(as_text, use_real_mode);
+out:
+	fclose(fp);
 	return 0;
 }
