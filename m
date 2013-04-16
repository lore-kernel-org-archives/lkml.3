Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935490Ab3DPDCa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 23:02:30 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:40477 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935212Ab3DPDC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 23:02:28 -0400
MIME-Version: 1.0
In-Reply-To: <20130415171429.GF3672@sgi.com>
References: <20130415171225.GC3658@sgi.com>
	<20130415171429.GF3672@sgi.com>
Date: Tue, 16 Apr 2013 11:02:27 +0800
Message-ID: <CAAQ0ZWTTd4s4dNCzF-rhyaav6wXZRiUcHRTkJhpQgP5AnUH17g@mail.gmail.com>
Subject: Re: [Patch -v3 1/4] Migrate shutdown/reboot to boot cpu.
From: Shawn Guo <shawn.guo@linaro.org>
To: Robin Holt <holt@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>, Russ Anderson <rja@sgi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michel Lespinasse <walken@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        Tejun Heo <tj@kernel.org>, "the arch/x86 maintainers" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 12:14:29PM -0500, Robin Holt wrote:
> We recently noticed that reboot of a 1024 cpu machine takes approx 16
> minutes of just stopping the cpus.  The slowdown was tracked to commit
> f96972f.
>
> The current implementation does all the work of hot removing the cpus
> before halting the system.  We are switching to just migrating to the
> boot cpu and then continuing with shutdown/reboot.
>
> This also has the effect of not breaking x86's command line parameter for
> specifying the reboot cpu.  Note, this code was shamelessly copied from
> arch/x86/kernel/reboot.c with bits removed pertaining to the reboot_cpu
> command line parameter.
>
> Signed-off-by: Robin Holt <holt@sgi.com>
> To: Shawn Guo <shawn.guo@linaro.org>

It works on my hardware - i.MX6 Quad.

Tested-by: Shawn Guo <shawn.guo@linaro.org>
