Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbbAJVCl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 16:02:41 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:42379 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992AbbAJVCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 16:02:40 -0500
MIME-Version: 1.0
In-Reply-To: <20150110204231.GD12218@pd.tnic>
References: <1420734315-30943-1-git-send-email-dvlasenk@redhat.com>
 <1420734315-30943-4-git-send-email-dvlasenk@redhat.com> <20150109121950.GD13637@pd.tnic>
 <CAK1hOcMsGJ7geRAzfazPLZitcO0o9XYRPJDYa8sJHR4i6DPL-g@mail.gmail.com>
 <20150110142336.GC12218@pd.tnic> <CAK1hOcO7K=4N8CF=LOPmosXRNnogaNi5vLDPMdb0XiKsL=JOfg@mail.gmail.com>
 <CALCETrXS7BvtS3P3J8hnbt3GGvezx-935uxanSN_a=CU6s1d3g@mail.gmail.com> <20150110204231.GD12218@pd.tnic>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 10 Jan 2015 13:02:18 -0800
Message-ID: <CALCETrWwnfU9roXp_0Z_hHo-c2LMcc3_KRKJgx_=p2U-+i5PrA@mail.gmail.com>
Subject: Re: [PATCH 3/4] x86: open-code register save/restore in
 trace_hardirqs thunks
To: Borislav Petkov <bp@alien8.de>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 12:42 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Sat, Jan 10, 2015 at 12:17:13PM -0800, Andy Lutomirski wrote:
>> I asked this once, and someone told me that push/pop has lower
>> throughput.  I find this surprising.
>
> Implicit dependency on %rsp probably. The MOVs allow you to start more
> stuff out-of-order I'd guess...

AIUI modern CPUs have fancy stack engines that match call/ret pairs,
and presumably they can speculate rsp values across multiple pushes
and pops very quickly.

Also, don't compilers generally use push and pop to save and restore
callee-saved registers?  I think that function calls are common enough
that the CPU vendors would have made these sequences fast.

--Andy

>
>> Tt could be worth adding a macro along the lines of pushq_cfi_save
>> that does the pushq_cfi and the CFI_REL_OFFSET.
>
> Yep, for balance.
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --



-- 
Andy Lutomirski
AMA Capital Management, LLC
