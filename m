Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964850Ab3DSUz0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 16:55:26 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56565 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932301Ab3DSUzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 16:55:25 -0400
Date: Fri, 19 Apr 2013 22:55:15 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Bryan O'Donoghue" <bryan.odonoghue.lkml@nexus-software.ie>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, x86@kernel.org,
        fenghua.yu@intel.com
Subject: Re: [PATCH] x86: Add check for P5 to microcode_intel_early
Message-ID: <20130419205515.GA3075@pd.tnic>
References: <1366392183-4149-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie>
 <20130419191128.GA21991@pd.tnic>
 <5171AA86.604@nexus-software.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5171AA86.604@nexus-software.ie>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 19, 2013 at 09:35:18PM +0100, Bryan O'Donoghue wrote:
> Just returning X86_VENDOR_UNKNOWN - won't fix the bug though - after
> all MSR_IA32_UCODE_REV is also x86_family() >= 6

What are you talking about?

If you return X86_VENDOR_UNKNOWN from x86_vendor(),
load_ucode_intel_bsp() and load_ucode_intel_ap() won't be called and no
non-existing MSRs will be accessed.

Just filter out P5 and earlier. The code already does that for CPUs
which don't have CPUID.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
