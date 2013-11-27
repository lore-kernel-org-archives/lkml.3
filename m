Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760925Ab3K0CHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 21:07:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38779 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755267Ab3K0A4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:56:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Renninger <trenn@suse.de>, Borislav Petkov <bp@suse.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 3.4 28/39] x86/microcode/amd: Tone down printk(), dont treat a missing firmware file as an error
Date: Tue, 26 Nov 2013 16:56:52 -0800
Message-Id: <20131127005621.006457597@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005619.011763867@linuxfoundation.org>
References: <20131127005619.011763867@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/microcode_amd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -338,7 +338,7 @@ static enum ucode_state request_microcod
 		snprintf(fw_name, sizeof(fw_name), "amd-ucode/microcode_amd_fam%.2xh.bin", c->x86);
 
 	if (request_firmware(&fw, (const char *)fw_name, device)) {
-		pr_err("failed to load file %s\n", fw_name);
+		pr_debug("failed to load file %s\n", fw_name);
 		goto out;
 	}
 


