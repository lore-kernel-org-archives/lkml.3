Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbaEIKdJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 06:33:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42074 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754078AbaEIKdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 06:33:07 -0400
Date: Fri, 9 May 2014 12:33:03 +0200
From: Borislav Petkov <bp@suse.de>
To: Andres Freund <andres@anarazel.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH 2/2] x86: Fix typo in MSR_IA32_MISC_ENABLE_LIMIT_CPUID
 macro
Message-ID: <20140509103303.GC16058@pd.tnic>
References: <1399598957-7011-1-git-send-email-andres@anarazel.de>
 <1399598957-7011-3-git-send-email-andres@anarazel.de>
 <20140509075730.GB16058@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140509075730.GB16058@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 09:57:30AM +0200, Borislav Petkov wrote:
> > diff --git a/arch/x86/include/uapi/asm/msr-index.h b/arch/x86/include/uapi/asm/msr-index.h
> > index c827ace..fcf2b3a 100644
> > --- a/arch/x86/include/uapi/asm/msr-index.h
> > +++ b/arch/x86/include/uapi/asm/msr-index.h
> > @@ -384,7 +384,7 @@
> >  #define MSR_IA32_MISC_ENABLE_MWAIT_BIT			18
> >  #define MSR_IA32_MISC_ENABLE_MWAIT			(1ULL << MSR_IA32_MISC_ENABLE_MWAIT_BIT)
> >  #define MSR_IA32_MISC_ENABLE_LIMIT_CPUID_BIT		22
> > -#define MSR_IA32_MISC_ENABLE_LIMIT_CPUID		(1ULL << MSR_IA32_MISC_ENABLE_LIMIT_CPUID_BIT);
> > +#define MSR_IA32_MISC_ENABLE_LIMIT_CPUID		(1ULL << MSR_IA32_MISC_ENABLE_LIMIT_CPUID_BIT)

Btw, we should probably be catching typos like that with checkpatch.
Here's an initial version for single-line macros:

---
From: Borislav Petkov <bp@suse.de>
Subject: [PATCH] checkpatch: Catch trailing semicolons in macro definitions

This currently checks only single-line macro definitions. I.e.,

$ git show c0a639ad0bc6b178b46996bd1f821a04643e2bde | ./scripts/checkpatch.pl -

...
WARNING: Trailing semicolon at macro definition
+#define MSR_IA32_MISC_ENABLE_LIMIT_CPUID       (1ULL << MSR_BIT_LIMIT_CPUID);

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 scripts/checkpatch.pl | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 34eb2160489d..04929c20c9b5 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3313,6 +3313,11 @@ sub process {
 			}
 		}
 
+		if ($line =~ /^\+\s*#\s*define\s.*;\s*$/) {
+			WARN("TRAILING_SEMICOLON",
+			     "Trailing semicolon at macro definition\n" . $herecurr);
+		}
+
 # check for multiple assignments
 		if ($line =~ /^.\s*$Lval\s*=\s*$Lval\s*=(?!=)/) {
 			CHK("MULTIPLE_ASSIGNMENTS",
-- 
1.9.0

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
