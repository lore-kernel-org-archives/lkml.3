Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbaBTRoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 12:44:15 -0500
Received: from mail-ve0-f177.google.com ([209.85.128.177]:64597 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938AbaBTRoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 12:44:12 -0500
MIME-Version: 1.0
In-Reply-To: <53063D4A.9010601@hp.com>
References: <1392669684-4807-1-git-send-email-Waiman.Long@hp.com>
	<53029167.4060109@zytor.com>
	<20140218073111.GW27965@twins.programming.kicks-ass.net>
	<5303B4C4.2040907@hp.com>
	<20140218212827.GR14089@laptop.programming.kicks-ass.net>
	<5303FDEC.9060001@hp.com>
	<20140219085107.GG27965@twins.programming.kicks-ass.net>
	<53050501.3070101@hp.com>
	<20140219194832.GY14089@laptop.programming.kicks-ass.net>
	<53063D4A.9010601@hp.com>
Date: Thu, 20 Feb 2014 09:44:11 -0800
X-Google-Sender-Auth: tU93yse3zblB89kqfKO_YeOt-Z0
Message-ID: <CA+55aFwZ_-m46qZT586Rae3yESLCVZm6yM8WxMs2kZyCvpM5YA@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] qspinlock: Introducing a 4-byte queue spinlock
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 9:37 AM, Waiman Long <waiman.long@hp.com> wrote:
>
> Yes, that is true for paravirt, but I was talking about virtualization in
> general.

For non-paravirtualized environments, we should basically optimize for
the actual hardware, and assume that the full virtualization is good
enough that we don't care.

Obviously, sometimes we might take "this is particularly expensive to
virtualize" into account, and if it doesn't hurt hardware, try to help
the virtual environment along. So you might have cases where certain
hardware (typically interrupt controllers etc) should be accessed
certain particular ways, because those not only work on real hardware,
but behave well in virtualized environments too.

But for spinlocks, just make the raw hardware work well when not
*actively* paravirtualized. If some hypervisor deals badly with it,
it's a hypervisor or management problem.

            Linus
