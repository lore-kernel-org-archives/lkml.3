Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab3LEXxl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 18:53:41 -0500
Received: from mail-yh0-f45.google.com ([209.85.213.45]:48287 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab3LEXxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 18:53:39 -0500
Date: Thu, 5 Dec 2013 15:53:35 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@kernel.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org
Subject: Re: [patch 3/8] mm, mempolicy: remove per-process flag
In-Reply-To: <00000142c426b81a-45e6815b-bde4-483c-975e-ce1eea42a753-000000@email.amazonses.com>
Message-ID: <alpine.DEB.2.02.1312051550390.7717@chino.kir.corp.google.com>
References: <20131119131400.GC20655@dhcp22.suse.cz> <20131119134007.GD20655@dhcp22.suse.cz> <alpine.DEB.2.02.1311192352070.20752@chino.kir.corp.google.com> <20131120152251.GA18809@dhcp22.suse.cz> <alpine.DEB.2.02.1311201917520.7167@chino.kir.corp.google.com>
 <20131128115458.GK2761@dhcp22.suse.cz> <alpine.DEB.2.02.1312021504170.13465@chino.kir.corp.google.com> <alpine.DEB.2.02.1312032116440.29733@chino.kir.corp.google.com> <alpine.DEB.2.02.1312032117490.29733@chino.kir.corp.google.com>
 <00000142be3633ba-2a459537-58fb-444b-a99f-33ff5e5b2aed-000000@email.amazonses.com> <alpine.DEB.2.02.1312041651080.13608@chino.kir.corp.google.com> <00000142c426b81a-45e6815b-bde4-483c-975e-ce1eea42a753-000000@email.amazonses.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Dec 2013, Christoph Lameter wrote:

> Specjbb? What does Java have to do with this?
> Can you run the synthetic in kernel slab benchmark.
> 
> Like this one https://lkml.org/lkml/2009/10/13/459
> 

We actually carry that in our production kernel and have updated it to 
build on 3.11, I'll run it and netperf TCP_RR as well, thanks.

> However, SLAB is still the allocator in use for RHEL which puts some
> importance on still supporting SLAB.
> 

Google also uses it exclusively so I'm definitely not saying that since 
it's not default that we can ignore it.  I haven't seen any performance 
regression in removing it, but I'll post the numbers on the slab benchmark 
and netperf TCP_RR when I have them.
