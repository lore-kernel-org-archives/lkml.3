Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759727Ab3ICHYb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 03:24:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:14202 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759677Ab3ICHYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 03:24:30 -0400
X-IronPort-AV: E=Sophos;i="4.89,1012,1367942400"; 
   d="scan'208";a="8388700"
Message-ID: <52258E9C.6050601@cn.fujitsu.com>
Date: Tue, 03 Sep 2013 15:24:12 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/4] mm/vmalloc: revert "mm/vmalloc.c: emit the failure
 message before return"
References: <1378191706-29696-1-git-send-email-liwanp@linux.vnet.ibm.com> <1378191706-29696-2-git-send-email-liwanp@linux.vnet.ibm.com>
In-Reply-To: <1378191706-29696-2-git-send-email-liwanp@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/03 15:22:20,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/03 15:22:22,
	Serialize complete at 2013/09/03 15:22:22
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2013 03:01 PM, Wanpeng Li wrote:
> Changelog:
>  *v2 -> v3: revert commit 46c001a2 directly
> 
> Don't warning twice in __vmalloc_area_node and __vmalloc_node_range if
> __vmalloc_area_node allocation failure. This patch revert commit 46c001a2
> (mm/vmalloc.c: emit the failure message before return).
> 
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>

Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

> ---
>  mm/vmalloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
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
