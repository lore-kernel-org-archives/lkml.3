Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbaFDOG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 10:06:58 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:46526 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbaFDOG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 10:06:57 -0400
Date: Wed, 4 Jun 2014 16:06:52 +0200
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
Message-ID: <20140604140650.GE13827@localhost.localdomain>
References: <CAKohponiCH35ZBTicCkVV3KoJzCWrnJExeR9HqwSMv+QDp36gg@mail.gmail.com>
 <20140604132305.GB13827@localhost.localdomain>
 <CAKohpo=JRKO7x3izE7jG-MAUdXexNzxpG0FT5adNQmKi0+Bauw@mail.gmail.com>
 <CAKohpo=SFU4vyHTPcZHSFvbaviZJrxENOtJcqUd7Z5qcGpb0Fw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpo=SFU4vyHTPcZHSFvbaviZJrxENOtJcqUd7Z5qcGpb0Fw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 07:23:20PM +0530, Viresh Kumar wrote:
> On 4 June 2014 19:14, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> > BTW, shouldn't we do something similar for mod_timer_pinned()
> > as well ?
> 
> Also, as we aren't forcing get_nohz_timer_target() to _not_ return
> a NO_HZ_FULL, we might end up queuing a timer on NO_HZ_FULL
> cpu with the unpinned timer APIs. And the same question might
> stand true for this case as well?

Right.
