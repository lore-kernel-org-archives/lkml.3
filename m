Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443AbaAUWWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 17:22:30 -0500
Received: from mail-gg0-f176.google.com ([209.85.161.176]:46671 "EHLO
	mail-gg0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274AbaAUWWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 17:22:25 -0500
Date: Tue, 21 Jan 2014 14:22:21 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vladimir Davydov <vdavydov@parallels.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, devel@openvz.org, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@redhat.com>, Dave Chinner <dchinner@redhat.com>,
        Glauber Costa <glommer@gmail.com>
Subject: Re: [PATCH 1/3] mm: vmscan: shrink_slab: rename max_pass ->
 freeable
In-Reply-To: <4e2efebe688e06574f6495c634ac45d799e1518d.1389982079.git.vdavydov@parallels.com>
Message-ID: <alpine.DEB.2.02.1401211420460.1666@chino.kir.corp.google.com>
References: <4e2efebe688e06574f6495c634ac45d799e1518d.1389982079.git.vdavydov@parallels.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531381512-1552005430-1390342917=:1666"
Content-ID: <alpine.DEB.2.02.1401211422020.1666@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531381512-1552005430-1390342917=:1666
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.02.1401211422021.1666@chino.kir.corp.google.com>

On Fri, 17 Jan 2014, Vladimir Davydov wrote:

> The name `max_pass' is misleading, because this variable actually keeps
> the estimate number of freeable objects, not the maximal number of
> objects we can scan in this pass, which can be twice that. Rename it to
> reflect its actual meaning.
> 
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Dave Chinner <dchinner@redhat.com>
> Cc: Glauber Costa <glommer@gmail.com>

This doesn't compile on linux-next:

mm/vmscan.c: In function ‘shrink_slab_node’:
mm/vmscan.c:300:23: error: ‘max_pass’ undeclared (first use in this function)
mm/vmscan.c:300:23: note: each undeclared identifier is reported only once for each function it appears in

because of b01fa2357bca ("mm: vmscan: shrink all slab objects if tight on 
memory") from an author with a name remarkably similar to yours.  Could 
you rebase this series on top of your previous work that is already in 
-mm?
--531381512-1552005430-1390342917=:1666--
