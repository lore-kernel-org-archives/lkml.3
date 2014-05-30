Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938AbaE3GHM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 02:07:12 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:40839 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbaE3GHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 02:07:10 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-e3-5388200bbdef
Message-id: <5388200F.7000201@samsung.com>
Date: Fri, 30 May 2014 08:07:11 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Laura Abbott <lauraa@codeaurora.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Nazarewicz <mina86@mina86.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH] CMA: correct unlock target
References: <1401344958-3790-1-git-send-email-iamjoonsoo.kim@lge.com>
 <5386E313.6070705@samsung.com> <53874AB5.5010908@codeaurora.org>
In-reply-to: <53874AB5.5010908@codeaurora.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t/xq7rcCh3BBmcb+C1WdjezWWzvnMFu
	senxNVaLy7vmsFncvsxrseB4C6sDm0dLcw+bx+W+XiaPrrdXmDw2L6n3WPfnFZPH501yAWxR
	XDYpqTmZZalF+nYJXBltx2azF/zgqdjy7TZzA+MLzi5GDg4JAROJ7TPtuxg5gUwxiQv31rN1
	MXJxCAksZZSY9XMdE4TziVFi1bm/jCBVvAJaEqfuvmEDsVkEVCXeLu9gArHZBAwlut52gcVF
	BWIkdn9eCFUvKPFj8j0WEFtEwE9i99Vr7CBDmQWWMEpc6lzHDpIQFtCX+HFnHzvEtg5GickL
	b4N1cAroSTT8ecYKYjMLmEk8alnHDGHLS2xe85Z5AqPALCRLZiEpm4WkbAEj8ypG0dTS5ILi
	pPRcQ73ixNzi0rx0veT83E2MkCD/soNx8TGrQ4wCHIxKPLyZLu3BQqyJZcWVuYcYJTiYlUR4
	sx4AhXhTEiurUovy44tKc1KLDzEycXBKNTCy/lh2fsGpsLYF1UYvLbXjMzgcXqZbXp78K7ld
	1c0nyGrD0Y0lKe2BbbnNJWYaajferP33uO/Nf+Giyr+zHq+KCptie3ai5jvWI5qZXNs/Ftxq
	MWh9ViV4PVqbzdzLd6rlnXt3QraWnxaTnPFBVvz0znnmfcdleau/vmT/1z4/1PD03z0cu4qV
	WIozEg21mIuKEwF+RuJ8UAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-05-29 16:56, Laura Abbott wrote:
> On 5/29/2014 12:34 AM, Marek Szyprowski wrote:
> > Hello,
> >
> > On 2014-05-29 08:29, Joonsoo Kim wrote:
> >> 'cma: Remove potential deadlock situation' introduces per cma area mutex
> >> for bitmap management. It is good, but there is one mistake. When we
> >> can't find appropriate area in bitmap, we release cma_mutex global lock
> >> rather than cma->lock and this is a bug. So fix it.
> >>
> >> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> >
> > Thanks for spotting this issue. I've added it to my tree.
> >
> >> diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
> >> index 6f6bffc..83969f8 100644
> >> --- a/drivers/base/dma-contiguous.c
> >> +++ b/drivers/base/dma-contiguous.c
> >> @@ -331,7 +331,7 @@ struct page *dma_alloc_from_contiguous(struct device *dev, int count,
> >>           pageno = bitmap_find_next_zero_area(cma->bitmap, cma->count,
> >>                               start, count, mask);
> >>           if (pageno >= cma->count) {
> >> -            mutex_unlock(&cma_mutex);
> >> +            mutex_unlock(&cma->lock);
> >>               break;
> >>           }
> >>           bitmap_set(cma->bitmap, pageno, count);
> >
> > Best regards
>
> Acked-by: Laura Abbott <lauraa@codeaurora.org>
>
> Who actually ended up picking up that patch? I sent it out but didn't realize it had been
> picked up.

I've taken it to my dma-mapping tree some time ago, I think that
I've replied to the original mail with information about taking it.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

