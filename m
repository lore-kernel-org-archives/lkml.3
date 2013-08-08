Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966114Ab3HHS25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 14:28:57 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35576 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966076Ab3HHS2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 14:28:55 -0400
Date: Thu, 8 Aug 2013 20:28:53 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>,
        Torsten Kaiser <just.for.lkml@googlemail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Jacob Shin <jacob.shin@amd.com>,
        Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] x86, AMD: cleanup: merge common code in early
 microcode loading
Message-ID: <20130808182853.GD27974@pd.tnic>
References: <20130723230026.394a5ee1@googlemail.com>
 <20130724133254.GE30777@pd.tnic>
 <3E5A0FA7E9CA944F9D5414FEC6C712205A53B73A@ORSMSX106.amr.corp.intel.com>
 <78b1bca9-80bb-4e60-af3a-738424babfd0@email.android.com>
 <20130808100238.GA27974@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130808100238.GA27974@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 08, 2013 at 12:02:38PM +0200, Borislav Petkov wrote:
> On Wed, Aug 07, 2013 at 07:22:39PM -0700, H. Peter Anvin wrote:
> > How much does this matter?
> 
> I know what you're asking :-)
> 
> And no, it doesn't really matter as we fail in the patch version check
> so maybe only a comment will suffice here so that people don't get
> confused.

IOW, something like that:

---
From: Borislav Petkov <bp@suse.de>
Date: Thu, 8 Aug 2013 20:26:24 +0200
Subject: [PATCH] x86, microcode: Clarify loading on the AP

Hold it down why we're calling the AP microcode loading routine on the
BSP too, for future reference.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/cpu/common.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 25eb2747b063..58d37a27d317 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1226,8 +1226,12 @@ void cpu_init(void)
 	int i;
 
 	/*
-	 * Load microcode on this cpu if a valid microcode is available.
-	 * This is early microcode loading procedure.
+	 * Load microcode on this cpu if a valid microcode is available. This
+	 * is early microcode loading procedure. We execute this on the BSP too
+	 * but since a microcode has been potentially already applied on the
+	 * BSP, we will return prematurely here. It is easier to simply call it
+	 * again than filtering all the possible cases when we're not running
+	 * on the BSP.
 	 */
 	load_ucode_ap();
 
-- 
1.8.3

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
