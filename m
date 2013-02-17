Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983Ab3BQSyc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 13:54:32 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:31347 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139Ab3BQSyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 13:54:31 -0500
Message-ID: <51212734.2060700@parallels.com>
Date: Sun, 17 Feb 2013 22:53:40 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Jann Horn <jannhorn@googlemail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>, linux-api@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] posix timers: Add syscall that works on timer sigevent
References: <511D0E50.7090505@parallels.com> <511D0EA1.9060704@parallels.com> <20130217134248.GD13378@debjann.fritz.box>
In-Reply-To: <20130217134248.GD13378@debjann.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2013 05:42 PM, Jann Horn wrote:
> On Thu, Feb 14, 2013 at 08:19:45PM +0400, Pavel Emelyanov wrote:
>> +	struct sigevent event;
> [...]
>> +	event.sigev_notify = timer->it_sigev_notify;
>> +	event.sigev_signo = timer->sigq->info.si_signo;
>> +	event.sigev_value = timer->sigq->info.si_value;
>> +	event.sigev_notify_thread_id = pid_vnr(timer->it_pid);
> [...]
>> +	if (old_event && copy_to_user(old_event, &event, sizeof(event)))
> 
> Won't this leak uninitialized kernel stack data to userspace? As far as I can
> see, the _sigev_un union is bigger than the _tid field in it, so the rest of
> it will be copied over without initialization, right?

Indeed :( Thanks for catching this, I will memezro the thing before copying
to the user-space.

> Jann
> 


