Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179AbaC0E3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 00:29:25 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:42534 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbaC0E3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 00:29:22 -0400
MIME-Version: 1.0
In-Reply-To: <53339153.70708@huawei.com>
References: <cover.1395322529.git.viresh.kumar@linaro.org>
	<e643acf71086db239254d44c77d4966b2a4a01e5.1395322529.git.viresh.kumar@linaro.org>
	<53339153.70708@huawei.com>
Date: Thu, 27 Mar 2014 09:59:21 +0530
Message-ID: <CAKohpom-OAcvhQqVv9Vy9aMHFEZNaO=sGrF=C=OFYuDv2RgQJQ@mail.gmail.com>
Subject: Re: [RFC 4/4] cpuset: Add cpusets.quiesce option
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Tejun Heo <tj@kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 March 2014 08:17, Li Zefan <lizefan@huawei.com> wrote:
> This doesn't look like a complete solution, because newer timers/workqueues can
> still run in those CPUs.

The initial idea was to disable load balance between CPUs and then do this.
So, that new timers and workqueues from other CPUs would never get
queued on this CPU..

But I think we can just modify get_nohz_timer_target() for making sure this
for timers..

> Seems like the proposal discussed is to support setting
> cpu affinity for workqueues through sysfs. If so, we can migrate workqueues when
> affinity is set, so we don't need this cpuset.quiesce ?

That was another thread just for workqueues, but this one is about migrating
everything else as well.. Probably some more additions apart from timers/
hrtimers/wqs in future. So, for us it is still required :)
