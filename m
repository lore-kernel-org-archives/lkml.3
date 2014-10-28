Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbaJ1DTw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:19:52 -0400
Received: from mail-yh0-f53.google.com ([209.85.213.53]:49842 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbaJ1DTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:19:50 -0400
MIME-Version: 1.0
In-Reply-To: <1413986273-28522-2-git-send-email-daniel.lezcano@linaro.org>
References: <1413986273-28522-1-git-send-email-daniel.lezcano@linaro.org>
	<1413986273-28522-2-git-send-email-daniel.lezcano@linaro.org>
Date: Mon, 27 Oct 2014 23:19:49 -0400
X-Google-Sender-Auth: F9KuLWKSJii5UOWBrBNrR1zlP7Q
Message-ID: <CAJvTdKkF1Z9eUwjv4-idzCUTzD_MdEeZWOxkB+VmGoEcnJfk-A@mail.gmail.com>
Subject: Re: [RFD PATCH 01/10] sched: add io latency framework
From: Len Brown <lenb@kernel.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        axboe@kernel.dk, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        preeti@linux.vnet.ibm.com, Morten Rasmussen <Morten.Rasmussen@arm.com>,
        mturquette@linaro.org, Tuukka Tikkanen <tuukka.tikkanen@linaro.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Patch Tracking <patches@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There is a rb tree per cpu. Each time a task is blocked on an IO, it
> is inserted into the tree. When the IO is complete and the task is
> woken up, its avg latency is updated with the time spent to wait the
> IO and it is removed from the tree. The next time, it will be inserted
> into the tree again in case of io_schedule.

Is there an assumption built-in here that the device interrupt is targeted
at the same CPU as where the task is queued?

thanks,
Len Brown, Intel Open Source Technology Center
