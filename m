Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbaBQWsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:48:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34668 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754101AbaBQWs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:48:29 -0500
Message-ID: <53029167.4060109@zytor.com>
Date: Mon, 17 Feb 2014 14:47:03 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Waiman Long <Waiman.Long@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Arnd Bergmann <arnd@arndb.de>
CC: linux-arch@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Daniel J Blueman <daniel@numascale.com>,
        Alexander Fyodorov <halcy@yandex.ru>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Subject: Re: [PATCH v4 0/3] qspinlock: Introducing a 4-byte queue spinlock
References: <1392669684-4807-1-git-send-email-Waiman.Long@hp.com>
In-Reply-To: <1392669684-4807-1-git-send-email-Waiman.Long@hp.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2014 12:41 PM, Waiman Long wrote:
> v3->v4:
>  - Remove debugging code and fix a configuration error
>  - Simplify the qspinlock structure and streamline the code to make it
>    perform a bit better
>  - Add an x86 version of asm/qspinlock.h for holding x86 specific
>    optimization.
>  - Add an optimized x86 code path for 2 contending tasks to improve
>    low contention performance.
> 
> v2->v3:
>  - Simplify the code by using numerous mode only without an unfair option.
>  - Use the latest smp_load_acquire()/smp_store_release() barriers.
>  - Move the queue spinlock code to kernel/locking.
>  - Make the use of queue spinlock the default for x86-64 without user
>    configuration.
>  - Additional performance tuning.
> 
> v1->v2:
>  - Add some more comments to document what the code does.
>  - Add a numerous CPU mode to support >= 16K CPUs
>  - Add a configuration option to allow lock stealing which can further
>    improve performance in many cases.
>  - Enable wakeup of queue head CPU at unlock time for non-numerous
>    CPU mode.
> 
> This patch set introduces a queue-based spinlock implementation that
> can replace the default ticket spinlock without increasing the size
> of the spinlock data structure. As a result, critical kernel data
> structures that embed spinlock won't increase in size and breaking
> data alignments.
> 

This is starting to look good, so I have pulled it into
tip:x86/spinlocks to start give it some testing mileage.

	-hpa


