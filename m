Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbaD0TmR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 15:42:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:49383 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbaD0TmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 15:42:16 -0400
Date: Sun, 27 Apr 2014 21:42:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Richard Yao <ryao@gentoo.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Vineet Gupta <vgupta@synopsys.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org, kernel@gentoo.org,
        Brian Behlendorf <behlendorf1@llnl.gov>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] x86/dumpstack: Walk frames when built with frame pointers
Message-ID: <20140427194206.GD17778@laptop.programming.kicks-ass.net>
References: <1398535818-14217-1-git-send-email-ryao@gentoo.org>
 <20140427120820.GC22116@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140427120820.GC22116@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2014 at 02:08:20PM +0200, Ingo Molnar wrote:
> For example if we used more horizontal separation in the output 
> format:
> 
>  Call Trace:
>   [<79018d24>] arch_trigger_all_cpu_backtrace+0x3c/0x64
>   [<7916a34c>] do_raw_spin_lock+0xb7/0xe8
>   [<792b9412>] _raw_spin_lock_irqsave+0x35/0x3e
>   [<790391e8>]                                   # ? prepare_to_wait+0x18/0x57
>   [<790391e8>] prepare_to_wait+0x18/0x57
>   [<7914a320>]                                   # ? generic_make_request+0x80/0xb5
>   [<790e4f30>]                                   # ? unmap_underlying_metadata+0x2e/0x2e
>   [<792b7158>] __wait_on_bit+0x20/0x5f
>   [<7914a427>]                                   # ? submit_bio+0xd2/0xfb
>   [<792b71eb>] out_of_line_wait_on_bit+0x54/0x5c
>   [<790e4f30>]                                   # ? unmap_underlying_metadata+0x2e/0x2e
>   [<79039086>]                                   # ? autoremove_wake_function+0x31/0x31
>   [<790e4eff>] __wait_on_buffer+0x1b/0x1e
>   [<7910f615>] __ext3_get_inode_loc+0x1ef/0x254
>   [<7911015f>] ext3_iget+0x45/0x346
>   [<79114e03>] ext3_lookup+0x97/0xa6
>   [<790c9c0e>] lookup_real+0x20/0x35
>   [<790ca1d2>] __lookup_hash+0x2a/0x31
>   [<790caa0e>] lookup_slow+0x36/0x8c
>   [<790cbdda>] path_lookupat+0xf9/0x5c5
>   [<790cc2c5>] filename_lookup+0x1f/0x84
>   [<790cde98>] user_path_at_empty+0x3f/0x65
>   [<790cdecb>] user_path_at+0xd/0xf
>   [<790c6585>] vfs_fstatat+0x40/0x88
>   [<7903f844>]                                   # ? lg_local_unlock+0x31/0x47
>   [<790c65f8>] vfs_stat+0x13/0x15
>   [<790c67e2>] sys_stat64+0x11/0x22
>   [<790c3c47>]                                   # ? __fput+0x187/0x1a0
>   [<792b9d37>]                                   # ? restore_all+0xf/0xf
>   [<79165bb4>]                                   # ? trace_hardirqs_on_thunk+0xc/0x10
>   [<792b9d04>] syscall_call+0x7/0xb
> 
> then the information would still be there, it would still be in the 
> right place, but it would also be much easier to ignore the right side 
> column it visually. (The '# ?' prefix would also make it clear that 
> this information is not so important as the left hand side column.)

Might be my brain being weird, but I find the above actually harder to
parse.
