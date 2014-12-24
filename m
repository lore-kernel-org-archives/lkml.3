Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbaLXOAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 09:00:01 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:32363 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbaLXN77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 08:59:59 -0500
Message-ID: <549AC69B.90309@oracle.com>
Date: Wed, 24 Dec 2014 08:58:51 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?windows-1252?Q?D=E2niel_Fraga?= <fragabr@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Anvin <hpa@linux.intel.com>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: frequent lockups in 3.18rc4
References: <CA+55aFzj_2tYJ1b=_7eKSz7UMuUL+qZX39r0xq5vOZkB4JmHMA@mail.gmail.com> <CA+55aFyQzpQgT91sqpEhXho8KoVRkA1MeRjk+fXO7w2dJkY_Gg@mail.gmail.com> <CA+55aFy8DCMmkPRz0kqNC80pn4VkeQr2Wz2fTRm=32oH2dhfRQ@mail.gmail.com> <CA+55aFwA7uOFgb-Y4dHS099HuoV+oQvxXf+cfZYh9T7H_c0PHA@mail.gmail.com> <20141221223204.GA9618@codemonkey.org.uk> <CA+55aFygv+PRcYScwCjGVQ7-0PA1mHOGYaKGKS4LBhxPm0YBJA@mail.gmail.com> <CA+55aFwaghUQxp9LJRWH6ANCX5y45c3Fu9T0OnpBaqRdn1=tvw@mail.gmail.com> <CA+55aFz0n=sJgn5LeBLcTzj9=eCVkrWiQZNCKupuD7CMTwm=jQ@mail.gmail.com> <20141222225725.GA8140@codemonkey.org.uk> <CA+55aFzjA_KSqUJiKm5qeZEeFBdrg17doANao+8iphBvVM8boQ@mail.gmail.com> <20141223145633.GF27965@codemonkey.org.uk>
In-Reply-To: <20141223145633.GF27965@codemonkey.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2014 09:56 AM, Dave Jones wrote:
> On Mon, Dec 22, 2014 at 03:59:19PM -0800, Linus Torvalds wrote:
>  
>  > But in the meantime please do keep that thing running as long as you
>  > can. Let's see if we get bigger jumps. Or perhaps we'll get a negative
>  > result - the original softlockup bug happening *without* any bigger
>  > hpet jumps.
> 
> It's been going for 18 hours, with just a bunch more of those hpet
> messages, all in the same range.  I'll leave it go a few more hours,
> before I have to wipe it, but I've got feel-good vibes about this.
> Even if that patch isn't the solution, It seems like we're finally
> looking in the right direction.

I've got myself a physical server to play with, and running trinity on it
seems to cause similar stalls:

 2338.389210] INFO: rcu_sched self-detected stall on CPU[ 2338.429153] INFO: rcu_sched detected stalls on CPUs/tasks:[ 2338.429164] 	16: (5999 ticks this GP) idle=4b5/140000000000001/0 softirq=24859/24860 last_accelerate: 039d/1b78, nonlazy_posted: 64, ..
[ 2338.429165] 	
[ 2338.680231] 	16: (5999 ticks this GP) idle=4b5/140000000000001/0 softirq=24859/24860 last_accelerate: 039d/1b91, nonlazy_posted: 64, ..
[ 2338.828353] 	 (t=6044 jiffies g=16473 c=16472 q=4915881)

Oddly enough, there's no stacktrace...


Thanks,
Sasha
