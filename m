Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbaJ1DLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:11:17 -0400
Received: from mail-yh0-f45.google.com ([209.85.213.45]:40014 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbaJ1DLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:11:16 -0400
MIME-Version: 1.0
In-Reply-To: <1413986273-28522-3-git-send-email-daniel.lezcano@linaro.org>
References: <1413986273-28522-1-git-send-email-daniel.lezcano@linaro.org>
	<1413986273-28522-3-git-send-email-daniel.lezcano@linaro.org>
Date: Mon, 27 Oct 2014 23:11:15 -0400
X-Google-Sender-Auth: yYw_o24gwNayYdCSgH3hMrsunf4
Message-ID: <CAJvTdKmiRR9OTsxRV0OWGrYndRtcFivqnwRM+iJuD4FK3HQjZA@mail.gmail.com>
Subject: Re: [RFD PATCH 02/10] cpuidle: Checking the zero latency inside the
 governors does not make sense.
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

after the patch '[V2,1/5] sched: idle: cpuidle: Check the latency req
before idle' is applied,
this one becomes a no-op.

indeed, they'd conflict both logically and physically.
physically the check for latency_req == 0 was already removed from the
governors.
logically, the upper level, cpu_idle_loop() already invokes
cpu_idle_poll() directly
when latency_req is 0.  Indeed, that would prevent the code in this
patch from running
at all, since cpu_idle_call() is no longer invoked in that case.
Further, why would
you propose invoking "use_default" instead of cpu_idle_poll() in the
latency_req == 0 case?

thanks,
Len Brown, Intel Open Source Technology Center
