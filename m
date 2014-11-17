Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbaKQAQT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 19:16:19 -0500
Received: from TYO201.gate.nec.co.jp ([210.143.35.51]:46733 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbaKQAQQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 19:16:16 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Luiz Capitulino <lcapitulino@redhat.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "rientjes@google.com" <rientjes@google.com>,
        "riel@redhat.com" <riel@redhat.com>,
        "isimatu.yasuaki@jp.fujitsu.com" <isimatu.yasuaki@jp.fujitsu.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "davidlohr@hp.com" <davidlohr@hp.com>
Subject: Re: [PATCH 2/3] hugetlb: alloc_bootmem_huge_page(): use IS_ALIGNED()
Thread-Topic: [PATCH 2/3] hugetlb: alloc_bootmem_huge_page(): use
 IS_ALIGNED()
Thread-Index: AQHQAfsWayhCsaaeeEezAKUJWbIK6A==
Date: Mon, 17 Nov 2014 00:11:51 +0000
Message-ID: <20141117001228.GB4667@hori1.linux.bs1.fc.nec.co.jp>
References: <1415831593-9020-1-git-send-email-lcapitulino@redhat.com>
 <1415831593-9020-3-git-send-email-lcapitulino@redhat.com>
In-Reply-To: <1415831593-9020-3-git-send-email-lcapitulino@redhat.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.128.101.20]
Content-Type: text/plain; charset="iso-2022-jp"
Content-ID: <DB9ACF5C0D0027439E0D9DB9690CD525@gisp.nec.co.jp>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 05:33:12PM -0500, Luiz Capitulino wrote:
> No reason to duplicate the code of an existing macro.
> 
> Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>

I think that we can apply the same macro for the following two lines in
__unmap_hugepage_range():

	BUG_ON(start & ~huge_page_mask(h));
	BUG_ON(end & ~huge_page_mask(h));

Anyway, this makes the code more readable.

Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

> ---
>  mm/hugetlb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 9fd7227..a10fd57 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1457,7 +1457,7 @@ int __weak alloc_bootmem_huge_page(struct hstate *h)
>  	return 0;
>  
>  found:
> -	BUG_ON((unsigned long)virt_to_phys(m) & (huge_page_size(h) - 1));
> +	BUG_ON(!IS_ALIGNED(virt_to_phys(m), huge_page_size(h)));
>  	/* Put them into a private list first because mem_map is not up yet */
>  	list_add(&m->list, &huge_boot_pages);
>  	m->hstate = h;
> -- 
> 1.9.3
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>