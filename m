Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936223Ab3DIOeY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 10:34:24 -0400
Received: from a9-42.smtp-out.amazonses.com ([54.240.9.42]:50690 "EHLO
	a9-42.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760271Ab3DIOeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 10:34:23 -0400
X-Greylist: delayed 375 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Apr 2013 10:34:23 EDT
Date: Tue, 9 Apr 2013 14:28:06 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan@kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 2/3] mm, slub: count freed pages via rcu as this task's
 reclaimed_slab
In-Reply-To: <1365470478-645-2-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <0000013def3255c0-87577820-0ad9-46ac-8498-0589db4e7180-000000@email.amazonses.com>
References: <1365470478-645-1-git-send-email-iamjoonsoo.kim@lge.com> <1365470478-645-2-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.04.09-54.240.9.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Apr 2013, Joonsoo Kim wrote:

> Currently, freed pages via rcu is not counted for reclaimed_slab, because
> it is freed in rcu context, not current task context. But, this free is
> initiated by this task, so counting this into this task's reclaimed_slab
> is meaningful to decide whether we continue reclaim, or not.
> So change code to count these pages for this task's reclaimed_slab.

slab->reclaim_state guides the reclaim actions in vmscan.c. With this
patch slab->reclaim_state could get quite a high value without new pages being
available for allocation. slab->reclaim_state will only be updated
when the RCU period ends.

