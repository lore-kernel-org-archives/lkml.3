Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab3L0OoY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 09:44:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753137Ab3L0OoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 09:44:23 -0500
Date: Fri, 27 Dec 2013 15:45:04 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: Question about /proc/uptime
Message-ID: <20131227144504.GA17192@redhat.com>
References: <1388025009.1176.17@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388025009.1176.17@driftwood>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Frederic, I am not sure I understand this correctly.

On 12/25, Rob Landley wrote:
>
> There are two values here, the first is seconds since boot time (which
> is just elapsed time; at one point it was ajusted for suspend and that
> was revered as confusing).

Hmm, uptime_proc_show() still uses get_monotonic_boottime(), this should
include suspend time?

> The second value isn't documented but looking at fs/proc/uptime.c I
> think it's idle time?

And this cpustat[CPUTIME_IDLE] doesn't match get_idle_time(), I guess
it only counts ticks.

> Except, if yo uadd up the idle time from all
> processors wouldn't you get 4x the uptime on a 4-way SMP system that's
> been idle since boot?

Yes, looks strange.

> Also, is this actual "cpu was on but not doing anything" time, so
> doesn't count suspend as idle?

I think suspend is not counted as idle.

> Confused,

I guess the 2nd value is historical, probably you should use /proc/stat.

Oleg.

