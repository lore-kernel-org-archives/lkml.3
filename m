Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab3GAOPT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 10:15:19 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59917 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab3GAOPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 10:15:17 -0400
Message-ID: <51D18ED5.50103@ti.com>
Date: Mon, 1 Jul 2013 10:14:45 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Nicolas Pitre <nico@linaro.org>
Subject: Re: [RFC PATCH 5/6] ARM, mm: change meaning of max_low_pfn to maximum
 pfn for nobootmem
References: <1364184674-13798-1-git-send-email-iamjoonsoo.kim@lge.com> <1364184674-13798-6-git-send-email-iamjoonsoo.kim@lge.com>
In-Reply-To: <1364184674-13798-6-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joonsoo,

On Monday 25 March 2013 12:11 AM, Joonsoo Kim wrote:
> nobootmem use max_low_pfn for computing boundary in free_all_bootmem()
> So we need proper value to max_low_pfn.
> 
> But, there is some difficulty related to max_low_pfn. max_low_pfn is used
> for two meanings in various architectures. One is for number of pages
> in lowmem and the other is for maximum lowmem pfn. Now, in ARM, it is used
> as number of pages in lowmem. You can get more information in below link.
> http://lwn.net/Articles/543408/
> http://lwn.net/Articles/543424/
> 
> As I investigated, architectures which use max_low_pfn as maximum pfn are
> more than others, so to change meaning of max_low_pfn to maximum pfn
> is preferable solution to me. This patch change max_low_pfn as maximum
> lowmem pfn in ARM. In addition, min_low_pfn, max_pfn is assigned according
> to this criteria.
> 
> There is no real user for max_low_pfn except block/blk-setting.c and
> blk-setting.c assume that max_low_pfn is maximum lowmem pfn,
> so this patch may not harm anything.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>
I have been also carrying similar patch as yours in an attempt
to make LPAE kernel work on ARM. Your patch carries better
description, so will your version and include in my series
which I plan to post on the list after some more testing.
Will copy you. The changes are very similar to your series.

Regards,
Santosh
 

