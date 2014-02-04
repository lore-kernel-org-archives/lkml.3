Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbaBDQKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 11:10:23 -0500
Received: from www.linutronix.de ([62.245.132.108]:47312 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440AbaBDQKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 11:10:20 -0500
Date: Tue, 4 Feb 2014 17:10:24 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexey Perevalov <a.perevalov@samsung.com>
cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        anton@enomsg.org, kyungmin.park@samsung.com, akpm@linux-foundation.org,
        cw00.choi@samsung.com
Subject: Re: [PATCH v2 0/3] Deferrable timers support for timerfd API
In-Reply-To: <52E606D8.6000401@samsung.com>
Message-ID: <alpine.DEB.2.02.1402041419420.24986@ionos.tec.linutronix.de>
References: <1389609835-24377-1-git-send-email-a.perevalov@samsung.com> <52DEC6A3.9020600@linaro.org> <52E606D8.6000401@samsung.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jan 2014, Alexey Perevalov wrote:
> On 01/21/2014 11:12 PM, John Stultz wrote:
> > 
> > Thomas: Any thought here? Should we be trying to unify the timerfd flags
> > and the posix timer flags (specifically things like TIMER_CANCEL_ON_SET,
> > which is currently timerfd-only)?  Should a deferrable flag be added to
> > the hrtimer core or left to the timer wheel?

The timer cancel on set was added only to timerfd because timerfd is a
non posix interface and we are halfways free to add stuff to
it. Adding extra flags to the real posix timer interfaces is a
different story.

What's the rationale for a deferrable flag for user space interfaces?

Thanks,

	tglx
