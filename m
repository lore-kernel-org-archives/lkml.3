Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab3EUKfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 06:35:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15884 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753537Ab3EUKfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 06:35:04 -0400
Date: Tue, 21 May 2013 20:34:39 +1000
From: Dave Chinner <dchinner@redhat.com>
To: Oskar Andero <oskar.andero@sonymobile.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Radovan Lekanovic <radovan.lekanovic@sonymobile.com>,
        David Rientjes <rientjes@google.com>,
        Glauber Costa <glommer@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] mm: vmscan: add BUG_ON on illegal return values from
 scan_objects
Message-ID: <20130521103439.GH11167@devil.localdomain>
References: <1369041267-26424-1-git-send-email-oskar.andero@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369041267-26424-1-git-send-email-oskar.andero@sonymobile.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 11:14:27AM +0200, Oskar Andero wrote:
> Add a BUG_ON to catch any illegal value from the shrinkers. This fixes a
> potential bug if scan_objects returns a negative other than -1, which
> would lead to undefined behaviour.
> 
> Cc: Glauber Costa <glommer@openvz.org>
> Cc: Dave Chinner <dchinner@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Oskar Andero <oskar.andero@sonymobile.com>
> ---
>  mm/vmscan.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 6bac41e..fbe6742 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -293,6 +293,7 @@ shrink_slab_one(struct shrinker *shrinker, struct shrink_control *shrinkctl,
>  		ret = shrinker->scan_objects(shrinker, shrinkctl);
>  		if (ret == -1)
>  			break;
> +		BUG_ON(ret < -1);
>  		freed += ret;
>  
>  		count_vm_events(SLABS_SCANNED, nr_to_scan);

NACK. we've got to fix the damn shrinkers first.

If you want this sort of guard added to the patchset Glauber and I
are working on that does this, then discuss it in the context of
that patch set.

Even if you do, you'll get the same answer: we need to first all the
busted shrinkers before we even consider being nasty about enforcing
the API constraints to prevent furture breakage.

If you want to do something useful, look at all the comments about
broken shrinkers in Glauber's patch set and work with the owners of
the code to understand what they really need and get them fixed.

-Dave.
-- 
Dave Chinner
dchinner@redhat.com
