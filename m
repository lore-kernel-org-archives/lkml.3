Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645AbaEEVgu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 17:36:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51297 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936AbaEEVgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 17:36:48 -0400
Date: Mon, 5 May 2014 14:36:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>, Jianyu Zhan <nasa4836@gmail.com>,
        bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.com
Subject: Re: [PATCH 2/2] mm/memcontrol.c: introduce helper
 mem_cgroup_zoneinfo_zone()
Message-Id: <20140505143646.c0591119522b869b79d9c77b@linux-foundation.org>
In-Reply-To: <20140502232908.GQ23420@cmpxchg.org>
References: <1397862103-31982-1-git-send-email-nasa4836@gmail.com>
	<20140422095923.GD29311@dhcp22.suse.cz>
	<20140428150426.GB24807@dhcp22.suse.cz>
	<20140501125450.GA23420@cmpxchg.org>
	<20140502150516.d42792bad53d86fb727816bd@linux-foundation.org>
	<20140502232908.GQ23420@cmpxchg.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2014 19:29:08 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:

> Memcg zoneinfo lookup sites have either the page, the zone, or the
> node id and zone index, but sites that only have the zone have to look
> up the node id and zone index themselves, whereas sites that already
> have those two integers use a function for a simple pointer chase.
> 
> Provide mem_cgroup_zone_zoneinfo() that takes a zone pointer and let
> sites that already have node id and zone index - all for each node,
> for each zone iterators - use &memcg->nodeinfo[nid]->zoneinfo[zid].
> 
> Rename page_cgroup_zoneinfo() to mem_cgroup_page_zoneinfo() to match.

Patch shrinks my mm/memcontrol.o nicely:

   text    data     bss     dec     hex filename
  55702   15681   24560   95943   176c7 mm/memcontrol.o-before
  55489   15681   24464   95634   17592 mm/memcontrol.o-after

The bss size changes are weird - the patch doesn't touch bss afaict. 
This often happens.  One day I'll get in there and work out why.

