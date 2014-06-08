Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288AbaFHW0B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 18:26:01 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:42868 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707AbaFHWZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 18:25:53 -0400
Date: Sun, 8 Jun 2014 15:25:50 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Luiz Capitulino <lcapitulino@redhat.com>
cc: akpm@linux-foundation.org, andi@firstfloor.org, riel@redhat.com,
        yinghai@kernel.org, isimatu.yasuaki@jp.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] x86: numa: drop ZONE_ALIGN
In-Reply-To: <20140608181436.17de69ac@redhat.com>
Message-ID: <alpine.DEB.2.02.1406081524580.21744@chino.kir.corp.google.com>
References: <20140608181436.17de69ac@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jun 2014, Luiz Capitulino wrote:

> diff --git a/arch/x86/include/asm/numa.h b/arch/x86/include/asm/numa.h
> index 4064aca..01b493e 100644
> --- a/arch/x86/include/asm/numa.h
> +++ b/arch/x86/include/asm/numa.h
> @@ -9,7 +9,6 @@
>  #ifdef CONFIG_NUMA
>  
>  #define NR_NODE_MEMBLKS		(MAX_NUMNODES*2)
> -#define ZONE_ALIGN (1UL << (MAX_ORDER+PAGE_SHIFT))
>  
>  /*
>   * Too small node sizes may confuse the VM badly. Usually they
> diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
> index 1d045f9..69f6362 100644
> --- a/arch/x86/mm/numa.c
> +++ b/arch/x86/mm/numa.c
> @@ -200,8 +200,6 @@ static void __init setup_node_data(int nid, u64 start, u64 end)
>  	if (end && (end - start) < NODE_MIN_SIZE)
>  		return;
>  
> -	start = roundup(start, ZONE_ALIGN);
> -
>  	printk(KERN_INFO "Initmem setup node %d [mem %#010Lx-%#010Lx]\n",
>  	       nid, start, end - 1);
>  

What ensures this start address is page aligned from the BIOS?
