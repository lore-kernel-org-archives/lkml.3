Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab3CEP7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 10:59:20 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:49445 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab3CEP7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 10:59:18 -0500
MIME-Version: 1.0
In-Reply-To: <20130305152041.GA23742@S2101-09.ap.freescale.net>
References: <20130304025206.GB30431@S2101-09.ap.freescale.net>
	<20130305152041.GA23742@S2101-09.ap.freescale.net>
Date: Tue, 5 Mar 2013 07:59:17 -0800
X-Google-Sender-Auth: Ogy2LRo8jy8f0EXlv5vqzNIdpXw
Message-ID: <CACBanvptu-S_THoq8noh-BHUNYUROAa5UJgTohtnAMvfozsGhw@mail.gmail.com>
Subject: Re: v3.9-rc1: [BUG: swapper/1 still has locks held!]
From: Mandeep Singh Baines <msb@chromium.org>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 5, 2013 at 7:20 AM, Shawn Guo <shawn.guo@linaro.org> wrote:
> On Mon, Mar 04, 2013 at 10:52:10AM +0800, Shawn Guo wrote:
>> I'm running v3.9-rc1 kernel on an ARM platform (i.MX28) with
>> arch/arm/mxs_defconfig and getting the following BUG warning.
>>
> git bisect points me to the commit 6aa9707 (lockdep: check that no locks
> held at freeze time).
>

Hi,

Thanks for reporting this.

The discussion about this is happening here:

https://lkml.org/lkml/2013/3/4/221

Regards,
Mandeep

> Shawn
>
>> [    5.681034] =====================================
>> [    5.685885] [ BUG: swapper/1 still has locks held! ]
>> [    5.690885] 3.9.0-rc1 #774 Not tainted
>> [    5.694734] -------------------------------------
>> [    5.699475] 2 locks held by swapper/1:
>> [    5.703323]  #0:  (&sig->cred_guard_mutex){+.+.+.}, at: [<c00d20e0>] prepare_bprm_creds+0x28/0x64
>> [    5.712326]  #1:  (&type->i_mutex_dir_key){+.+.+.}, at: [<c00d5350>] lookup_slow+0x2c/0xa0
>> [    5.720966]
>> [    5.720966] stack backtrace:
>> [    5.725528] [<c0013c78>] (unwind_backtrace+0x0/0xf0) from [<c0426f94>] (rpc_wait_bit_killable+0x94/0xb4)
>> [    5.735184] [<c0426f94>] (rpc_wait_bit_killable+0x94/0xb4) from [<c044684c>] (__wait_on_bit+0x74/0xb8)
>> [    5.744645] [<c044684c>] (__wait_on_bit+0x74/0xb8) from [<c04468f4>] (out_of_line_wait_on_bit+0x64/0x70)
>> [    5.754278] [<c04468f4>] (out_of_line_wait_on_bit+0x64/0x70) from [<c0427e38>] (__rpc_execute+0xf4/0x370)
>> [    5.763991] [<c0427e38>] (__rpc_execute+0xf4/0x370) from [<c042124c>] (rpc_run_task+0xa4/0xb0)
>> [    5.772660] [<c042124c>] (rpc_run_task+0xa4/0xb0) from [<c0421350>] (rpc_call_sync+0x40/0xac)
>> [    5.781335] [<c0421350>] (rpc_call_sync+0x40/0xac) from [<c01c2e08>] (nfs3_rpc_wrapper.constprop.6+0x58/0xdc)
>> [    5.791406] [<c01c2e08>] (nfs3_rpc_wrapper.constprop.6+0x58/0xdc) from [<c01c2fbc>] (nfs3_proc_lookup+0x88/0xf4)
>> [    5.801751] [<c01c2fbc>] (nfs3_proc_lookup+0x88/0xf4) from [<c01b282c>] (nfs_lookup+0xe8/0x18c)
>> [    5.810659] [<c01b282c>] (nfs_lookup+0xe8/0x18c) from [<c00d49f8>] (lookup_real+0x20/0x50)
>> [    5.819097] [<c00d49f8>] (lookup_real+0x20/0x50) from [<c00d5314>] (__lookup_hash+0x34/0x44)
>> [    5.827696] [<c00d5314>] (__lookup_hash+0x34/0x44) from [<c00d5360>] (lookup_slow+0x3c/0xa0)
>> [    5.836297] [<c00d5360>] (lookup_slow+0x3c/0xa0) from [<c00d61bc>] (link_path_walk+0x2a4/0x848)
>> [    5.845144] [<c00d61bc>] (link_path_walk+0x2a4/0x848) from [<c00d9204>] (path_openat+0x278/0x444)
>> [    5.854176] [<c00d9204>] (path_openat+0x278/0x444) from [<c00d96cc>] (do_filp_open+0x2c/0x80)
>> [    5.862755] [<c00d96cc>] (do_filp_open+0x2c/0x80) from [<c00d12fc>] (open_exec+0x30/0x10c)
>> [    5.871166] [<c00d12fc>] (open_exec+0x30/0x10c) from [<c00d232c>] (do_execve+0x1b8/0x4c4)
>> [    5.879500] [<c00d232c>] (do_execve+0x1b8/0x4c4) from [<c0440b54>] (kernel_init+0x80/0xe4)
>> [    5.887963] [<c0440b54>] (kernel_init+0x80/0xe4) from [<c000e9c8>] (ret_from_fork+0x14/0x2c)
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
