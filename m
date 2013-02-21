Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab3BULWz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 06:22:55 -0500
Received: from mx0.parallels.com ([199.115.104.20]:50796 "EHLO
	mx0.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974Ab3BULWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 06:22:54 -0500
Message-ID: <51260390.8010203@parallels.com>
Date: Thu, 21 Feb 2013 15:22:56 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Steffen Michalke <StMichalke@web.de>, <linux-kernel@vger.kernel.org>,
        "Li Zefan" <lizefan@huawei.com>,
        <containers@lists.linux-foundation.org>,
        "Johannes Weiner" <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: PROBLEM: Crash cgdeleting empty memory cgroups with memory.kmem.limit_in_bytes
 set
References: <1361375371.7786.5.camel@michalke-online.eu> <20130220230019.GJ3570@htj.dyndns.org>
In-Reply-To: <20130220230019.GJ3570@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2013 03:00 AM, Tejun Heo wrote:
> (cc'ing cgroup / memcg people and quoting whole body)
> 
> Looks like something is going wrong with memcg cache destruction.
> Glauber, any ideas?  Also, can we please not use names as generic as
> kmem_cache_destroy_work_func for something specific to memcg?  How
> about something like memcg_destroy_cache_workfn?
> 
> Thanks.

Steffen,

Is there any chance you could test that using SLAB instead of SLUB?
I haven't manage to reproduce it yet, but I am working on some theories
about why this is happening. If I could at least know if this is likely
a cache problem vs a inner-memcg problem, that would help. The calltrace
is not incredibly helpful, but it does indicate that the problem happens
when freeing cache objects.



