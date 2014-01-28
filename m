Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbaA1JKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 04:10:55 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38564 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaA1JKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 04:10:51 -0500
Date: Tue, 28 Jan 2014 01:10:45 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tang Chen <tangchen@cn.fujitsu.com>
cc: davej@redhat.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Andrew Morton <akpm@linux-foundation.org>, zhangyanfei@cn.fujitsu.com,
        guz.fnst@cn.fujitsu.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] numa, mem-hotplug: Initialize numa_kernel_nodes in
 numa_clear_kernel_node_hotplug().
In-Reply-To: <1390899916-23566-2-git-send-email-tangchen@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.02.1401280109360.4244@chino.kir.corp.google.com>
References: <1390899916-23566-1-git-send-email-tangchen@cn.fujitsu.com> <1390899916-23566-2-git-send-email-tangchen@cn.fujitsu.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jan 2014, Tang Chen wrote:

> On-stack variable numa_kernel_nodes in numa_clear_kernel_node_hotplug()
> was not initialized. So we need to initialize it.
> 
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> Tested-by: Gu Zheng <guz.fnst@cn.fujitsu.com>

Reported-by: David Rientjes <rientjes@google.com>

> ---
>  arch/x86/mm/numa.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
> index 81b2750..00c9f09 100644
> --- a/arch/x86/mm/numa.c
> +++ b/arch/x86/mm/numa.c
> @@ -569,6 +569,8 @@ static void __init numa_clear_kernel_node_hotplug(void)
>  	unsigned long start, end;
>  	struct memblock_type *type = &memblock.reserved;
>  
> +	nodes_clear(numa_kernel_nodes)

Just initialize it with NODE_MASK_NONE.

> +
>  	/* Mark all kernel nodes. */
>  	for (i = 0; i < type->cnt; i++)
>  		node_set(type->regions[i].nid, numa_kernel_nodes);
