Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbaFDNxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 09:53:22 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:36141 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbaFDNxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 09:53:21 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpo=JRKO7x3izE7jG-MAUdXexNzxpG0FT5adNQmKi0+Bauw@mail.gmail.com>
References: <CAKohponiCH35ZBTicCkVV3KoJzCWrnJExeR9HqwSMv+QDp36gg@mail.gmail.com>
	<20140604132305.GB13827@localhost.localdomain>
	<CAKohpo=JRKO7x3izE7jG-MAUdXexNzxpG0FT5adNQmKi0+Bauw@mail.gmail.com>
Date: Wed, 4 Jun 2014 19:23:20 +0530
Message-ID: <CAKohpo=SFU4vyHTPcZHSFvbaviZJrxENOtJcqUd7Z5qcGpb0Fw@mail.gmail.com>
Subject: Re: [Query] Can we use normal timers (kernel/timer.c) while in
 NO_HZ_FULL mode?
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Kevin Hilman <khilman@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 June 2014 19:14, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> BTW, shouldn't we do something similar for mod_timer_pinned()
> as well ?

Also, as we aren't forcing get_nohz_timer_target() to _not_ return
a NO_HZ_FULL, we might end up queuing a timer on NO_HZ_FULL
cpu with the unpinned timer APIs. And the same question might
stand true for this case as well?
