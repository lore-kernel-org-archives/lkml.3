Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984AbaEZKTM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 06:19:12 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52111 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbaEZKTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 06:19:10 -0400
Date: Mon, 26 May 2014 12:18:59 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, "Luck, Tony" <tony.luck@intel.com>
Subject: [PATCH] x86, MCE: Flesh out when to panic comment
Message-ID: <20140526101859.GD25732@pd.tnic>
References: <20140521163315.GJ21205@pd.tnic>
 <alpine.LNX.2.00.1405212323190.12047@pobox.suse.cz>
 <CA+55aFwiZxg3kS7seKPnkteOBA5N8ENXt6Y+Azn_HH6Z1iRN5w@mail.gmail.com>
 <20140521214319.GF25130@pd.tnic>
 <537D1E8B.1010505@zytor.com>
 <CALCETrVP3WtaQ72RgaPUuF2tAZRmJUtEyzyGMKWytv422_thmw@mail.gmail.com>
 <20140521215411.GI25130@pd.tnic>
 <537D21F2.8030702@zytor.com>
 <20140521221121.GL25130@pd.tnic>
 <537D2522.80702@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <537D2522.80702@zytor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 03:13:54PM -0700, H. Peter Anvin wrote:
> Seems like a comment would be in order, though.

---
From: Borislav Petkov <bp@suse.de>
Subject: [PATCH] x86, MCE: Flesh out when to panic comment

Recent discussion (link below) showed that it is not really clear what
appropriate recovery actions we're taking when in a machine check
exception. Flesh out the comment which was explaining that with more
detail.

Suggested-by: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tony Luck <tony.luck@intel.com>
Link: http://lkml.kernel.org/r/CALCETrXudJ8BkNF_M-r4O40XLN%2BPnZ5TOZw0P7N4kqo3qngzyg@mail.gmail.com
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/cpu/mcheck/mce.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 68317c80de7f..9f070339b09f 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1151,10 +1151,14 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		no_way_out = worst >= MCE_PANIC_SEVERITY;
 
 	/*
-	 * At insane "tolerant" levels we take no action. Otherwise
-	 * we only die if we have no other choice. For less serious
-	 * issues we try to recover, or limit damage to the current
-	 * process.
+	 * At insane "tolerant" levels we take no action. Otherwise we only die
+	 * if we have no other choice. Which means, we're definitely going to
+	 * panic on unrecoverable, uncontainable errors which would otherwise
+	 * influence machine state and/or cause any type of corruption. The
+	 * decision what do to is done by mce_severity().
+	 *
+	 * For less serious issues we try to recover, or limit damage to the
+	 * current process.
 	 */
 	if (cfg->tolerant < 3) {
 		if (no_way_out)
-- 
1.9.0

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
