Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbaANWdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 17:33:20 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:40305 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbaANWdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 17:33:17 -0500
MIME-Version: 1.0
In-Reply-To: <20140114133125.GB26942@localhost>
References: <20140114133125.GB26942@localhost>
Date: Tue, 14 Jan 2014 14:33:15 -0800
X-Google-Sender-Auth: XQCziVjbWu-B7qaPLD60NFP7brE
Message-ID: <CAGXu5j+uBnEJ2qddoec0Y2z3=yzAYwKE_GjMRhXzc4XRw_Se_g@mail.gmail.com>
Subject: Re: [x86, kaslr] BUG: kernel boot hang
From: Kees Cook <keescook@chromium.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 5:31 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> Greetings,
>
> I got the below dmesg and the first bad commit is
>
> commit 82fa9637a2ba285bcc7c5050c73010b2c1b3d803
> Author:     Kees Cook <keescook@chromium.org>
> AuthorDate: Thu Oct 10 17:18:16 2013 -0700
> Commit:     H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Sun Oct 13 03:12:19 2013 -0700
>
>     x86, kaslr: Select random position from e820 maps
>
>     Counts available alignment positions across all e820 maps, and chooses
>     one randomly for the new kernel base address, making sure not to collide
>     with unsafe memory areas.
>
>     Signed-off-by: Kees Cook <keescook@chromium.org>
>     Link: http://lkml.kernel.org/r/1381450698-28710-5-git-send-email-keescook@chromium.org
>     Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
>
> Note that there are many other warning/errors and it's not very
> reproducible, so this report might be wrong.
>
> ===================================================
> PARENT COMMIT NOT CLEAN. LOOK OUT FOR WRONG BISECT!
> ===================================================
>
> +-----------------------------------------------------------+--------------+--------------+
> |                                                           | 5bfce5ef55cb | 1955a14a5ba6 |
> +-----------------------------------------------------------+--------------+--------------+
> | boot_successes                                            | 3948         | 0            |
> | boot_failures                                             | 52           | 89           |
> | page_allocation_failure:order:,mode                       | 48           | 2            |
> | Out_of_memory:Kill_process                                | 7            |              |
> | BUG:kernel_early_hang_without_any_printk_output           | 1            |              |
> | BUG:soft_lockup-CPU_stuck_for_s                           | 1            |              |
> | WARNING:CPU:PID:at_kernel/locking/lockdep.c:check_flags() | 0            | 85           |
> | general_protection_fault:SMP_SMP                          | 0            | 1            |
> | RIP:__lock_acquire                                        | 0            | 1            |
> | Kernel_panic-not_syncing:Fatal_exception                  | 0            | 1            |
> | BUG:kernel_boot_hang                                      | 0            | 2            |
> | BUG:kernel_boot_crashed                                   | 0            | 1            |
> +-----------------------------------------------------------+--------------+--------------+
>
> The last dmesg is
>
> [    0.803796] Initramfs unpacking failed: junk in compressed archive

Can you tell me how the initrd for quantal-core-x86_64.cgz was built
in the qemu instances you're using? It seems like all the failures
point to a problem with how kASLR is interacting with the initrd.

Thanks,

-Kees

-- 
Kees Cook
Chrome OS Security
