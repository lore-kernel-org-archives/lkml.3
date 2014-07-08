Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550AbaGHT2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:28:38 -0400
Received: from relay.parallels.com ([195.214.232.42]:46262 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756469AbaGHT2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:28:35 -0400
Message-ID: <53BC465D.7030205@parallels.com>
Date: Tue, 8 Jul 2014 23:28:29 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: Don't forget to set softdirty on file mapped fault
References: <20140708192151.GD17860@moon.sw.swsoft.com>
In-Reply-To: <20140708192151.GD17860@moon.sw.swsoft.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.24.20.194]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2014 11:21 PM, Cyrill Gorcunov wrote:
> Otherwise we may not notice that pte was softdirty because pte_mksoft_dirty
> helper _returns_ new pte but not modifies argument.
> 
> CC: Pavel Emelyanov <xemul@parallels.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>

Acked-by: Pavel Emelyanov <xemul@parallels.com>

> ---
>  mm/memory.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6.git/mm/memory.c
> ===================================================================
> --- linux-2.6.git.orig/mm/memory.c
> +++ linux-2.6.git/mm/memory.c
> @@ -2744,7 +2744,7 @@ void do_set_pte(struct vm_area_struct *v
>  	if (write)
>  		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
>  	else if (pte_file(*pte) && pte_file_soft_dirty(*pte))
> -		pte_mksoft_dirty(entry);
> +		entry = pte_mksoft_dirty(entry);
>  	if (anon) {
>  		inc_mm_counter_fast(vma->vm_mm, MM_ANONPAGES);
>  		page_add_new_anon_rmap(page, vma, address);
> .
> 

