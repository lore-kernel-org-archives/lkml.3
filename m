Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbaBTTVP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 14:21:15 -0500
Received: from g2t2353.austin.hp.com ([15.217.128.52]:59103 "EHLO
	g2t2353.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494AbaBTTVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 14:21:13 -0500
Message-ID: <530655A3.4050105@hp.com>
Date: Thu, 20 Feb 2014 14:21:07 -0500
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Daniel J Blueman <daniel@numascale.com>,
        Alexander Fyodorov <halcy@yandex.ru>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Subject: Re: [PATCH v4 0/3] qspinlock: Introducing a 4-byte queue spinlock
References: <1392669684-4807-1-git-send-email-Waiman.Long@hp.com> <53029167.4060109@zytor.com> <20140218073111.GW27965@twins.programming.kicks-ass.net> <5303B4C4.2040907@hp.com> <20140218212827.GR14089@laptop.programming.kicks-ass.net> <5303FDEC.9060001@hp.com> <20140219085107.GG27965@twins.programming.kicks-ass.net> <53050501.3070101@hp.com> <CA+55aFwyVgLJq2OgKZBK7g+T5-_M4o+dnEAr+qtYxA5t_=HSvA@mail.gmail.com> <5306413F.3010106@hp.com> <CA+55aFyJTOwnSJxc_qeHxKGoZ71xo3UWc4DrAJ5=OAtOvG7_CA@mail.gmail.com>
In-Reply-To: <CA+55aFyJTOwnSJxc_qeHxKGoZ71xo3UWc4DrAJ5=OAtOvG7_CA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2014 01:42 PM, Linus Torvalds wrote:
> On Thu, Feb 20, 2014 at 9:54 AM, Waiman Long<waiman.long@hp.com>  wrote:
>> I think we could implement 2 versions of _raw_spin_lock.
> Yup. Or rather,  I'd suggest implement just one version of
> arch_spin_lock(), but at the top of it you do something like
>
>     #if CONFIG_PARAVIRT_SPINLOCK
>          if (static_key_false(&unfair_spinlocks)) {
>             .. do paravirt unfair lock version ..
>          }
>     #endif
>
> which should basically generate almost-perfect code:  it's one extra
> no-op for the native case if CONFIG_PARAVIRT_SPINLOCK is on, which
> turns into a branch for the unfair version for paravirtualization.
>
> Or something like that.
>
>                Linus

Yes, this is actually what I meant. The only difference is that I am 
thinking about using a different config variable as PARAVIRT_SPINLOCKS 
actually mean something else.

-Longman
