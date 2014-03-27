Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014AbaC0Ctj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 22:49:39 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:54584 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbaC0Cti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 22:49:38 -0400
Message-ID: <53339153.70708@huawei.com>
Date: Thu, 27 Mar 2014 10:47:47 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: <tglx@linutronix.de>, <fweisbec@gmail.com>, <peterz@infradead.org>,
        <mingo@kernel.org>, <tj@kernel.org>, <linaro-kernel@lists.linaro.org>,
        <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>
Subject: Re: [RFC 4/4] cpuset: Add cpusets.quiesce option
References: <cover.1395322529.git.viresh.kumar@linaro.org> <e643acf71086db239254d44c77d4966b2a4a01e5.1395322529.git.viresh.kumar@linaro.org>
In-Reply-To: <e643acf71086db239254d44c77d4966b2a4a01e5.1395322529.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/3/20 21:49, Viresh Kumar wrote:
> For networking applications platforms need to provide one CPU per each user
> space data plane thread. These CPUs should not be interrupted by kernel at all
> unless userspace has requested for some syscalls. Currently, there are
> background kernel activities that are running on almost every CPU, like:
> timers/hrtimers/watchdogs/etc, and these are required to be migrated to other
> CPUs.
> 
> To achieve that, this patch adds another option to cpusets, i.e. 'quiesce'.
> Writing '1' on this file would migrate these unbound/unpinned timers/workqueues
> away from the CPUs of the cpuset in question. Writing '0' has no effect and this
> file can't be read from userspace as we aren't maintaining a state here.
> 

This doesn't look like a complete solution, because newer timers/workqueues can
still run in those CPUs. Seems like the proposal discussed is to support setting
cpu affinity for workqueues through sysfs. If so, we can migrate workqueues when
affinity is set, so we don't need this cpuset.quiesce ?

> Currently, only timers are migrated. This would be followed by other kernel
> infrastructure later.
> 
> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

