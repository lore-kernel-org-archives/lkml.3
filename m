Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557AbaDPTVq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 15:21:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53766 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756187AbaDPTVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 15:21:44 -0400
Date: Wed, 16 Apr 2014 20:21:35 +0100
From: Mel Gorman <mgorman@suse.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the akpm-current tree
Message-ID: <20140416192135.GY7292@suse.de>
References: <20140416151956.b3388ef9c11c6c58b535186f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140416151956.b3388ef9c11c6c58b535186f@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 03:19:56PM +1000, Stephen Rothwell wrote:
> Hi Andrew,
> 
> After merging the akpm-current tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> In file included from mm/vmscan.c:50:0:
> include/linux/swapops.h: In function 'is_swap_pte':
> include/linux/swapops.h:57:2: error: implicit declaration of function 'pte_present_nonuma' [-Werror=implicit-function-declaration]
>   return !pte_none(pte) && !pte_present_nonuma(pte) && !pte_file(pte);
>   ^
> 
> Caused by commit 851fe3337768 ("x86: define _PAGE_NUMA by reusing
> software bits on the PMD and PTE levels").  This build does not have
> CONFIG_NUMA_BALANCING set.
> 
> I have reverted that commit for today.

Thanks Stephen. A patch that should address the problem is on its way to
Andrew.

-- 
Mel Gorman
SUSE Labs
