Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab3A0Qiu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 11:38:50 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:45031 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157Ab3A0Qia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 11:38:30 -0500
From: Emil Goode <emilgoode@gmail.com>
To: mtosatti@redhat.com, gleb@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, avi@redhat.com, mst@redhat.com, perex@perex.cz,
        tiwai@suse.de, crimsun@ubuntu.com, wfp5p@virginia.edu,
        peter.senna@gmail.com
Cc: x86@kernel.org, kvm@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Emil Goode <emilgoode@gmail.com>
Subject: [PATCH 3/3] ALSA: intel8x0: Check return value before assigning
Date: Sun, 27 Jan 2013 17:40:02 +0100
Message-Id: <1359304802-28240-3-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359304802-28240-1-git-send-email-emilgoode@gmail.com>
References: <1359304802-28240-1-git-send-email-emilgoode@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first patch in this series changes the return type of function
kvm_para_available to bool. In the function snd_intel8x0_inside_vm
we now need to check it's return value before assigning a value to
the result variable.

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 sound/pci/intel8x0.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/intel8x0.c b/sound/pci/intel8x0.c
index 3b9be75..fa9337e 100644
--- a/sound/pci/intel8x0.c
+++ b/sound/pci/intel8x0.c
@@ -2982,7 +2982,7 @@ static int snd_intel8x0_inside_vm(struct pci_dev *pci)
 	}
 
 	/* detect KVM and Parallels virtual environments */
-	result = kvm_para_available();
+	result = kvm_para_available() ? 1 : 0;
 #ifdef X86_FEATURE_HYPERVISOR
 	result = result || boot_cpu_has(X86_FEATURE_HYPERVISOR);
 #endif
-- 
1.7.10.4

