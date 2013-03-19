Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab3CSFAU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 01:00:20 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:54885 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106Ab3CSFAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 01:00:18 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1363617402.git.viresh.kumar@linaro.org>
References: <cover.1363617402.git.viresh.kumar@linaro.org>
Date: Tue, 19 Mar 2013 10:30:17 +0530
Message-ID: <CAKohpon8byMTbJ4uFxBAX9Fsch_KgUaOrzx_JCzddtJrNrrUhg@mail.gmail.com>
Subject: Re: [PATCH V3 0/7] Create sched_select_cpu() and use it for workqueues
From: Viresh Kumar <viresh.kumar@linaro.org>
To: pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        tj@kernel.org, suresh.b.siddha@intel.com, venki@google.com,
        mingo@redhat.com, peterz@infradead.org, rostedt@goodmis.org
Cc: linaro-kernel@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, Arvind.Chauhan@arm.com,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 March 2013 20:53, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> In order to save power, it would be useful to schedule light weight work on cpus
> that aren't IDLE instead of waking up an IDLE one.
>
> By idle cpu (from scheduler's perspective) we mean:
> - Current task is idle task
> - nr_running == 0
> - wake_list is empty

Oops!! I forgot the change log:

V2->V3:
- Dropped changes into core queue_work() API, rather create *_on_any_cpu()
  APIs
- Dropped running timers migration patch as that was broken
- Migrated few users of workqueues to use *_on_any_cpu() APIs.
