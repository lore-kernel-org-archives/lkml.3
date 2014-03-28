Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbaC1H6I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 03:58:08 -0400
Received: from relay.parallels.com ([195.214.232.42]:40840 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbaC1H6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 03:58:07 -0400
Message-ID: <53352B8D.3040402@parallels.com>
Date: Fri, 28 Mar 2014 11:58:05 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Greg Thelen <gthelen@google.com>, <akpm@linux-foundation.org>,
        <hannes@cmpxchg.org>, <glommer@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <devel@openvz.org>, Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH -mm 1/4] sl[au]b: do not charge large allocations to memcg
References: <cover.1395846845.git.vdavydov@parallels.com> <5a5b09d4cb9a15fc120b4bec8be168630a3b43c2.1395846845.git.vdavydov@parallels.com> <xr93fvm42rew.fsf@gthelen.mtv.corp.google.com> <5333D527.2060208@parallels.com> <20140327204320.GC28590@dhcp22.suse.cz>
In-Reply-To: <20140327204320.GC28590@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2014 12:43 AM, Michal Hocko wrote:
> On Thu 27-03-14 11:37:11, Vladimir Davydov wrote:
> [...]
>> In fact, do we actually need to charge every random kmem allocation? I
>> guess not. For instance, filesystems often allocate data shared among
>> all the FS users. It's wrong to charge such allocations to a particular
>> memcg, IMO. That said the next step is going to be adding a per kmem
>> cache flag specifying if allocations from this cache should be charged
>> so that accounting will work only for those caches that are marked so
>> explicitly.
> 
> How do you select which caches to track?

I though we should pick some objects that are definitely used by most
processes, e.g. mm_struct, task_struct, inodes, dentries, as a first
step, and then add some new objects to the set upon requests.

Now, after Greg's explanation, I admit the idea is rather unjustified,
because charging all objects by default and providing a way to
explicitly exclude some caches from accounting requires much less
efforts and changes to the code.

Thanks.
