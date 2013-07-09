Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab3GIPGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 11:06:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37455 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754172Ab3GIPGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 11:06:14 -0400
Date: Tue, 9 Jul 2013 11:06:05 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Tejun Heo <tj@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Sha Zhengju <handai.szj@gmail.com>, devel@openvz.org,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH RFC] fsio: filesystem io accounting cgroup
Message-ID: <20130709150605.GC2237@redhat.com>
References: <20130708175201.GB9094@redhat.com>
 <20130708175607.GB18600@mtj.dyndns.org>
 <51DBC99F.4030301@openvz.org>
 <20130709125734.GA2478@htj.dyndns.org>
 <51DC0CE2.2050906@openvz.org>
 <20130709131605.GB2478@htj.dyndns.org>
 <20130709131646.GC2478@htj.dyndns.org>
 <51DC136E.6020901@openvz.org>
 <20130709134558.GD2478@htj.dyndns.org>
 <51DC1FCA.3060904@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51DC1FCA.3060904@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 09, 2013 at 06:35:54PM +0400, Konstantin Khlebnikov wrote:

[..]
> I'm not interested in QoS or proportional control. Let schedulers do it.
> I want just bandwidth control. I don't want to write a new scheduler
> or extend some of existing one. I want implement simple and lightweight
> accounting and add couple of throttlers on top of that.
> It can be easily done without violation of that hierarchical design.
> 
> The same problem already has happened with cpu scheduler. It has really
> complicated rate limiter which is actually useless in the real world because
> it triggers all possible priority inversions since it puts bunch of tasks into
> deep sleep while some of them may hold kernel locks. Perfect.
> 
> QoS and scheduling policy are good thing, but rate-limiting must be separated
> and done only in places where it doesn't leads to these problems.

So what kind of priority inversion you are facing with blkcg and how would
you avoid it with your implementation?

I know that serialization can happen at filesystem level while trying
to commit journal. But I think same thing will happen with your
implementation too. 

One simple way of avoiding that will be to throttle IO even earlier
but that means we do not take advantage of writeback cache and buffered
writes will slow down. 

So I am curious how would you take care of these serialization issue.

Also the throttlers you are planning to implement, what kind of throttling
do they provide. Is it throttling rate per cgroup or per file per cgroup
or rules will be per bdi per cgroup or something else.

Thanks
Vivek
