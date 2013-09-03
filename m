Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334Ab3ICFib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 01:38:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:10185 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932219Ab3ICFia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 01:38:30 -0400
X-IronPort-AV: E=Sophos;i="4.89,1011,1367942400"; 
   d="scan'208";a="8387101"
Message-ID: <522575C5.7050108@cn.fujitsu.com>
Date: Tue, 03 Sep 2013 13:38:13 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] mm/vmalloc: don't warning vmalloc allocation failure
 twice
References: <1378177220-26218-1-git-send-email-liwanp@linux.vnet.ibm.com> <1378177220-26218-2-git-send-email-liwanp@linux.vnet.ibm.com>
In-Reply-To: <1378177220-26218-2-git-send-email-liwanp@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/03 13:36:21,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/03 13:36:22,
	Serialize complete at 2013/09/03 13:36:22
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2013 11:00 AM, Wanpeng Li wrote:
> Don't warning twice in __vmalloc_area_node and __vmalloc_node_range if
> __vmalloc_area_node allocation failure.
> 
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>

OK, I missed the warning in __vmalloc_area_node(), so you are right.
You can just revert the commit 46c001a2753f47ffa621131baa3409e636515347.

> ---
>  mm/vmalloc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index d78d117..e3ec8b4 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -1635,7 +1635,7 @@ void *__vmalloc_node_range(unsigned long size, unsigned long align,
>  
>  	addr = __vmalloc_area_node(area, gfp_mask, prot, node, caller);
>  	if (!addr)
> -		goto fail;
> +		return NULL;
>  
>  	/*
>  	 * In this function, newly allocated vm_struct has VM_UNINITIALIZED
> 


-- 
Thanks.
Zhang Yanfei
