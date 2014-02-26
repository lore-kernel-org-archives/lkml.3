Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362AbaBZCxO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 21:53:14 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:41796 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbaBZCxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 21:53:13 -0500
Message-ID: <530D5715.1050901@mit.edu>
Date: Tue, 25 Feb 2014 18:53:09 -0800
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Alexey Perevalov <a.perevalov@samsung.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, john.stultz@linaro.org
CC: Anton Vorontsov <anton@enomsg.org>, kyungmin.park@samsung.com,
        cw00.choi@samsung.com, akpm@linux-foundation.org,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: Re: [PATCH v4 5/6] timerfd: Add support for deferrable timers
References: <1392913425-29369-1-git-send-email-a.perevalov@samsung.com> <1392913425-29369-6-git-send-email-a.perevalov@samsung.com>
In-Reply-To: <1392913425-29369-6-git-send-email-a.perevalov@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2014 08:23 AM, Alexey Perevalov wrote:
> From: Anton Vorontsov <anton@enomsg.org>
> 
> This patch implements a userland-side API for generic deferrable timers,
> per linux/timer.h:
> 
>  * A deferrable timer will work normally when the system is busy, but
>  * will not cause a CPU to come out of idle just to service it; instead,
>  * the timer will be serviced when the CPU eventually wakes up with a
>  * subsequent non-deferrable timer.
> 
> These timers are crucial for power saving, i.e. periodic tasks that want
> to work in background when the system is under use, but don't want to
> cause wakeups themselves.

Please don't.  This API sucks for all kinds of reasons:

 - Why is it a new kind of clock?
 - How deferrable is deferrable?
 - It adds new core code, which serves no purpose (the problem is
already solved).

On the other hand, if you added a fancier version of timerfd_settime
that could explicitly set the slack value (or, equivalently, the
earliest and latest allowable times), that could be quite useful.

It's often bugged me that timer slack is per-process.

--Andy

