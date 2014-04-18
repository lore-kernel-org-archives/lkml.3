Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897AbaDRK63 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 06:58:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59182 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaDRK61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 06:58:27 -0400
Date: Fri, 18 Apr 2014 12:58:01 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, tony.luck@intel.com,
        fenghua.yu@intel.com, schwidefsky@de.ibm.com, cmetcalf@tilera.com,
        benh@kernel.crashing.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, dietmar.eggemann@arm.com,
        preeti@linux.vnet.ibm.com, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v4 4/5] sched: add a new SD_SHARE_POWERDOMAIN for
 sched_domain
Message-ID: <20140418105801.GV11182@twins.programming.kicks-ass.net>
References: <1397209481-28542-1-git-send-email-vincent.guittot@linaro.org>
 <1397209481-28542-5-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397209481-28542-5-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 11:44:40AM +0200, Vincent Guittot wrote:
> A new flag SD_SHARE_POWERDOMAIN is created to reflect whether groups of CPUs
> in a sched_domain level can or not reach different power state. As an example,
> the flag should be cleared at CPU level if groups of cores can be power gated
> independently. This information can be used in the load balance decision or to
> add load balancing level between group of CPUs that can power gate
> independantly.
> This flag is part of the topology flags that can be set by arch.
> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> ---

Building a cris-defconfig this gets me an endless stream of misery:

In file included from /usr/src/linux-2.6/init/do_mounts.c:12:0:
/usr/src/linux-2.6/include/linux/sched.h:1048:46: warning: 'struct sched_domain_topology_level' declared inside parameter list [enabled by default]
/usr/src/linux-2.6/include/linux/sched.h:1048:46: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
In file included from /usr/src/linux-2.6/include/linux/utsname.h:5:0,
                 from /usr/src/linux-2.6/include/linux/init_task.h:6,
                 from /usr/src/linux-2.6/init/init_task.c:1:

Might be something about UP builds, didn't check x86-UP.
