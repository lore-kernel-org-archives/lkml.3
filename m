Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265Ab3CYJsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 05:48:32 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43558 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262Ab3CYJsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 05:48:31 -0400
Date: Mon, 25 Mar 2013 09:48:16 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Nicolas Pitre <nico@linaro.org>
Subject: Re: [RFC PATCH 5/6] ARM, mm: change meaning of max_low_pfn to
	maximum pfn for nobootmem
Message-ID: <20130325094816.GO4977@n2100.arm.linux.org.uk>
References: <1364184674-13798-1-git-send-email-iamjoonsoo.kim@lge.com> <1364184674-13798-6-git-send-email-iamjoonsoo.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364184674-13798-6-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25, 2013 at 01:11:13PM +0900, Joonsoo Kim wrote:
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

This will need some very rigorous testing before it can go into mainline.
