Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab3JJEfY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 00:35:24 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:49676 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab3JJEfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 00:35:23 -0400
Date: Thu, 10 Oct 2013 06:35:19 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Dong Zhu <bluezhudong@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] timer stats: reset entries when disable the timer
 usage statistics
Message-ID: <20131010043519.GB22519@gmail.com>
References: <20131010025947.GD2139@zhudong.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010025947.GD2139@zhudong.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dong Zhu <bluezhudong@gmail.com> wrote:

> From f41628c61d8a9172677ba33a55b61e37ce28f7a6 Mon Sep 17 00:00:00 2001
> From: Dong Zhu <bluezhudong@gmail.com> 
> Date: Thu, 10 Oct 2013 10:38:13 +0800
> 
> When we stop timer statistics collection (via echo 0 > 
> /proc/timers_stats), the statistics data is still exported as if it were 
> correct, which can cause applicaitons to misuse the statistics.

What misuse do you mean?

> This patch resets the statistics when we stop collecting them, to avoid 
> this problem.

Well, this loses the handy 'snapshot' property of /proc/timer_stats. 
Before this change one could do:

	echo 1 > /proc/timers_stats
	sleep 60 # run system workload
	echo 0 > /proc/timers_stats

and examine the 1-minute collection result without it changing. Your 
change, if I understand it correctly, zeroes it all out.

Instead of this change I'd suggest adding a 'status' line, with two 
outputs:

	Status: collection active

	Status: collection disabled

Thanks,

	Ingo
