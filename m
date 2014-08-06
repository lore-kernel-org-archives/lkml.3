Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbaHFW0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 18:26:38 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:51588 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbaHFW0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 18:26:36 -0400
Date: Wed, 6 Aug 2014 15:26:34 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vlastimil Babka <vbabka@suse.cz>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Hugh Dickins <hughd@google.com>, Minchan Kim <minchan@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH 1/4] mm: page_alloc: determine migratetype only once
In-Reply-To: <1407333356-30928-2-git-send-email-vbabka@suse.cz>
Message-ID: <alpine.DEB.2.02.1408061526250.13545@chino.kir.corp.google.com>
References: <1407333356-30928-1-git-send-email-vbabka@suse.cz> <1407333356-30928-2-git-send-email-vbabka@suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Aug 2014, Vlastimil Babka wrote:

> The check for ALLOC_CMA in __alloc_pages_nodemask() derives migratetype
> from gfp_mask in each retry pass, although the migratetype variable already
> has the value determined and it does not change. Use the variable and perform
> the check only once. Also convert #ifdef CONFIC_CMA to IS_ENABLED.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Acked-by: David Rientjes <rientjes@google.com>
