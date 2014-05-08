Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbaEHRez (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 13:34:55 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57866 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907AbaEHRex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 13:34:53 -0400
Date: Thu, 08 May 2014 13:34:51 -0400 (EDT)
Message-Id: <20140508.133451.1383193780216133211.davem@davemloft.net>
To: peterz@infradead.org
Cc: geert@linux-m68k.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, mingo@kernel.org, will.deacon@arm.com,
        paulmck@linux.vnet.ibm.com, jesper.nilsson@axis.com, starvik@axis.com
Subject: Re: [PATCH 07/20] arch,cris: Fold atomic_ops
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140508160606.GD30445@twins.programming.kicks-ass.net>
References: <20140508135852.104572724@infradead.org>
	<CAMuHMdV7FUC+p5XqwLZmqJRLYv1qhu5hf0M_e5pASBRHgFAhCA@mail.gmail.com>
	<20140508160606.GD30445@twins.programming.kicks-ass.net>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 08 May 2014 10:34:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>
Date: Thu, 8 May 2014 18:06:06 +0200

> On Thu, May 08, 2014 at 05:12:31PM +0200, Geert Uytterhoeven wrote:
>> Hi Peter,
>> 
>> On Thu, May 8, 2014 at 3:58 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > Many of the atomic op implementations are the same except for one
>> > instruction; fold the lot into a few CPP macros and reduce LoC.
>> >
>> > This also prepares for easy addition of new ops.
>> >
>> > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
>> > Cc: Jesper Nilsson <jesper.nilsson@axis.com>
>> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
>> > Cc: Mikael Starvik <starvik@axis.com>
>> > Signed-off-by: Peter Zijlstra <peterz@infradead.org>
>> > ---
>> >  arch/cris/include/arch-v10/arch/system.h |    2 -
>> >  arch/cris/include/asm/atomic.h           |   57 +++++++++++++------------------
>> >  2 files changed, 25 insertions(+), 34 deletions(-)
>> >
>> > Index: linux-2.6/arch/cris/include/arch-v10/arch/system.h
>> > ===================================================================
>> > --- linux-2.6.orig/arch/cris/include/arch-v10/arch/system.h
>> > +++ linux-2.6/arch/cris/include/arch-v10/arch/system.h
>> > @@ -36,8 +36,6 @@ static inline unsigned long _get_base(ch
>> >    return 0;
>> >  }
>> >
>> > -#define nop() __asm__ __volatile__ ("nop");
>> > -
>> 
>> Is this change supposed to be part of this series?
> 
> Uhm, lemme double check that. Good spotting.
> 
> Nope, it builds just fine without that hunk, *poof* gone.

You did this for sparc too.
