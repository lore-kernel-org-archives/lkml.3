Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934690AbaLLU1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 15:27:21 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:48393 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbaLLU1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 15:27:19 -0500
Message-ID: <548B4FA4.40700@amacapital.net>
Date: Fri, 12 Dec 2014 12:27:16 -0800
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Dave Hansen <dave@sr71.net>, linux-kernel@vger.kernel.org
CC: tglx@linutronix.de, x86@kernel.org
Subject: Re: [RFC][PATCH 0/8] x86, mpx: Support 32-bit binaries on 64-bit
 kernels
References: <20141212191213.579887D2@viggo.jf.intel.com>
In-Reply-To: <20141212191213.579887D2@viggo.jf.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2014 11:12 AM, Dave Hansen wrote:
> This is 3.20 material.  I'm hoping to get some comments early
> in case folks have some issues with the way it's being done.
>

Would it make sense to disable MPX for 32-bit binaries on 64-bit kernels 
for 3.19?

--Andy

> --
>
> The MPX hardware structures differ in layout in 32 and 64-bit
> mode.  A 32-bit binary running on a 64-bit kernel needs the
> 32-bit structures, so we need code which switches between
> the two modes.
>
> The first patch is just a documentation update.  The next 5
> patches are really just prepwork.  The meat is in the last 3.
>
> 	x86: make is_64bit_mm() widely available
> 	x86: make __VIRTUAL_MASK safe to use on 32 bit
> 	x86, mpx: we do not allocate the bounds directory
> 	x86, mpx: remove redundant MPX_BNDCFG_ADDR_MASK
> 	x86, mpx: Add temporary variable to reduce masking
> 	x86, mpx: new directory entry to addr helper
> 	x86, mpx: do 32-bit-only cmpxchg for 32-bit apps
> 	x86, mpx: support 32bit binaries on 64bit kernel
>
>   Documentation/x86/intel_mpx.txt    |   12 +++-
>   arch/x86/include/asm/mmu_context.h |   13 +++++
>   arch/x86/include/asm/mpx.h         |    2
>   arch/x86/include/asm/page_types.h  |    8 +++
>   arch/x86/kernel/uprobes.c          |   10 ---
>   arch/x86/mm/mpx.c                  |   93 ++++++++++++++++++++++++++++++-------
>   6 files changed, 107 insertions(+), 31 deletions(-)
>

