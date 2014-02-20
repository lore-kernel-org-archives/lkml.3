Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbaBTRyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 12:54:18 -0500
Received: from g2t2354.austin.hp.com ([15.217.128.53]:33528 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbaBTRyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 12:54:16 -0500
X-Greylist: delayed 147823 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Feb 2014 12:54:16 EST
Message-ID: <5306413F.3010106@hp.com>
Date: Thu, 20 Feb 2014 12:54:07 -0500
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
References: <1392669684-4807-1-git-send-email-Waiman.Long@hp.com> <53029167.4060109@zytor.com> <20140218073111.GW27965@twins.programming.kicks-ass.net> <5303B4C4.2040907@hp.com> <20140218212827.GR14089@laptop.programming.kicks-ass.net> <5303FDEC.9060001@hp.com> <20140219085107.GG27965@twins.programming.kicks-ass.net> <53050501.3070101@hp.com> <CA+55aFwyVgLJq2OgKZBK7g+T5-_M4o+dnEAr+qtYxA5t_=HSvA@mail.gmail.com>
In-Reply-To: <CA+55aFwyVgLJq2OgKZBK7g+T5-_M4o+dnEAr+qtYxA5t_=HSvA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2014 03:17 PM, Linus Torvalds wrote:
> On Wed, Feb 19, 2014 at 11:24 AM, Waiman Long<waiman.long@hp.com>  wrote:
>> We do have a CONFIG_PARAVIRT macro that turns on or off PV support. The
>> queue spinlock can be easily changed into an unfair lock which allows lock
>> stealing. We could have a config option to make it unfair in the PARAVIRT
>> environment, but I don't think Linus like the idea of an unfair lock.
> I could care less for the paravirt case. As long as the native case
> ends up being sane (even when CONFIG_PARAVIRT is set at compile time),
> I'm fine.
>
> When actually running in a paravirtualized environment, locks are
> always going to have problems.
>
>                    Linus

I think we could implement 2 versions of _raw_spin_lock. The primary one 
is fair and the other one is unfair with a jump label that jump from the 
fair version to the unfair version. At boot time, the kernel can check 
to see it is really running in a PV environment and then activate the 
jump label to use the unfair version.

Now the key is how to detect if a kernel is really running in a PV 
environment. I need to ask some virtualization experts on that.

-Longman
