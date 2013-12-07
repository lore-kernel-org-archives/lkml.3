Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945Ab3LGTHZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 14:07:25 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:45124 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755694Ab3LGTHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 14:07:23 -0500
Date: Sat, 7 Dec 2013 14:06:53 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Tim Hockin <thockin@hockin.org>
Cc: Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Christoph Lameter <cl@linux-foundation.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 7/8] mm, memcg: allow processes handling oom
 notifications to access reserves
Message-ID: <20131207190653.GI21724@cmpxchg.org>
References: <alpine.DEB.2.02.1312032116440.29733@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1312032118570.29733@chino.kir.corp.google.com>
 <20131204054533.GZ3556@cmpxchg.org>
 <alpine.DEB.2.02.1312041742560.20115@chino.kir.corp.google.com>
 <20131205025026.GA26777@htj.dyndns.org>
 <alpine.DEB.2.02.1312051537550.7717@chino.kir.corp.google.com>
 <20131206173438.GE21724@cmpxchg.org>
 <CAAAKZwsh3erB7PyG6FnvJRgrZhf2hDQCZDx3rMM7NdOdYNCzJw@mail.gmail.com>
 <20131207174039.GH21724@cmpxchg.org>
 <CAAAKZwvanMiz8QZVOU0-SUKYzqcaJAXn0HxYs5+=Zakmnbcfbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAAKZwvanMiz8QZVOU0-SUKYzqcaJAXn0HxYs5+=Zakmnbcfbg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 07, 2013 at 10:12:19AM -0800, Tim Hockin wrote:
> You more or less described the fundamental change - a score per memcg, with
> a recursive OOM killer which evaluates scores between siblings at the same
> level.
> 
> It gets a bit complicated because we have need if wider scoring ranges than
> are provided by default

If so, I'm sure you can make a convincing case to widen the internal
per-task score ranges.  The per-memcg score ranges have not even be
defined, so this is even easier.

> and because we score PIDs against mcgs at a given scope.

You are describing bits of a solution, not a problem.  And I can't
possibly infer a problem from this.

> We also have some tiebreaker heuristic (age).

Either periodically update the per-memcg score from userspace or
implement this in the kernel.  We have considered CPU usage
history/runtime etc. in the past when picking an OOM victim task.

But I'm again just speculating what your problem is, so this may or
may not be a feasible solution.

> We also have a handful of features that depend on OOM handling like the
> aforementioned automatically growing and changing the actual OOM score
> depending on usage in relation to various thresholds ( e.g. we sold you X,
> and we allow you to go over X but if you do, your likelihood of death in
> case of system OOM goes up.

You can trivially monitor threshold events from userspace with the
existing infrastructure and accordingly update the per-memcg score.

> Do you really want us to teach the kernel policies like this?  It would be
> way easier to do and test in userspace.

Maybe.  Providing fragments of your solution is not an efficient way
to communicate the problem.  And you have to sell the problem before
anybody can be expected to even consider your proposal as one of the
possible solutions.
