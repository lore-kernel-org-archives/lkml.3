Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbaA1QYo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 11:24:44 -0500
Received: from mail.skyhub.de ([78.46.96.112]:57873 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753572AbaA1QYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 11:24:42 -0500
Date: Tue, 28 Jan 2014 17:24:31 +0100
From: Borislav Petkov <bp@alien8.de>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: AMD microcode loading broken on 32 bit
Message-ID: <20140128162431.GH815@pd.tnic>
References: <52DE94A9.9060505@oracle.com>
 <20140121161438.GD9004@pd.tnic>
 <52DEB4A9.4070707@oracle.com>
 <20140121182554.GE9004@pd.tnic>
 <52E15AAE.4090106@oracle.com>
 <20140123192939.GB11190@pd.tnic>
 <52E17087.2060301@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52E17087.2060301@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 02:41:59PM -0500, Boris Ostrovsky wrote:
> 32-bit only.

Ok, I think I know what happens. Can you try this one (I missed doing
this on 32-bit and 64-bit does it, which would explain why it didn't
explode there):

---
diff --git a/arch/x86/kernel/cpu/microcode/amd_early.c b/arch/x86/kernel/cpu/microcode/amd_early.c
index 8384c0fa206f..03b759401bc1 100644
--- a/arch/x86/kernel/cpu/microcode/amd_early.c
+++ b/arch/x86/kernel/cpu/microcode/amd_early.c
@@ -359,7 +359,7 @@ int __init save_microcode_in_initrd_amd(void)
 		pr_info("microcode: updated early to new patch_level=0x%08x\n",
 			ucode_new_rev);
 
-	if (!container)
+	if (!container || !ucode_cpio.data)
 		return -EINVAL;
 
 	eax   = cpuid_eax(0x00000001);

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
