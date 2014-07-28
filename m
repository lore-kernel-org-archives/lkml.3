Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbaG1WY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 18:24:28 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:45273 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbaG1WYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 18:24:25 -0400
Date: Mon, 28 Jul 2014 15:24:22 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vlastimil Babka <vbabka@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] mm, thp: restructure thp avoidance of light synchronous
 migration
In-Reply-To: <53D60F31.4050504@suse.cz>
Message-ID: <alpine.DEB.2.02.1407281523090.8998@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1407241540190.22557@chino.kir.corp.google.com> <53D60F31.4050504@suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2014, Vlastimil Babka wrote:

> Looks like kind of a shotgun approach to me. A single __GFP_NO_KSWAPD bullet
> is no longer enough, so we use all the flags and hope for the best. It seems
> THP has so many flags it should be unique for now, but I wonder if there is a
> better way to say how much an allocation is willing to wait.
> 

We would have to introduce a new __GFP_FAULT bit to distinguish between 
allocations at pagefault that should not use synchronous memory compaction 
solely for this case, it's probably not worth it.
