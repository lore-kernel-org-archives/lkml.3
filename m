Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751215Ab3KRIgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 03:36:18 -0500
Received: from mail1.windriver.com ([147.11.146.13]:40108 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab3KRIgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 03:36:14 -0500
Message-ID: <5289D172.4020007@windriver.com>
Date: Mon, 18 Nov 2013 16:36:02 +0800
From: =?UTF-8?B?IuKAnHRpZWp1bi5jaGVu4oCdIg==?= 
	<tiejun.chen@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: <scottwood@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [v6][PATCH 0/5] powerpc/book3e: powerpc/book3e: make kgdb to
 work well
References: <1382520685-11609-1-git-send-email-tiejun.chen@windriver.com>
In-Reply-To: <1382520685-11609-1-git-send-email-tiejun.chen@windriver.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.162.245]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2013 05:31 PM, Tiejun Chen wrote:
> Scott,
>
> Tested on fsl-p5040 DS.

Scott,

Any comments to this version?

Tiejun

>
> v6:
>
> * rebase
> * change the C code to initialize the exception stack addresses in the PACA instead.
> * Clear the PACA_IRQ_HARD_DIS force to exit directly from this debug exception
>    without replaying interrupt.
> * so drop "book3e/kgdb: update thread's dbcr0".
>
> v5:
>
> * rebase on merge branch.
>
> Note the original patch, [ATCH 5/7] kgdb/kgdbts: support ppc64, is already merged
> by Jason.
>
> v4:
>
> * use DEFINE_PER_CPU to allocate kgdb's thread_info
> * add patch 7 to make usre copy thread_info only !__check_irq_replay
> * leave "andi.   r14,r11,MSR_PR" out of "#ifndef CONFIG_KGDB"
>    since cr0 is still used lately.
> * retest
>
> v3:
>
> * make work when enable CONFIG_RELOCATABLE
> * fix one typo in patch,
>    "powerpc/book3e: store critical/machine/debug exception thread info":
> 	ld	r1,PACAKSAVE(r13);
>      ->  ld	r14,PACAKSAVE(r13);
> * remove copying the thread_info since booke and book3e always copy
>    the thead_info now when we enter the debug exception, and so drop
>    the v2 patch, "book3e/kgdb: Fix a single stgep case of lazy IRQ"
>
> v2:
>
> * Make sure we cover CONFIG_PPC_BOOK3E_64 safely
> * Use LOAD_REG_IMMEDIATE() to load properly
> 	the value of the constant expression in load debug exception stack
> * Copy thread infor form the kernel stack coming from usr
> * Rebase latest powerpc git tree
>
> v1:
>
> * Copy thread info only when we are from !user mode since we'll get kernel stack
>    coming from usr directly.
> * remove save/restore EX_R14/EX_R15 since DBG_EXCEPTION_PROLOG already covered
>    this.
> * use CURRENT_THREAD_INFO() conveniently to get thread.
> * fix some typos
> * add a patch to make sure gdb can generate a single step properly to invoke a
>    kgdb state.
> * add a patch to if we need to replay an interrupt, we shouldn't restore that
>    previous backup thread info to make sure we can replay an interrupt lately
>    with a proper thread info.
> * rebase latest powerpc git tree
>
> v0:
>
> This patchset is used to support kgdb for book3e.
>
> ----------------------------------------------------------------
> Tiejun Chen (5):
>        powerpc/book3e: initialize crit/mc/dbg kernel stack pointers
>        powerpc/book3e: store crit/mc/dbg exception thread info
>        powerpc/book3e: support kgdb for kernel space
>        powerpc/kgdb: use DEFINE_PER_CPU to allocate kgdb's thread_info
>        powerpc/book3e/kgdb: Fix a single stgep case of lazy IRQ
>
>   arch/powerpc/kernel/exceptions-64e.S |   26 ++++++++++++++++++++++----
>   arch/powerpc/kernel/kgdb.c           |   13 ++++++++++---
>   arch/powerpc/kernel/setup_64.c       |   18 ++++++++++++------
>   3 files changed, 44 insertions(+), 13 deletions(-)
>
> Tiejun
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
>
>

