Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736AbaCaOtl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 10:49:41 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:56684 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642AbaCaOti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 10:49:38 -0400
Date: Mon, 31 Mar 2014 16:49:34 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/iommu change for v3.15
Message-ID: <20140331144934.GA12335@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-iommu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-iommu-for-linus

   # HEAD: cbceb6904f9d99d068711903fc769b84cf036689 x86: Adjust irq remapping quirk for older revisions of 5500/5520 chipsets

We quirk a quirk.

 Thanks,

	Ingo

------------------>
Neil Horman (1):
      x86: Adjust irq remapping quirk for older revisions of 5500/5520 chipsets


 arch/x86/kernel/early-quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index bc4a088..2237b36 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -208,7 +208,7 @@ static void __init intel_remapping_check(int num, int slot, int func)
 	 * and should be flagged as broken.  Additionally revisions 0x12
 	 * and 0x22 of device id 0x3405 has this problem.
 	 */
-	if (revision == 0x13)
+	if (revision < 0x13)
 		set_irq_remapping_broken();
 	else if ((device == 0x3405) &&
 	    ((revision == 0x12) ||
