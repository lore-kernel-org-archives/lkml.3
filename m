Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627AbaHKXAY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 19:00:24 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:47772 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbaHKXAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 19:00:23 -0400
Date: Tue, 12 Aug 2014 01:00:20 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/2] nohz: Avoid double clock write
Message-ID: <20140811230018.GA1492@lerouge>
References: <1406825156-11901-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406825156-11901-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?

On Thu, Jul 31, 2014 at 06:45:54PM +0200, Frederic Weisbecker wrote:
> Hi Thomas,
> 
> The tick reschedules itself unconditionally. That's what we want as long
> as the CPU is in periodic mode. It's not that relevant when the CPU
> is in dynticks mode though as the clock write is likely to be overwritten
> by the nohz code on irq exit.
> 
> In low-res mode, that even result in unexpected periodic behaviour when
> no timer is scheduled in the future.
> 
> So here is a set that proposes the removal of these double writes.
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> 	origin/nohz/drop-double-write-v2
> 
> Thanks,
> 	Frederic
> ---
> 
> Viresh Kumar (2):
>       nohz: Fix spurious periodic tick behaviour in low-res dynticks mode
>       nohz: Avoid tick's double reprogramming in highres mode
> 
> 
>  kernel/time/tick-sched.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
