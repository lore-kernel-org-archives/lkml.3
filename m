Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505AbaLIDTf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 22:19:35 -0500
Received: from mail113-249.mail.alibaba.com ([205.204.113.249]:44607 "EHLO
	us-alimail-mta2.hst.scl.en.alidc.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756470AbaLIDTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 22:19:33 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R901e4;FP=0|-1|-1|-1|0|-1|-1|-1;HT=r41g06005;MF=hillf.zj@alibaba-inc.com;PH=DS;RN=5;RT=5;SR=0;
Reply-To: "Hillf Danton" <hillf.zj@alibaba-inc.com>
From: "Hillf Danton" <hillf.zj@alibaba-inc.com>
To: "'Wang, Yalin'" <Yalin.Wang@sonymobile.com>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
References: <010b01d012ca$05244060$0f6cc120$@alibaba-inc.com> <35FD53F367049845BC99AC72306C23D103E688B313F9@CNBJMBX05.corpusers.net> <35FD53F367049845BC99AC72306C23D103E688B313FA@CNBJMBX05.corpusers.net>
In-Reply-To: <35FD53F367049845BC99AC72306C23D103E688B313FA@CNBJMBX05.corpusers.net>
Subject: Re: [PATCH V3] mm:add VM_BUG_ON_PAGE() for page_mapcount()
Date: Tue, 09 Dec 2014 11:18:32 +0800
Message-ID: <015701d0135e$d1980980$74c81c80$@alibaba-inc.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQI0XVO7dxUm2rGdyITZIyy3a1eXPQGW5/JUAezXh0aboeRt8A==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> This patch add VM_BUG_ON_PAGE() for slab page,
> because _mapcount is an union with slab struct in struct page,
> avoid access _mapcount if this page is a slab page.
> Also remove the unneeded bracket.
> 
> Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
> ---
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>

>  include/linux/mm.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index b464611..a117527 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -449,7 +449,8 @@ static inline void page_mapcount_reset(struct page *page)
> 
>  static inline int page_mapcount(struct page *page)
>  {
> -	return atomic_read(&(page)->_mapcount) + 1;
> +	VM_BUG_ON_PAGE(PageSlab(page), page);
> +	return atomic_read(&page->_mapcount) + 1;
>  }
> 
>  static inline int page_count(struct page *page)
> --
> 2.1.3

