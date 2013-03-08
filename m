Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757836Ab3CHVbK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 16:31:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50266 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756372Ab3CHVbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 16:31:08 -0500
Date: Fri, 8 Mar 2013 13:31:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Toshi Kani <toshi.kani@hp.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, wency@cn.fujitsu.com,
        tangchen@cn.fujitsu.com
Subject: Re: [PATCH 2/2] mm: remove_memory: Fix end_pfn setting
Message-Id: <20130308133106.ec4f9810b69b105b8f70d82a@linux-foundation.org>
In-Reply-To: <1362757301-18550-2-git-send-email-toshi.kani@hp.com>
References: <1362757301-18550-1-git-send-email-toshi.kani@hp.com>
	<1362757301-18550-2-git-send-email-toshi.kani@hp.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  8 Mar 2013 08:41:41 -0700 Toshi Kani <toshi.kani@hp.com> wrote:

> remove_memory() calls walk_memory_range() with [start_pfn, end_pfn),
> where end_pfn is exclusive in this range.  Therefore, end_pfn needs
> to be set to the next page of the end address.
> 
> ...
>
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1801,7 +1801,7 @@ int __ref remove_memory(int nid, u64 start, u64 size)
>  	int retry = 1;
>  
>  	start_pfn = PFN_DOWN(start);
> -	end_pfn = start_pfn + PFN_DOWN(size);
> +	end_pfn = PFN_UP(start + size - 1);
>  
>  	/*
>  	 * When CONFIG_MEMCG is on, one memory block may be used by other

That looks right, although these rounding/boundary things are always
hard.  I wonder if `start' and `size' are ever not multiples of
PAGE_SIZE..

How did you discover this?  Code inspection, or some runtime
malfunction?  Please always include this info when fixing bugs.

