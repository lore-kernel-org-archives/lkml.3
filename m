Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522Ab3KLV6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 16:58:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40308 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756580Ab3KLV6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 16:58:14 -0500
Date: Tue, 12 Nov 2013 13:58:00 -0800
From: tip-bot for Thomas Renninger <tipbot@zytor.com>
Message-ID: <tip-11f918d3e2d3861b6931e97b3aa778e4984935aa@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        stable@kernel.org, trenn@suse.de, tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tglx@linutronix.de, trenn@suse.de, bp@suse.de
In-Reply-To: <1384274383-43510-1-git-send-email-trenn@suse.de>
References: <1384274383-43510-1-git-send-email-trenn@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/microcode/amd: Tone down printk(), don'
 t treat a missing firmware file as an error
Git-Commit-ID: 11f918d3e2d3861b6931e97b3aa778e4984935aa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 12 Nov 2013 13:58:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  11f918d3e2d3861b6931e97b3aa778e4984935aa
Gitweb:     http://git.kernel.org/tip/11f918d3e2d3861b6931e97b3aa778e4984935aa
Author:     Thomas Renninger <trenn@suse.de>
AuthorDate: Tue, 12 Nov 2013 17:39:43 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 12 Nov 2013 22:03:49 +0100

x86/microcode/amd: Tone down printk(), don't treat a missing firmware file as an error

Do it the same way as done in microcode_intel.c: use pr_debug()
for missing firmware files.

There seem to be CPUs out there for which no microcode update
has been submitted to kernel-firmware repo yet resulting in
scary sounding error messages in dmesg:

  microcode: failed to load file amd-ucode/microcode_amd_fam16h.bin

Signed-off-by: Thomas Renninger <trenn@suse.de>
Acked-by: Borislav Petkov <bp@suse.de>
Cc: <stable@kernel.org>
Link: http://lkml.kernel.org/r/1384274383-43510-1-git-send-email-trenn@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/microcode_amd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index af99f71..c3d4cc9 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -431,7 +431,7 @@ static enum ucode_state request_microcode_amd(int cpu, struct device *device,
 		snprintf(fw_name, sizeof(fw_name), "amd-ucode/microcode_amd_fam%.2xh.bin", c->x86);
 
 	if (request_firmware(&fw, (const char *)fw_name, device)) {
-		pr_err("failed to load file %s\n", fw_name);
+		pr_debug("failed to load file %s\n", fw_name);
 		goto out;
 	}
 
