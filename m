Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbaDFIae (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 04:30:34 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:61098 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629AbaDFIaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 04:30:25 -0400
Message-ID: <1396773020.11763.17.camel@marge.simpson.net>
Subject: Re: [PATCH V2 0/8] cpusets: Isolate CPUs via sysfs using cpusets
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: tglx@linutronix.de, fweisbec@gmail.com, peterz@infradead.org,
        mingo@kernel.org, tj@kernel.org, lizefan@huawei.com,
        linaro-kernel@lists.linaro.org, linaro-networking@linaro.org,
        Arvind.Chauhan@arm.com, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org
Date: Sun, 06 Apr 2014 10:30:20 +0200
In-Reply-To: <cover.1396599474.git.viresh.kumar@linaro.org>
References: <cover.1396599474.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-04 at 14:05 +0530, Viresh Kumar wrote: 
> We need to migrate away all the background kernel activities (Unbound) for
> systems requiring isolation of cores (HPC, Real time, networking, etc). After
> creating cpusets, you can write 1 or 0 to cpuset.quiesce file.

I wonder if adding a quiesce switch is really necessary.

Seems to me that if you don't have load balancing turned off, you can't
be very concerned about perturbation, so this should be tied into the
load balancing on/off switch as an extension to isolating cores from the
#1 perturbation source, the scheduler.

I also didn't notice a check for is_cpu_exclusive() at a glance, which
would be a bug, but one that would go away if this additional isolation
were coupled to the existing isolation switch.

-Mike

