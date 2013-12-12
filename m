Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734Ab3LLQfW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 11:35:22 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:46201 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab3LLQfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 11:35:19 -0500
Message-ID: <52A9E5B2.8040702@oracle.com>
Date: Thu, 12 Dec 2013 11:34:58 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>, LKML <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Prarit Bhargava <prarit@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [RFC][PATCH 3/5] timekeeping: Avoid possible deadlock from clock_was_set_delayed
References: <1386789098-17391-1-git-send-email-john.stultz@linaro.org> <1386789098-17391-4-git-send-email-john.stultz@linaro.org>
In-Reply-To: <1386789098-17391-4-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2013 02:11 PM, John Stultz wrote:
> As part of normal operaions, the hrtimer subsystem frequently calls
> into the timekeeping code, creating a locking order of
>    hrtimer locks -> timekeeping locks
>
> clock_was_set_delayed() was suppoed to allow us to avoid deadlocks
> between the timekeeping the hrtimer subsystem, so that we could
> notify the hrtimer subsytem the time had changed while holding
> the timekeeping locks. This was done by scheduling delayed work
> that would run later once we were out of the timekeeing code.
>
> But unfortunately the lock chains are complex enoguh that in
> scheduling delayed work, we end up eventually trying to grab
> an hrtimer lock.
>
> Sasha Levin noticed this in testing when the new seqlock lockdep
> enablement triggered the following (somewhat abrieviated) message:

[snip]

This seems to work for me, I don't see the lockdep spew anymore.

	Tested-by: Sasha Levin <sasha.levin@oracle.com>


Thanks,
Sasha
