Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585Ab3EZJBC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 05:01:02 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:36319 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab3EZJA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 05:00:58 -0400
Date: Sun, 26 May 2013 11:00:54 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        David Rientjes <rientjes@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Tang Chen <tangchen@cn.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: Re: [patch v2 3/6] mm/memory_hotplug: Disable memory hotremove for
 32bit
Message-ID: <20130526090054.GE10651@dhcp22.suse.cz>
References: <1369547921-24264-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <1369547921-24264-3-git-send-email-liwanp@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369547921-24264-3-git-send-email-liwanp@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 26-05-13 13:58:38, Wanpeng Li wrote:
> As KOSAKI Motohiro mentioned, memory hotplug don't support 32bit since 
> it was born, 

Why? any reference? This reasoning is really weak.

> this patch disable memory hotremove when 32bit at compile 
> time.
> 
> Suggested-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> ---
>  mm/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/Kconfig b/mm/Kconfig
> index e742d06..ada9569 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -184,6 +184,7 @@ config MEMORY_HOTREMOVE
>  	bool "Allow for memory hot remove"
>  	select MEMORY_ISOLATION
>  	select HAVE_BOOTMEM_INFO_NODE if X86_64
> +	depends on 64BIT
>  	depends on MEMORY_HOTPLUG && ARCH_ENABLE_MEMORY_HOTREMOVE
>  	depends on MIGRATION
>  
> -- 
> 1.8.1.2
> 

-- 
Michal Hocko
SUSE Labs
