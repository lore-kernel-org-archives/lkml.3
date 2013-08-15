Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759571Ab3HOSIB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 14:08:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:14008 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759201Ab3HOSIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 14:08:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,886,1367996400"; 
   d="scan'208";a="387733143"
Message-ID: <520D18F7.5000801@linux.intel.com>
Date: Thu, 15 Aug 2013 11:07:51 -0700
From: Dave Hansen <dave.hansen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] mm/vmalloc: use wrapper function get_vm_area_size
 to caculate size of vm area
References: <1376526703-2081-1-git-send-email-liwanp@linux.vnet.ibm.com> <1376526703-2081-4-git-send-email-liwanp@linux.vnet.ibm.com>
In-Reply-To: <1376526703-2081-4-git-send-email-liwanp@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2013 05:31 PM, Wanpeng Li wrote:
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 93d3182..553368c 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -1553,7 +1553,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>  	unsigned int nr_pages, array_size, i;
>  	gfp_t nested_gfp = (gfp_mask & GFP_RECLAIM_MASK) | __GFP_ZERO;
>  
> -	nr_pages = (area->size - PAGE_SIZE) >> PAGE_SHIFT;
> +	nr_pages = get_vm_area_size(area) >> PAGE_SHIFT;
>  	array_size = (nr_pages * sizeof(struct page *));

I guess this is fine, but I do see this same kind of use in a couple of
other spots in the kernel.  Was there a reason for doing this in this
one spot but ignoring the others?
