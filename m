Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab3FNK4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 06:56:20 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:33423 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab3FNK4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 06:56:18 -0400
Date: Fri, 14 Jun 2013 14:56:13 +0400
From: Glauber Costa <glommer@gmail.com>
To: Li Zefan <lizefan@huawei.com>
Cc: Michal Hocko <mhocko@suse.cz>, Tejun Heo <tj@kernel.org>,
        Glauber Costa <glommer@openvz.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>,
        linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH v3 5/9] memcg: use css_get/put when charging/uncharging
 kmem
Message-ID: <20130614105611.GA4292@localhost.localdomain>
References: <51B98D17.2050902@huawei.com>
 <20130613155319.GJ23070@dhcp22.suse.cz>
 <51BA6F34.30001@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51BA6F34.30001@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 09:17:40AM +0800, Li Zefan wrote:
> >>  static void memcg_kmem_mark_dead(struct mem_cgroup *memcg)
> >>  {
> >> +	/*
> >> +	 * We need to call css_get() first, because memcg_uncharge_kmem()
> >> +	 * will call css_put() if it sees the memcg is dead.
> >> +	 */
> >> +	smb_wmb();
> >>  	if (test_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_account_flags))
> >>  		set_bit(KMEM_ACCOUNTED_DEAD, &memcg->kmem_account_flags);
> > 
> > I do not feel strongly about that but maybe open coding this in
> > mem_cgroup_css_offline would be even better. There is only single caller
> > and there is smaller chance somebody will use the function incorrectly
> > later on.
> > 
> > So I leave the decision on you because this doesn't matter much.
> > 
> 
> Yeah, it should go away soon. I'll post a patch after this patchset gets
> merged into -mm tree and then we can discuss there.
 
I don't care if it is open coded or not. If there is any strong preference
from anyone on this matter, feel free to change it.
