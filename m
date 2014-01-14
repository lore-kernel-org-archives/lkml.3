Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729AbaANNSB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 08:18:01 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:40864 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbaANNRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 08:17:55 -0500
MIME-Version: 1.0
In-Reply-To: <20140114125153.GY7572@laptop.programming.kicks-ass.net>
References: <20140114155331.88d170d3c991b9465c23a537@canb.auug.org.au>
	<20140114125153.GY7572@laptop.programming.kicks-ass.net>
Date: Tue, 14 Jan 2014 14:17:55 +0100
X-Google-Sender-Auth: -kJqBQzm8M5hTulzUFff3VhHfsk
Message-ID: <CAMuHMdUPJ7pu5J6om+j=Tm8xDXhXU3sD4k7ZP6b4Xu-tF+gK2w@mail.gmail.com>
Subject: Re: linux-next: manual merge of the akpm-current tree with the tip tree
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux-Next <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 1:51 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Jan 14, 2014 at 03:53:31PM +1100, Stephen Rothwell wrote:
>> Today's linux-next merge of the akpm-current tree got a conflict in
>> kernel/futex.c between commit a52b89ebb6d4 ("futexes: Increase hash table
>> size for better performance") from the tip tree and commit 61beee6c76e5
>> ("futex: switch to USER_DS for futex test") from the akpm-current tree.
>>
>> @@@ -2869,10 -2748,13 +2871,13 @@@
>>        * implementation, the non-functional ones will return
>>        * -ENOSYS.
>>        */
>> +     fs = get_fs();
>> +     set_fs(USER_DS);
>>       if (cmpxchg_futex_value_locked(&curval, NULL, 0, 0) == -EFAULT)
>>               futex_cmpxchg_enabled = 1;
>> +     set_fs(fs);
>>
>
> This seems terribly broken, the *futex_value*() ops should not need
> that; they are supposed to access userspace without any of that.

Why don't they need set_fs(USER_DS)?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
