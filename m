Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642Ab3LLQc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 11:32:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49128 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab3LLQcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 11:32:25 -0500
Date: Thu, 12 Dec 2013 17:32:22 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: Tim Hockin <thockin@hockin.org>, David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Li Zefan <lizefan@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [patch 7/8] mm, memcg: allow processes handling oom
 notifications to access reserves
Message-ID: <20131212163222.GK2630@dhcp22.suse.cz>
References: <alpine.DEB.2.02.1312041742560.20115@chino.kir.corp.google.com>
 <20131205025026.GA26777@htj.dyndns.org>
 <alpine.DEB.2.02.1312051537550.7717@chino.kir.corp.google.com>
 <20131206190105.GE13373@htj.dyndns.org>
 <alpine.DEB.2.02.1312061441390.8949@chino.kir.corp.google.com>
 <20131210215037.GB9143@htj.dyndns.org>
 <alpine.DEB.2.02.1312101522400.22701@chino.kir.corp.google.com>
 <20131211124240.GA24557@htj.dyndns.org>
 <CAAAKZwsmM-C=kLGV=RW=Y4Mq=BWpQzuPruW6zvEr9p0Xs4GD5g@mail.gmail.com>
 <20131212142156.GB32683@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131212142156.GB32683@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 12-12-13 09:21:56, Tejun Heo wrote:
[...]
> There'd still be all the bells and whistles to configure and monitor
> system-level OOM and if there's justified need for improvements, we
> surely can and should do that;

You weren't on the CC of the original thread which has started here
https://lkml.org/lkml/2013/11/19/191. And the original request for
discussion was more about user defined _policies_ for the global
OOM rather than user space global OOM handler. I feel that there
are usacases where the current "kill a single task based on some
calculations" is far from optimal which leads to hacks which try to cope
with after oom condition somehow gracefully.

I do agree with you that pulling oom handling sounds too dangerous
even with all the code that it would need and I feel we should go a
different path than (ab)using memcg.oom_control interface for that.
I still think we need to have a way to tell the global OOM killer what
to do.

[...]
-- 
Michal Hocko
SUSE Labs
