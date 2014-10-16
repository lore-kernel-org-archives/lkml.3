Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbaJPOCw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 10:02:52 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:41438 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbaJPOCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 10:02:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAHFgRy-xjQk6VD1DjBRM3sNu3VMttCt5bygTvyd8voYGhbcbBw@mail.gmail.com>
References: <CAHFgRy-xjQk6VD1DjBRM3sNu3VMttCt5bygTvyd8voYGhbcbBw@mail.gmail.com>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Thu, 16 Oct 2014 15:02:29 +0100
X-Google-Sender-Auth: BGmllrmS5RUFHgYu2nKI6HpbncM
Message-ID: <CAHkRjk4Oe8iftfHhorjPLZ4bdi3AEveYkHmBsqbH+7R3oLSckA@mail.gmail.com>
Subject: Re: Linus GIT 3.17.0+ - BUG: unable to handle kernel paging request -
 IP: [<ffffffff81109e8d>] scan_block+0x59/0x100
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miles,

On 15 October 2014 04:43, Miles Lane <miles.lane@gmail.com> wrote:
> [   68.164917] BUG: unable to handle kernel paging request at ffff88021dc52000
> [   68.164957] IP: [<ffffffff81109e8d>] scan_block+0x59/0x100
> [   68.164987] PGD 2902067 PUD 2905067 PMD 21fdf2067 PTE 800000021dc52060

My reading of the x86 _PAGE_BIT_* macros show that this is not present.

> [   68.165020] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC

And this could be caused by CONFIG_DEBUG_PAGEALLOC, though kmemleak
should not try to access such memory.

> [   68.165945] Call Trace:
> [   68.165960]  [<ffffffff81528559>] ? _raw_spin_lock_irqsave+0x48/0x52
> [   68.165988]  [<ffffffff8110a016>] ? scan_gray_list+0xe2/0x15f
> [   68.166015]  [<ffffffff81109feb>] scan_gray_list+0xb7/0x15f
> [   68.166040]  [<ffffffff8110a32f>] kmemleak_scan+0x29c/0x466
> [   68.166066]  [<ffffffff8110a84d>] ? kmemleak_write+0x354/0x354
> [   68.166092]  [<ffffffff8110a8cf>] kmemleak_scan_thread+0x82/0xa4

I have a couple of questions:

1. Are there any messages prior to the dump you posted, like kmemleak
getting disabled?
2. Can you still reproduce the problem with !CONFIG_DEBUG_PAGEALLOC?

Thanks,

Catalin
