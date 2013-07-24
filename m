Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab3GXTc6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 15:32:58 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53738 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070Ab3GXTc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 15:32:57 -0400
Date: Wed, 24 Jul 2013 21:32:50 +0200
From: Borislav Petkov <bp@alien8.de>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] x86, AMD: simplify load_microcode_amd() to fix early
 microcode loading to no longer access uninitialized per-cpu data
Message-ID: <20130724193250.GO30777@pd.tnic>
References: <20130723230610.73bd048d@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130723230610.73bd048d@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 11:06:10PM +0200, Torsten Kaiser wrote:
> load_microcode_amd() (and the helper it is using) should not have an
> cpu parameter. The microcode loading is not depending on the CPU it is
> executed and all the loaded patches will end up in a global list for all
> CPUs anyway.
> The change from cpu to x86family in load_microcode_amd() now allows to drop
> the code messing with cpu_data(cpu) from collect_cpu_info_amd_early(), which 
> is wrong anyway because at that point the per-cpu cpu_info is not yet setup. 
> And these values would later be overwritten by smp_store_boot_cpu_info() / 
> smp_store_cpu_info().
> 
> Fold the rest of collect_cpu_info_amd_early() into load_ucode_amd_ap(), because its
> only used at one place and without the cpuinfo_x86 accesses it was not much left.
> 
> Signed-off-by: Torsten Kaiser <just.for.lkml@googlemail.com>

Btw, this patch is the one that fixes the boot issue on your box, correct?

If so, please put a minimal version of it in the next patch set you're
sending right after

[PATCH v2] x86, AMD: Make cpu_has_amd_erratum() use the correct struct cpuinfo_x86
[PATCH 1/5] x86, AMD: fix error path in apply_microcode_amd()

So that all fixes can go in now.

Basically, we need the fixes to be first in the patchset so that they
can be applied straight to tip:urgent.

The cleanups/improvements you're doing afterwards could wait then for
the next merge window.

Thanks a lot!

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
