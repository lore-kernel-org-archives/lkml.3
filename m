Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973Ab3L2COc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:14:32 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55858 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752030Ab3L2CO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:14:29 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Ingo Molnar" <mingo@kernel.org>,
        "Thomas Renninger" <trenn@suse.de>, "Borislav Petkov" <bp@suse.de>
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.401281102@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 054/185] x86/microcode/amd: Tone down printk(), don't
 treat a missing firmware file as an error
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/microcode_amd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -331,7 +331,7 @@ static enum ucode_state request_microcod
 		snprintf(fw_name, sizeof(fw_name), "amd-ucode/microcode_amd_fam%.2xh.bin", c->x86);
 
 	if (request_firmware(&fw, (const char *)fw_name, device)) {
-		pr_err("failed to load file %s\n", fw_name);
+		pr_debug("failed to load file %s\n", fw_name);
 		goto out;
 	}
 

