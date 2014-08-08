Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272AbaHHNjk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 09:39:40 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:57022 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbaHHNjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 09:39:39 -0400
Message-ID: <53E4D312.5000601@codeaurora.org>
Date: Fri, 08 Aug 2014 19:09:30 +0530
From: Chintan Pandya <cpandya@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: "Sha, Ruibin" <ruibin.sha@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "mel@csn.ul.ie" <mel@csn.ul.ie>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "mgorman@suse.de" <mgorman@suse.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Zhang, Yanmin" <yanmin.zhang@intel.com>, "He, Bo" <bo.he@intel.com>
Subject: Re: [PATCH]  export the function kmap_flush_unused.
References: <3C85A229999D6B4A89FA64D4680BA6142C7DFA@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <3C85A229999D6B4A89FA64D4680BA6142C7DFA@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2014 02:46 PM, Sha, Ruibin wrote:
> export the function kmap_flush_unused.
>
> Scenario: When graphic driver need high memory spece, we use alloc_pages()
> to allocate. But if the allocated page has just been
> mapped in the KMAP space(like first kmap then kunmap) and
> no flush page happened on PKMAP, the page virtual address is
> not NULL.Then when we get that page and set page attribute like
> set_memory_uc and set_memory_wc, we hit error.

Could you explain your scenario with more details ? set_memory_* should 
be applied on mapped address. And in attempt to map your page (which was 
just kmap and kunmap'ed), it will overwrite the previous mappings.

Moreover, in my view, kmap_flush_unused is just helping us in keeping 
the cache clean for kmap virtual addresses if they are unmapped. Is it 
serving any more purpose here ?

>
> fix: For that scenario,when we get the allocated page and its virtual
> address is not NULL, we would like first flush that page.
> So need export that function kmap_flush_unused.
>
> Signed-off-by: sha, ruibin <ruibin.sha@intel.com>
>
> ---
> mm/highmem.c | 1 +
> 1 file changed, 1 insertion(+)
>
> diff --git a/mm/highmem.c b/mm/highmem.c
> index b32b70c..511299b 100644
> --- a/mm/highmem.c
> +++ b/mm/highmem.c
> @@ -156,6 +156,7 @@ void kmap_flush_unused(void)
> flush_all_zero_pkmaps();
> unlock_kmap();
> }
> +EXPORT_SYMBOL(kmap_flush_unused);
This symbol is already extern'ed. Is it not sufficient for your case ?
>
> static inline unsigned long map_new_virtual(struct page *page)
> {
> --
> 1.7.9.5
>
> Best Regards
>
> ---------------------------------------------------------------
>
> Sha, Rui bin ( Robin )
>
> +86 13817890945
>
> Android System Integration Shanghai
>


-- 
Chintan Pandya

QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a
member of the Code Aurora Forum, hosted by The Linux Foundation
