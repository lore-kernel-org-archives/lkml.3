Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689AbaFDOFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 10:05:22 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:37407 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbaFDOFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 10:05:20 -0400
Date: Wed, 4 Jun 2014 16:05:14 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Kevin Hilman <khilman@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [Query] Can we use normal timers (kernel/timer.c) while in
 NO_HZ_FULL mode?
Message-ID: <20140604140512.GD13827@localhost.localdomain>
References: <CAKohponiCH35ZBTicCkVV3KoJzCWrnJExeR9HqwSMv+QDp36gg@mail.gmail.com>
 <20140604132305.GB13827@localhost.localdomain>
 <CAKohpo=JRKO7x3izE7jG-MAUdXexNzxpG0FT5adNQmKi0+Bauw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpo=JRKO7x3izE7jG-MAUdXexNzxpG0FT5adNQmKi0+Bauw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 07:14:43PM +0530, Viresh Kumar wrote:
> On 4 June 2014 18:53, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > Right, if we enqueue a timer when the tick is stopped, we call wake_up_nohz_cpu().
> 
> Ahh, I looked at __mod_timer() :)
> 
> BTW, shouldn't we do something similar for mod_timer_pinned()
> as well ?

Ah that looks right. In fact we should probably move the wake_up_nohz_cpu()
to internal_add_timer().

And that concerns nohz idle as well. If mod_timer() selects a CPU that doesn't
appear to be idle in get_nohz_timer_target() but then becomes idle afterward
before we lock its timer base, the CPU may well miss the timer.
