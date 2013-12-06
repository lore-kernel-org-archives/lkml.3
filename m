Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161716Ab3LFNId (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:08:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44814 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162194Ab3LFNGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:06:06 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Renninger <trenn@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 264/272] x86/microcode/amd: Tone down printk(), don't treat a missing firmware file as an error
Date: Fri,  6 Dec 2013 12:59:13 +0000
Message-Id: <1386334761-25517-265-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Renninger <trenn@suse.de>

commit 11f918d3e2d3861b6931e97b3aa778e4984935aa upstream.

Do it the same way as done in microcode_intel.c: use pr_debug()
for missing firmware files.

There seem to be CPUs out there for which no microcode update
has been submitted to kernel-firmware repo yet resulting in
scary sounding error messages in dmesg:

  microcode: failed to load file amd-ucode/microcode_amd_fam16h.bin

Signed-off-by: Thomas Renninger <trenn@suse.de>
Acked-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1384274383-43510-1-git-send-email-trenn@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/kernel/microcode_amd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 7123b5d..803a3e0 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -430,7 +430,7 @@ static enum ucode_state request_microcode_amd(int cpu, struct device *device,
 		snprintf(fw_name, sizeof(fw_name), "amd-ucode/microcode_amd_fam%.2xh.bin", c->x86);
 
 	if (request_firmware(&fw, (const char *)fw_name, device)) {
-		pr_err("failed to load file %s\n", fw_name);
+		pr_debug("failed to load file %s\n", fw_name);
 		goto out;
 	}
 
-- 
1.8.3.2

