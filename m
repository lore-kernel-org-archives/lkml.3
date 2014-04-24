Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758582AbaDXP5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 11:57:35 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:57277 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758268AbaDXP52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 11:57:28 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: peterz@infradead.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, alex.shi@linaro.org,
        vincent.guittot@linaro.org, morten.rasmussen@arm.com,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 0/3] sched: idle: Provide the basis to integrate cpuidle
Date: Thu, 24 Apr 2014 18:13:49 +0200
Message-ID: <1507372.PrIsjf4qYL@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1398342291-16322-1-git-send-email-daniel.lezcano@linaro.org>
References: <1398342291-16322-1-git-send-email-daniel.lezcano@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 24, 2014 02:24:48 PM Daniel Lezcano wrote:
> This patchset provides three patches for the basis to integrate cpuidle with
> the scheduler.
> 
> The first patch is a cleanup.
> The second one adds the sched balance option as requested by Ingo.
> The third one stores the idle state a cpu is and adds a rcu_barrier() to
>  prevent races when using the pointed object.
> 
> This patchset is based on top of v3.15-rc2.
> 
> This patchset does not modify the behavior of the scheduler.
> 
> Taking into account the cpuidle information from the scheduler will be
> posted in a separate patchset in order to keep focused on the right decisions
> the scheduler should take regarding the policy vs idle parameters.
> 
> Daniel Lezcano (3):
>   sched: idle: Encapsulate the code to compile it out
>   sched: idle: Add sched balance option
>   sched: idle: Store the idle state the cpu is

Please rebase patch [1/3] on top of https://patchwork.kernel.org/patch/4021831/

I agree with the Amit's comment regarding the power supply assumption in
patch [2/3].

>  drivers/cpuidle/cpuidle.c    |    6 ++
>  include/linux/sched/sysctl.h |   14 ++++
>  kernel/sched/fair.c          |   92 ++++++++++++++++++++++-
>  kernel/sched/idle.c          |  169 +++++++++++++++++++++++-------------------
>  kernel/sched/sched.h         |    5 ++
>  kernel/sysctl.c              |   11 +++
>  6 files changed, 220 insertions(+), 77 deletions(-)
> 
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
