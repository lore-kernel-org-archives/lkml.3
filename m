Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758622Ab3FAJm0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 05:42:26 -0400
Received: from www17.your-server.de ([213.133.104.17]:58987 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758271Ab3FAJmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 05:42:20 -0400
Message-ID: <1370079731.29224.12.camel@localhost.localdomain>
Subject: [PATCH] x86, microcode, AMD: Cocci spatch "memdup.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: herrmann.der.user@googlemail.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, amd64-microcode@amd64.org,
        linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 11:42:11 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -345,7 +345,7 @@ static int verify_and_add_patch(unsigned
 		return -EINVAL;
 	}
 
-	patch->data = kzalloc(patch_size, GFP_KERNEL);
+	patch->data = kmemdup(fw + SECTION_HDR_SIZE, patch_size, GFP_KERNEL);
 	if (!patch->data) {
 		pr_err("Patch data allocation failure.\n");
 		kfree(patch);
@@ -353,7 +353,6 @@ static int verify_and_add_patch(unsigned
 	}
 
 	/* All looks ok, copy patch... */
-	memcpy(patch->data, fw + SECTION_HDR_SIZE, patch_size);
 	INIT_LIST_HEAD(&patch->plist);
 	patch->patch_id  = mc_hdr->patch_id;
 	patch->equiv_cpu = proc_id;


