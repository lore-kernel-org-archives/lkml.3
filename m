Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935951Ab3DKPP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 11:15:29 -0400
Received: from a9-50.smtp-out.amazonses.com ([54.240.9.50]:57783 "EHLO
	a9-50.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932840Ab3DKPP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 11:15:28 -0400
X-Greylist: delayed 698 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Apr 2013 11:15:28 EDT
Date: Thu, 11 Apr 2013 15:03:48 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Simon Jeons <simon.jeons@gmail.com>
cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 2/3] mm, slub: count freed pages via rcu as this task's
 reclaimed_slab
In-Reply-To: <51663210.7070502@gmail.com>
Message-ID: <0000013df99fbc98-f20c5345-92eb-405b-81e8-df781dab2391-000000@email.amazonses.com>
References: <1365470478-645-1-git-send-email-iamjoonsoo.kim@lge.com> <1365470478-645-2-git-send-email-iamjoonsoo.kim@lge.com> <5163E194.3080600@gmail.com> <0000013def363b50-9a16dd09-72ad-494f-9c25-17269fc3aab3-000000@email.amazonses.com> <5164DA6A.5060607@gmail.com>
 <0000013df43a48e5-6addd57e-952b-4754-848e-6d454b0a906c-000000@email.amazonses.com> <51663210.7070502@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.04.11-54.240.9.50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Apr 2013, Simon Jeons wrote:

> It seems that I need to simple my question.
> All pages which order >=1 are compound pages?

In the slub allocator that is true.

One can request and free a series of contiguous pages that are not
compound pages from the page allocator and a couple of subsystems use
those.

