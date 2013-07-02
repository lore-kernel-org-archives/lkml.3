Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab3GBB2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 21:28:19 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:60618 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755648Ab3GBB2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 21:28:18 -0400
X-AuditID: 9c93016f-b7b26ae000002351-e7-51d22cb0cd5b
Date: Tue, 2 Jul 2013 10:28:19 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nico@linaro.org>
Subject: Re: [RFC PATCH 5/6] ARM, mm: change meaning of max_low_pfn to
 maximum pfn for nobootmem
Message-ID: <20130702012819.GA31505@lge.com>
References: <1364184674-13798-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1364184674-13798-6-git-send-email-iamjoonsoo.kim@lge.com>
 <51D18ED5.50103@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51D18ED5.50103@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 10:14:45AM -0400, Santosh Shilimkar wrote:
> Joonsoo,
> 
> On Monday 25 March 2013 12:11 AM, Joonsoo Kim wrote:
> > nobootmem use max_low_pfn for computing boundary in free_all_bootmem()
> > So we need proper value to max_low_pfn.
> > 
> > But, there is some difficulty related to max_low_pfn. max_low_pfn is used
> > for two meanings in various architectures. One is for number of pages
> > in lowmem and the other is for maximum lowmem pfn. Now, in ARM, it is used
> > as number of pages in lowmem. You can get more information in below link.
> > http://lwn.net/Articles/543408/
> > http://lwn.net/Articles/543424/
> > 
> > As I investigated, architectures which use max_low_pfn as maximum pfn are
> > more than others, so to change meaning of max_low_pfn to maximum pfn
> > is preferable solution to me. This patch change max_low_pfn as maximum
> > lowmem pfn in ARM. In addition, min_low_pfn, max_pfn is assigned according
> > to this criteria.
> > 
> > There is no real user for max_low_pfn except block/blk-setting.c and
> > blk-setting.c assume that max_low_pfn is maximum lowmem pfn,
> > so this patch may not harm anything.
> > 
> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> >
> I have been also carrying similar patch as yours in an attempt
> to make LPAE kernel work on ARM. Your patch carries better
> description, so will your version and include in my series
> which I plan to post on the list after some more testing.
> Will copy you. The changes are very similar to your series.

Okay!

Thanks.
> 
> Regards,
> Santosh
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
