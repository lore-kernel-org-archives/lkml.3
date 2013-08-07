Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124Ab3HGGLp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 02:11:45 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:52388 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757077Ab3HGGLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 02:11:44 -0400
Date: Wed, 7 Aug 2013 02:11:38 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Michel Lespinasse <walken@google.com>
Subject: Re: [PATCH 3/4] mm, rmap: minimize lock hold when unlink_anon_vmas
Message-ID: <20130807061138.GK1845@cmpxchg.org>
References: <1375778620-31593-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1375778620-31593-3-git-send-email-iamjoonsoo.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375778620-31593-3-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 05:43:39PM +0900, Joonsoo Kim wrote:
> Currently, we free the avc objects with holding a lock. To minimize
> lock hold time, we just move the avc objects to another list
> with holding a lock. Then, iterate them and free objects without holding
> a lock. This makes lock hold time minimized.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

I expect kfree() to be fast enough that we don't think we need to
bother batching this outside the lock.
