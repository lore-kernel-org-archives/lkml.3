Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120AbaE3Hqz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 03:46:55 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:57607 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbaE3Hqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 03:46:54 -0400
Date: Fri, 30 May 2014 15:41:45 +0800
From: Shaohua Li <shli@kernel.org>
To: Hugh Dickins <hughd@google.com>
Cc: Chen Yucong <slaoub@gmail.com>, akpm@linux-foundation.org,
        ddstreet@ieee.org, mgorman@suse.de, k.kozlowski@samsung.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] swap: Avoid scanning invalidated region for cheap seek
Message-ID: <20140530074145.GA2688@kernel.org>
References: <1401069659-29589-1-git-send-email-slaoub@gmail.com>
 <alpine.LSU.2.11.1405272037080.1126@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1405272037080.1126@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 08:53:00PM -0700, Hugh Dickins wrote:
> On Mon, 26 May 2014, Chen Yucong wrote:
> 
> > For cheap seek, when we scan the region between si->lowset_bit
> > and scan_base, if san_base is greater than si->highest_bit, the
> > scan operation between si->highest_bit and scan_base is not
> > unnecessary.
> > 
> > This patch can be used to avoid scanning invalidated region for
> > cheap seek.
> > 
> > Signed-off-by: Chen Yucong <slaoub@gmail.com>
> 
> I was going to suggest that you are adding a little code to a common
> path, in order to optimize a very unlikely case: which does not seem
> worthwhile to me.
> 
> But digging a little deeper, I think you have hit upon something more
> interesting (though still in no need of your patch): it looks to me
> like that is not even a common path, but dead code.
> 
> Shaohua, am I missing something, or does all SWP_SOLIDSTATE "seek is
> cheap" now go your si->cluster_info scan_swap_map_try_ssd_cluster()
> route?  So that the "last_in_cluster < scan_base" loop in the body
> of scan_swap_map() is just redundant, and should have been deleted?

Sorry for the delay, you are right. SSD case always goes
scan_swap_map_try_ssd_cluster, otherwise we just scan from lowest_bit to
highest_bit, so the "last_in_cluster < scan_base" loop is dead.

Yucong, can you resent a patch to delete it as Hugh suggested?

Thanks,
Shaohua
