Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113AbaEVCtO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 22:49:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56210 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbaEVCtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 22:49:13 -0400
Date: Wed, 21 May 2014 19:49:11 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vlastimil Babka <vbabka@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Greg Thelen <gthelen@google.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch -mm] mm, thp: avoid excessive compaction latency during
 fault fix
In-Reply-To: <5371ED3F.6070505@suse.cz>
Message-ID: <alpine.DEB.2.02.1405211945140.13243@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1404301744110.8415@chino.kir.corp.google.com> <alpine.DEB.2.02.1405011434140.23898@chino.kir.corp.google.com> <alpine.DEB.2.02.1405061920470.18635@chino.kir.corp.google.com> <alpine.DEB.2.02.1405061922010.18635@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1405072229390.19108@chino.kir.corp.google.com> <5371ED3F.6070505@suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2014, Vlastimil Babka wrote:

> I wonder what about a process doing e.g. mmap() with MAP_POPULATE. It seems to
> me that it would get only MIGRATE_ASYNC here, right? Since gfp_mask would
> include __GFP_NO_KSWAPD and it won't have PF_KTHREAD.
> I think that goes against the idea that with MAP_POPULATE you say you are
> willing to wait to have everything in place before you actually use the
> memory. So I guess you are also willing to wait for hugepages in that
> situation?
> 

I don't understand the distinction you're making between MAP_POPULATE and 
simply a prefault of the anon memory.  What is the difference in semantics 
between using MAP_POPULATE and touching a byte every page size along the 
range?  In the latter, you'd be faulting thp with MIGRATE_ASYNC, so I 
don't understand how MAP_POPULATE is any different or implies any 
preference for hugepages.
