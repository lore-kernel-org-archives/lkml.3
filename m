Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525Ab3EQRjF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 13:39:05 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:45152 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756478Ab3EQRjD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 13:39:03 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20130517165712.GB12632@mtj.dyndns.org>
References: <1368431172-6844-1-git-send-email-mhocko@suse.cz> <1368431172-6844-2-git-send-email-mhocko@suse.cz> <20130517160247.GA10023@cmpxchg.org> <20130517165712.GB12632@mtj.dyndns.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [patch v3 -mm 1/3] memcg: integrate soft reclaim tighter with zone shrinking code
From: Johannes Weiner <hannes@cmpxchg.org>
Date: Fri, 17 May 2013 13:27:09 -0400
To: Tejun Heo <tj@kernel.org>
CC: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ying Han <yinghan@google.com>, Hugh Dickins <hughd@google.com>,
        Glauber Costa <glommer@parallels.com>,
        Michel Lespinasse <walken@google.com>,
        Greg Thelen <gthelen@google.com>, Balbir Singh <bsingharora@gmail.com>
Message-ID: <b4e0e499-b922-4e9c-a0f8-02318ddf3b9b@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Tejun Heo <tj@kernel.org> wrote:

>Hello, Johannes.
>
>On Fri, May 17, 2013 at 12:02:47PM -0400, Johannes Weiner wrote:
>> There are setups with thousands of groups that do not even use soft
>> limits.  Having them pointlessly iterate over all of them for every
>> couple of pages reclaimed is just not acceptable.
>
>Hmmm... if the iteration is the problem, it shouldn't be difficult to
>build list of children which should be iterated.  Would that make it
>acceptable?

You mean, a separate structure that tracks which groups are in excess of the limit?  Like the current tree? :)

Kidding aside, yes, that would be better, and an unsorted list would probably be enough for the global case.

To support target reclaim soft limits later on, we could maybe propagate tags upwards the cgroup tree when a group is in excess so that reclaim can be smarter about which subtrees to test for soft limits and which to skip during the soft limit pass.  The no-softlimit-set-anywhere case is then only a single tag test in the root cgroup.

But starting with the list would be simple enough, delete a bunch of code, come with the same performance improvements etc.
-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
