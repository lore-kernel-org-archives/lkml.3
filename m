Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759421Ab3HNKRq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:17:46 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:40199 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab3HNKRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:17:45 -0400
Date: Wed, 14 Aug 2013 12:17:41 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: x86-ml <x86@kernel.org>, Torsten Kaiser <just.for.lkml@googlemail.com>,
        Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] AMD microcode fixes for 3.11
Message-ID: <20130814101741.GE10849@gmail.com>
References: <20130812195816.GJ18018@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130812195816.GJ18018@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> Hi guys,
> 
> the tag message should explain it all so please pull.
> 
> Thanks.
> 
> The following changes since commit d4e4ab86bcba5a72779c43dc1459f71fea3d89c8:
> 
>   Linux 3.11-rc5 (2013-08-11 18:04:20 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/amd_ucode_fixes
> 
> for you to fetch changes up to 84516098b58e05821780dc0b89abcee434b4dca5:
> 
>   x86, microcode, AMD: Fix early microcode loading (2013-08-12 18:32:45 +0200)
> 
> ----------------------------------------------------------------
> Those are basically two fixes which correct the AMD early ucode loader
> from accessing cpu_data too early, i.e. before smp_store_cpu_info()
> has copied the boot_cpu_data ontop and overwritten an already empty
> structure (which we shouldn't access that early in the first place
> anyway).
> 
> The second patch is kinda largish for that late in the game but it
> shouldn't be problematic because we're simply switching from using
> cpu_data to use the CPU family number directly and thus again, not use
> uninitialized cpu_data structure.
> 
> ----------------------------------------------------------------
> Torsten Kaiser (2):
>       x86, microcode, AMD: Make cpu_has_amd_erratum() use the correct struct cpuinfo_x86
>       x86, microcode, AMD: Fix early microcode loading
> 
>  arch/x86/include/asm/microcode_amd.h  |  2 +-
>  arch/x86/kernel/cpu/amd.c             | 20 +++++---------------
>  arch/x86/kernel/microcode_amd.c       | 27 +++++++++++++--------------
>  arch/x86/kernel/microcode_amd_early.c | 27 +++++++++++++--------------
>  4 files changed, 32 insertions(+), 44 deletions(-)

Pulled into x86/urgent, thanks Boris!

	Ingo
