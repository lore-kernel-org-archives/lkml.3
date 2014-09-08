Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbaIHXiF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 19:38:05 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:46342 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbaIHXiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 19:38:03 -0400
Message-ID: <540E3D60.2020906@hp.com>
Date: Mon, 08 Sep 2014 19:36:00 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Pranith Kumar <bobby.prani@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Question reg. asm/qrwlock.h
References: <CAJhHMCCDPe_GGDWUF3OHQieCKLty2+TaYZwnKjK9ZF3z0auo8A@mail.gmail.com>
In-Reply-To: <CAJhHMCCDPe_GGDWUF3OHQieCKLty2+TaYZwnKjK9ZF3z0auo8A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2014 07:45 PM, Pranith Kumar wrote:
> Hi Waiman,
>
> I see that in arch/x86/include/asm/qrwlock.h, there is this snippet within
>
> #ifndef CONFIG_X86_PPRO_FENCE
> #define queue_write_unlock queue_write_unlock
> static inline void queue_write_unlock(struct qrwlock *lock)
> {
>          barrier();
>          ACCESS_ONCE(*(u8 *)&lock->cnts) = 0;
> }
> #endif
>
>
> I've been trying to understand why this special case is necessary for
> PPRO. Could you please explain?
>
> Thanks!

This is related to the memory ordering of the x86 architecture. Modern 
x86 processor has pretty strong memory ordering semantics where only 
stores can be reordered after load. So a barrier() call is a good enough 
memory barrier except for some older x86 processors (Pentium Pro) that 
should have CONFIG_X86_PPRO_FENCE set. In that case, atomic instruction 
like cmpxchg() will be needed to ensure proper memory ordering.

-Longman
