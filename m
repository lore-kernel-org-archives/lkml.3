Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbaANNDK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 08:03:10 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:38745 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaANNDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 08:03:08 -0500
Date: Tue, 14 Jan 2014 14:03:04 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@suse.de>
Cc: x86-ml <x86@kernel.org>, Thomas Renninger <trenn@suse.de>,
        Kim Naru <kim.naru@amd.com>,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        lkml <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>
Subject: Re: [GIT PULL] AMD microcode loader fixes for 3.14
Message-ID: <20140114130304.GA23121@gmail.com>
References: <20140114115006.GC29865@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140114115006.GC29865@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@suse.de> wrote:

> Hi guys,
> 
> please pull these microcode loader fixes which addresses early microcode
> loading on AMD. The patches have been ready for a while now and I've
> been running them here for weeks but was waiting for AMD to test them
> too before I send out.
> 
> Also, I think it is finally time for the microcode loader to have its
> own source tree directory, so the last patch does that. :-)
> 
> Please pull,
> thanks.
> 
> ---
> The following changes since commit 7e22e91102c6b9df7c4ae2168910e19d2bb14cd6:
> 
>   Linux 3.13-rc8 (2014-01-12 17:04:18 +0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/amd_ucode_for_3.14
> 
> for you to fetch changes up to bad5fa631fca5466401cd4a48e30cc1f1cb6101e:
> 
>   x86, microcode: Move to a proper location (2014-01-13 20:00:12 +0100)
> 
> ----------------------------------------------------------------
> - AMD microcode early loading fixes
> - some microcode loader source files reorganization
> 
> ----------------------------------------------------------------
> Borislav Petkov (4):
>       x86, ramdisk: Export relocated ramdisk VA
>       x86, microcode: Share native MSR accessing variants
>       x86, microcode, AMD: Fix early ucode loading
>       x86, microcode: Move to a proper location
> 
>  arch/x86/Kconfig                                   |   4 -
>  arch/x86/include/asm/microcode.h                   |  15 ++
>  arch/x86/include/asm/microcode_amd.h               |   7 +-
>  arch/x86/include/asm/setup.h                       |   3 +-
>  arch/x86/kernel/Makefile                           |   9 -
>  arch/x86/kernel/cpu/Makefile                       |   1 +
>  arch/x86/kernel/cpu/microcode/Makefile             |   7 +
>  .../{microcode_amd.c => cpu/microcode/amd.c}       |  13 +-
>  .../microcode/amd_early.c}                         | 239 ++++++++++++++-------
>  .../{microcode_core.c => cpu/microcode/core.c}     |   0
>  .../microcode/core_early.c}                        |   0
>  .../{microcode_intel.c => cpu/microcode/intel.c}   |   0
>  .../microcode/intel_early.c}                       |  10 -
>  .../microcode/intel_lib.c}                         |   0
>  arch/x86/kernel/setup.c                            |  19 +-
>  15 files changed, 205 insertions(+), 122 deletions(-)
>  create mode 100644 arch/x86/kernel/cpu/microcode/Makefile
>  rename arch/x86/kernel/{microcode_amd.c => cpu/microcode/amd.c} (96%)
>  rename arch/x86/kernel/{microcode_amd_early.c => cpu/microcode/amd_early.c} (55%)
>  rename arch/x86/kernel/{microcode_core.c => cpu/microcode/core.c} (100%)
>  rename arch/x86/kernel/{microcode_core_early.c => cpu/microcode/core_early.c} (100%)
>  rename arch/x86/kernel/{microcode_intel.c => cpu/microcode/intel.c} (100%)
>  rename arch/x86/kernel/{microcode_intel_early.c => cpu/microcode/intel_early.c} (98%)
>  rename arch/x86/kernel/{microcode_intel_lib.c => cpu/microcode/intel_lib.c} (100%)

Pulled into tip:x86/microcode, thanks Boris!

	Ingo
