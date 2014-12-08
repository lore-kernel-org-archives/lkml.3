Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbaLHJeb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 04:34:31 -0500
Received: from mail113-251.mail.alibaba.com ([205.204.113.251]:40910 "EHLO
	us-alimail-mta1.hst.scl.en.alidc.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754535AbaLHJea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 04:34:30 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R621e4;FP=0|-1|-1|-1|0|-1|-1|-1;HT=r41g03006;MF=hillf.zj@alibaba-inc.com;PH=DS;RN=6;RT=6;SR=0;
Reply-To: "Hillf Danton" <hillf.zj@alibaba-inc.com>
From: "Hillf Danton" <hillf.zj@alibaba-inc.com>
To: <Yalin.Wang@sonymobile.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Hillf Danton" <hillf.zj@alibaba-inc.com>
Subject: Re: [PATCH] mm:add VM_BUG_ON() for page_mapcount()
Date: Mon, 08 Dec 2014 17:33:26 +0800
Message-ID: <010b01d012ca$05244060$0f6cc120$@alibaba-inc.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AdASyaRYNK5Lt1HlQ1KFwSk6V3BFwA==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> This patch add VM_BUG_ON() for slab page,
> because _mapcount is an union with slab struct in struct page,
> avoid access _mapcount if this page is a slab page.
> Also remove the unneeded bracket.
> 
> Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
> ---
>  include/linux/mm.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 11b65cf..34124c4 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -373,7 +373,8 @@ static inline void reset_page_mapcount(struct page *page)
> 
>  static inline int page_mapcount(struct page *page)
>  {
> -	return atomic_read(&(page)->_mapcount) + 1;
> +	VM_BUG_ON(PageSlab(page));

s/ VM_BUG_ON/ VM_BUG_ON_PAGE/ ?

> +	return atomic_read(&page->_mapcount) + 1;
>  }
> 

