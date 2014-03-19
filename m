Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965146AbaCSNLj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:11:39 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:54822 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965129AbaCSNLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:11:35 -0400
MIME-Version: 1.0
In-Reply-To: <20140319065205.319240141@infradead.org>
References: <20140319064729.660482086@infradead.org>
	<20140319065205.319240141@infradead.org>
Date: Wed, 19 Mar 2014 17:11:34 +0400
Message-ID: <CAMo8BfLLFqYz96LLJy0f+9XgAdQVUVhRg_VGp+yG92Gfk=sfaQ@mail.gmail.com>
Subject: Re: [PATCH 29/31] arch,xtensa: Convert smp_mb__*
From: Max Filippov <jcmvbkbc@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, will.deacon@arm.com,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Wed, Mar 19, 2014 at 10:47 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> Xtensa SMP has ll/sc which is fully serializing, therefore its exising

One minor correction: current xtensa ISA doens't have ll/sc, it only
has cas (s32c1i instruction), which is fully serializing.

> smp_mb__{before,after}_clear_bit() appear unduly heavy.
>
> Implement the new barriers are barrier().
>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
>  arch/xtensa/include/asm/atomic.h  |    7 +------
>  arch/xtensa/include/asm/barrier.h |    3 +++
>  arch/xtensa/include/asm/bitops.h  |    4 +---
>  3 files changed, 5 insertions(+), 9 deletions(-)

-- 
Thanks.
-- Max
