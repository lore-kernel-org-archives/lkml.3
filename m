Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab3DKXuw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 19:50:52 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35241 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab3DKXuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 19:50:51 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <51674C30.5060309@jp.fujitsu.com>
Date: Fri, 12 Apr 2013 08:50:08 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <rientjes@google.com>,
        <linuxram@us.ibm.com>, <guz.fnst@cn.fujitsu.com>, <tmac@hp.com>,
        <wency@cn.fujitsu.com>, <tangchen@cn.fujitsu.com>,
        <jiang.liu@huawei.com>
Subject: Re: [PATCH] resource: Update config option of release_mem_region_adjustable()
References: <1365719185-4799-1-git-send-email-toshi.kani@hp.com>
In-Reply-To: <1365719185-4799-1-git-send-email-toshi.kani@hp.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/04/12 7:26, Toshi Kani wrote:
> Changed the config option of release_mem_region_adjustable() from
> CONFIG_MEMORY_HOTPLUG to CONFIG_MEMORY_HOTREMOVE since this function
> is only used for memory hot-delete.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>

Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Thanks,
Yasuaki Ishimatsu


> ---
> 
> This patch applies on top of the two patches below:
> Re: [PATCH v3 2/3] resource: Add release_mem_region_adjustable()
> https://lkml.org/lkml/2013/4/11/381
> [patch] mm, hotplug: avoid compiling memory hotremove functions when disabled
> https://lkml.org/lkml/2013/4/10/37
> 
> ---
>   include/linux/ioport.h |    2 +-
>   kernel/resource.c      |    4 ++--
>   2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/ioport.h b/include/linux/ioport.h
> index 961d4dc..89b7c24 100644
> --- a/include/linux/ioport.h
> +++ b/include/linux/ioport.h
> @@ -192,7 +192,7 @@ extern struct resource * __request_region(struct resource *,
>   extern int __check_region(struct resource *, resource_size_t, resource_size_t);
>   extern void __release_region(struct resource *, resource_size_t,
>   				resource_size_t);
> -#ifdef CONFIG_MEMORY_HOTPLUG
> +#ifdef CONFIG_MEMORY_HOTREMOVE
>   extern int release_mem_region_adjustable(struct resource *, resource_size_t,
>   				resource_size_t);
>   #endif
> diff --git a/kernel/resource.c b/kernel/resource.c
> index 16bfd39..4aef886 100644
> --- a/kernel/resource.c
> +++ b/kernel/resource.c
> @@ -1021,7 +1021,7 @@ void __release_region(struct resource *parent, resource_size_t start,
>   }
>   EXPORT_SYMBOL(__release_region);
>   
> -#ifdef CONFIG_MEMORY_HOTPLUG
> +#ifdef CONFIG_MEMORY_HOTREMOVE
>   /**
>    * release_mem_region_adjustable - release a previously reserved memory region
>    * @parent: parent resource descriptor
> @@ -1122,7 +1122,7 @@ int release_mem_region_adjustable(struct resource *parent,
>   	kfree(new_res);
>   	return ret;
>   }
> -#endif	/* CONFIG_MEMORY_HOTPLUG */
> +#endif	/* CONFIG_MEMORY_HOTREMOVE */
>   
>   /*
>    * Managed region resource
> 


