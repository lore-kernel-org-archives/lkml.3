Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab3IQHHg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 03:07:36 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:53493 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab3IQHHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 03:07:32 -0400
Date: Tue, 17 Sep 2013 09:07:28 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, gerlando.falauto@keymile.com,
        john.stultz@linaro.org, minggr@gmail.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org, lttng-dev@lists.lttng.org
Subject: Re: [tip:timers/urgent] timekeeping: Fix HRTICK related deadlock
 from ntp lock changes
Message-ID: <20130917070728.GC20661@gmail.com>
References: <1378943457-27314-1-git-send-email-john.stultz@linaro.org>
 <tip-7bd36014460f793c19e7d6c94dab67b0afcfcb7f@git.kernel.org>
 <20130916160426.GA24669@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130916160426.GA24669@Krystal>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> Hi Ingo,
> 
> Do you have an estimate of the time it will take for this fix to hit 
> mainline, stable-3.10 and stable-3.11 ? Meanwhile, I'm marking 3.10 and 
> 3.11 as broken for LTTng with a kernel version at compile-time, since 
> this kernel regression currently triggers hard system lockup when people 
> use LTTng on those kernels, and this is certainly something nobody 
> wants.

So, at least as per the description of John, this should only trigger if 
SCHED_HRTICK is enabled in sched_features - which is disabled by default, 
it's a debug-only development feature. Does the bug trigger on more 
regular kernels as well?

I planned to send it Linus after v3.12-rc1, in the next day or two.

Thanks,

	Ingo
