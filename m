Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760413AbbA1VbK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:31:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59886 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755523AbbA1Urn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:47:43 -0500
Date: Wed, 28 Jan 2015 21:47:28 +0100
From: Borislav Petkov <bp@suse.de>
To: x86-ml <x86@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] A microcode loader fix for 3.19
Message-ID: <20150128204728.GG7569@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

please pull this last small fix for the microcode loader not erroring
out of its init routine properly.

Optimally, it should go with the last batch of tip/urgent stuff for
3.19, if possible.

Thanks.

---
The following changes since commit 26bc420b59a38e4e6685a73345a0def461136dce:

  Linux 3.19-rc6 (2015-01-25 20:04:41 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/microcode_fix_for_3.19

for you to fetch changes up to da63865a01c6384d459464e5165d95d4f04878d8:

  x86, microcode: Return error from driver init code when loader is disabled (2015-01-28 09:23:40 +0100)

----------------------------------------------------------------
One final fix for 3.19 to address a wrongful deregistering of the
microcode loader module.

----------------------------------------------------------------
Boris Ostrovsky (1):
      x86, microcode: Return error from driver init code when loader is disabled

 arch/x86/kernel/cpu/microcode/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index 15c29096136b..36a83617eb21 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -552,7 +552,7 @@ static int __init microcode_init(void)
 	int error;
 
 	if (paravirt_enabled() || dis_ucode_ldr)
-		return 0;
+		return -EINVAL;
 
 	if (c->x86_vendor == X86_VENDOR_INTEL)
 		microcode_ops = init_intel_microcode();

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
