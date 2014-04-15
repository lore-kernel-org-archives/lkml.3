Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbaDOSog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 14:44:36 -0400
Received: from www.linutronix.de ([62.245.132.108]:59521 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551AbaDOSod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 14:44:33 -0400
Date: Tue, 15 Apr 2014 20:44:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: linaro-kernel@lists.linaro.org, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org, John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH V1 Resend 4/5] tick-sched: don't call update_wall_time()
 when delta is lesser than tick_period
In-Reply-To: <80afb18a494b0bd9710975bcc4de134ae323c74f.1397537987.git.viresh.kumar@linaro.org>
Message-ID: <alpine.DEB.2.02.1404152042480.22697@ionos.tec.linutronix.de>
References: <cover.1397537986.git.viresh.kumar@linaro.org> <80afb18a494b0bd9710975bcc4de134ae323c74f.1397537987.git.viresh.kumar@linaro.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Apr 2014, Viresh Kumar wrote:

> In tick_do_update_jiffies64() we are processing ticks only if delta is greater
> than tick_period. This is what we are supposed to do here and it broke a bit
> with this patch:
> 
> commit 47a1b796306356f358e515149d86baf0cc6bf007
> Author: John Stultz <john.stultz@linaro.org>
> Date:   Thu Dec 12 13:10:55 2013 -0800
> 
>     tick/timekeeping: Call update_wall_time outside the jiffies lock

Please look how I massaged the change log. There is no point in
copying the whole gunk.
 
> With above patch, we might end up calling update_wall_time() even if delta is
> found to be smaller that tick_period. Fix this by reversing the check and
> returning early.

Well.

> Cc: <stable@vger.kernel.org> # v3.14+
> Cc: John Stultz <john.stultz@linaro.org>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  kernel/time/tick-sched.c | 32 +++++++++++++++++---------------
>  1 file changed, 17 insertions(+), 15 deletions(-)

That's not how we do bug fixes if they can be done with 3 lines of
change. See the commit.

Thanks,

	tglx


