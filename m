Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200Ab3HGHSc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 03:18:32 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56378 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757127Ab3HGHS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 03:18:29 -0400
X-AuditID: 9c930179-b7c53ae000000457-91-5201f4c36e17
Date: Wed, 7 Aug 2013 16:18:32 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Michel Lespinasse <walken@google.com>
Subject: Re: [PATCH 3/4] mm, rmap: minimize lock hold when unlink_anon_vmas
Message-ID: <20130807071832.GC32449@lge.com>
References: <1375778620-31593-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1375778620-31593-3-git-send-email-iamjoonsoo.kim@lge.com>
 <20130807061138.GK1845@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130807061138.GK1845@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 02:11:38AM -0400, Johannes Weiner wrote:
> On Tue, Aug 06, 2013 at 05:43:39PM +0900, Joonsoo Kim wrote:
> > Currently, we free the avc objects with holding a lock. To minimize
> > lock hold time, we just move the avc objects to another list
> > with holding a lock. Then, iterate them and free objects without holding
> > a lock. This makes lock hold time minimized.
> > 
> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> 
> I expect kfree() to be fast enough that we don't think we need to
> bother batching this outside the lock.

Okay!

Thanks.

