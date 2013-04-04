Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765317Ab3DDWau (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 18:30:50 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:42452 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765257Ab3DDWar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 18:30:47 -0400
Message-ID: <515DFF08.3060005@linux.vnet.ibm.com>
Date: Thu, 04 Apr 2013 17:30:32 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Joe Perches <joe@perches.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Hugh Dickens <hughd@google.com>, Paul Mackerras <paulus@samba.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, Bob Liu <lliubbo@gmail.com>
Subject: Re: [PATCHv8 5/8] mm: break up swap_writepage() for frontswap backends
References: <1365113446-25647-1-git-send-email-sjenning@linux.vnet.ibm.com> <1365113446-25647-6-git-send-email-sjenning@linux.vnet.ibm.com>
In-Reply-To: <1365113446-25647-6-git-send-email-sjenning@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040422-7182-0000-0000-0000061822EC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2013 05:10 PM, Seth Jennings wrote:
> swap_writepage() is currently where frontswap hooks into the swap
> write path to capture pages with the frontswap_store() function.
> However, if a frontswap backend wants to "resume" the writeback of
> a page to the swap device, it can't call swap_writepage() as
> the page will simply reenter the backend.
> 
> This patch separates swap_writepage() into a top and bottom half, the
> bottom half named __swap_writepage() to allow a frontswap backend,
> like zswap, to resume writeback beyond the frontswap_store() hook.
> 
> __add_to_swap_cache() is also made non-static so that the page for
> which writeback is to be resumed can be added to the swap cache.
> 
> Acked-by: Minchan Kim <minchan@kernel.org>
> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>

Adding Cc Bob Liu.

I just remembered that Bob had done a repost of the 5 and 6 patches,
outside the zswap thread,  with a small change to avoid a checkpatch
warning.  I didn't pull that change into my version, but I should have.

It doesn't make a functional difference, so this patch can still go
forward and the checkpatch warning can be cleaned up in a subsequent
patch.  If another revision of the patchset is needed for other
reasons, I'll pull this change into the next version.

I think Dan and Bob would be ok with their tags being applied to 5 and 6:

Acked-by: Bob Liu <bob.liu@oracle.com>
Reviewed-by: Dan Magenheimer <dan.magenheimer@oracle.com>

That ok?

Thanks,
Seth

