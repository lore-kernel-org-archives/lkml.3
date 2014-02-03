Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837AbaBCGVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 01:21:33 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:43846 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbaBCGVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 01:21:30 -0500
Date: Sun, 2 Feb 2014 22:21:28 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vladimir Davydov <vdavydov@parallels.com>
cc: akpm@linux-foundation.org, mhocko@suse.cz, penberg@kernel.org,
        cl@linux.com, glommer@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH 1/8] memcg: export kmemcg cache id via cgroup fs
In-Reply-To: <570a97e4dfaded0939a9ddbea49055019dcc5803.1391356789.git.vdavydov@parallels.com>
Message-ID: <alpine.DEB.2.02.1402022219101.10847@chino.kir.corp.google.com>
References: <cover.1391356789.git.vdavydov@parallels.com> <570a97e4dfaded0939a9ddbea49055019dcc5803.1391356789.git.vdavydov@parallels.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Feb 2014, Vladimir Davydov wrote:

> Per-memcg kmem caches are named as follows:
> 
>   <global-cache-name>(<cgroup-kmem-id>:<cgroup-name>)
> 
> where <cgroup-kmem-id> is the unique id of the memcg the cache belongs
> to, <cgroup-name> is the relative name of the memcg on the cgroup fs.
> Cache names are exposed to userspace for debugging purposes (e.g. via
> sysfs in case of slub or via dmesg).
> 
> Using relative names makes it impossible in general (in case the cgroup
> hierarchy is not flat) to find out which memcg a particular cache
> belongs to, because <cgroup-kmem-id> is not known to the user. Since
> using absolute cgroup names would be an overkill, let's fix this by
> exporting the id of kmem-active memcg via cgroup fs file
> "memory.kmem.id".
> 

Hmm, I'm not sure exporting additional information is the best way to do 
it only for this purpose.  I do understand the problem in naming 
collisions if the hierarchy isn't flat and we typically work around that 
by ensuring child memcgs still have a unique memcg.  This isn't only a 
problem in slab cache naming, me also avoid printing the entire absolute 
names for things like the oom killer.  So it would be nice to have 
consensus on how people are supposed to identify memcgs with a hierarchy: 
either by exporting information like the id like you do here (but leave 
the oom killer still problematic) or by insisting people name their memcgs 
with unique names if they care to differentiate them.
