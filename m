Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538Ab3EQRp5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 13:45:57 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:53663 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756480Ab3EQRpz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 13:45:55 -0400
MIME-Version: 1.0
In-Reply-To: <b4e0e499-b922-4e9c-a0f8-02318ddf3b9b@email.android.com>
References: <1368431172-6844-1-git-send-email-mhocko@suse.cz>
	<1368431172-6844-2-git-send-email-mhocko@suse.cz>
	<20130517160247.GA10023@cmpxchg.org>
	<20130517165712.GB12632@mtj.dyndns.org>
	<b4e0e499-b922-4e9c-a0f8-02318ddf3b9b@email.android.com>
Date: Fri, 17 May 2013 10:45:54 -0700
X-Google-Sender-Auth: r33Xvo1uaGbbrnR9aWWOWt8RIXU
Message-ID: <CAOS58YP6qXM_mXvsCtGSViOZTw=mwnfUS7cZGAES8F4w5mCQdA@mail.gmail.com>
Subject: Re: [patch v3 -mm 1/3] memcg: integrate soft reclaim tighter with
 zone shrinking code
From: Tejun Heo <tj@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Cgroups <cgroups@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ying Han <yinghan@google.com>, Hugh Dickins <hughd@google.com>,
        Glauber Costa <glommer@parallels.com>,
        Michel Lespinasse <walken@google.com>,
        Greg Thelen <gthelen@google.com>, Balbir Singh <bsingharora@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, May 17, 2013 at 10:27 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
>>Hmmm... if the iteration is the problem, it shouldn't be difficult to
>>build list of children which should be iterated.  Would that make it
>>acceptable?
>
> You mean, a separate structure that tracks which groups are in excess of the limit?  Like the current tree? :)

Heh, yeah, realized that after writing it but it can be something much
simpler. ie. just linked list of children with soft limit configured.

> Kidding aside, yes, that would be better, and an unsorted list would probably be enough for the global case.

Yeap.

> To support target reclaim soft limits later on, we could maybe propagate tags upwards the cgroup tree when a group is in excess so that reclaim can be smarter about which subtrees to test for soft limits and which to skip during the soft limit pass.  The no-softlimit-set-anywhere case is then only a single tag test in the root cgroup.
>
> But starting with the list would be simple enough, delete a bunch of code, come with the same performance improvements etc.

Thanks.

--
tejun
