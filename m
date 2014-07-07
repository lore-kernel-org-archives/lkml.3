Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858AbaGGROX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 13:14:23 -0400
Received: from relay.parallels.com ([195.214.232.42]:53277 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaGGROW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 13:14:22 -0400
Message-ID: <53BAD567.8060506@parallels.com>
Date: Mon, 7 Jul 2014 21:14:15 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: <akpm@linux-foundation.org>, <mhocko@suse.cz>, <cl@linux.com>,
        <glommer@gmail.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm 0/8] memcg: reparent kmem on css offline
References: <cover.1404733720.git.vdavydov@parallels.com> <20140707142506.GB1149@cmpxchg.org>
In-Reply-To: <20140707142506.GB1149@cmpxchg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.5.110.170]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

07.07.2014 18:25, Johannes Weiner:
> In addition, Tejun made offlined css iterable and split css_tryget()
> and css_tryget_online(), which would allow memcg to pin the css until
> the last charge is gone while continuing to iterate and reclaim it on
> hierarchical pressure, even after it was offlined.

One more question.

With reparenting enabled, the number of cgroups (lruvecs) that must be
iterated on global reclaim is bound by the number of live containers,
while w/o reparenting it's practically unbound, isn't it? Won't it be
the source of latency spikes?

Thanks.
