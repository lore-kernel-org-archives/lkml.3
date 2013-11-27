Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907Ab3K0VjH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 16:39:07 -0500
Received: from mail-yh0-f49.google.com ([209.85.213.49]:62052 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622Ab3K0VjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 16:39:03 -0500
Date: Wed, 27 Nov 2013 13:38:59 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: memcg: do not declare OOM from __GFP_NOFAIL
 allocations
In-Reply-To: <20131127163916.GB3556@cmpxchg.org>
Message-ID: <alpine.DEB.2.02.1311271336220.9222@chino.kir.corp.google.com>
References: <1385140676-5677-1-git-send-email-hannes@cmpxchg.org> <alpine.DEB.2.02.1311261658170.21003@chino.kir.corp.google.com> <alpine.DEB.2.02.1311261931210.5973@chino.kir.corp.google.com> <20131127163916.GB3556@cmpxchg.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Nov 2013, Johannes Weiner wrote:

> > Ah, this is because of 3168ecbe1c04 ("mm: memcg: use proper memcg in limit 
> > bypass") which just bypasses all of these allocations and charges the root 
> > memcg.  So if allocations want to bypass memcg isolation they just have to 
> > be __GFP_NOFAIL?
> 
> I don't think we have another option.
> 

We don't give __GFP_NOFAIL allocations access to memory reserves in the 
page allocator and we do call the oom killer for them so that a process is 
killed so that memory is freed.  Why do we have a different policy for 
memcg?
