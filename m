Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431AbaGKIlA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 04:41:00 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:25152 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752200AbaGKIkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 04:40:55 -0400
X-IronPort-AV: E=Sophos;i="5.00,873,1396972800"; 
   d="scan'208";a="33145459"
Message-ID: <53BFA34F.9010800@cn.fujitsu.com>
Date: Fri, 11 Jul 2014 16:41:51 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Kevin Hilman <khilman@linaro.org>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [RFC PATCH 0/5] workqueue: Introduce low-level unbound wq sysfs
 cpumask v3
References: <1400257015-28222-1-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1400257015-28222-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Frederic

I'd like to take this work unless you are still working on it.
I would do some cleanup at first so that it will be much slow for me.

Thanks,
Lai


On 05/17/2014 12:16 AM, Frederic Weisbecker wrote:
> So in this version I actually save the cpumask belonging to wq (before
> it's intersected against the low level cpumask) in its unbounds attrs.
> 
> But the attrs passed to pwq and worker pools have the low level cpumask
> computed against the wq cpumask.
> 
> It makes it easier that way as the wq cpumask itself remains untouched.
> It's a user setting so it must stay intact. OTOH the cpumask of pwqs and
> worker pools only belong to the implementation so it's the right
> place to store the effective cpumask.
> 
> Also wq_update_unbound_numa() is fixed, and cpu_possible_mask() 
> is restored as a base. Thanks to Lai!
> 
> Thanks,
> 	Frederic
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
>         core/workqueue-v5
> ---
> 
> Frederic Weisbecker (4):
>       workqueue: Reorder sysfs code
>       workqueue: Create low-level unbound workqueues cpumask
>       workqueue: Split apply attrs code from its locking
>       workqueue: Allow modifying low level unbound workqueue cpumask
> 
> Lai Jiangshan (1):
>       workqueue: Allow changing attributions of ordered workqueues
> 
> 
>  kernel/workqueue.c | 1674 ++++++++++++++++++++++++++++------------------------
>  1 file changed, 900 insertions(+), 774 deletions(-)
> .
> 

