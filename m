Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbaL3KCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 05:02:51 -0500
Received: from mail-oi0-f48.google.com ([209.85.218.48]:37128 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbaL3KCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 05:02:49 -0500
MIME-Version: 1.0
In-Reply-To: <20141230044826.GC4588@js1304-P5Q-DELUXE>
References: <1419500608-11656-1-git-send-email-zhuhui@xiaomi.com>
 <1419500608-11656-2-git-send-email-zhuhui@xiaomi.com> <20141230044826.GC4588@js1304-P5Q-DELUXE>
From: Hui Zhu <teawater@gmail.com>
Date: Tue, 30 Dec 2014 18:02:09 +0800
Message-ID: <CANFwon3U+chGmvLG_HdMf5_0Mb5OEEJSOUr+oPB5+US3rnfguA@mail.gmail.com>
Subject: Re: [PATCH 1/3] CMA: Fix the bug that CMA's page number is
 substructed twice
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Hui Zhu <zhuhui@xiaomi.com>, m.szyprowski@samsung.com, mina86@mina86.com,
        Andrew Morton <akpm@linux-foundation.org>,
        aneesh.kumar@linux.vnet.ibm.com, pintu.k@samsung.com,
        weijie.yang@samsung.com, mgorman@suse.de, hannes@cmpxchg.org,
        Rik van Riel <riel@redhat.com>, vbabka@suse.cz,
        laurent.pinchart+renesas@ideasonboard.com, rientjes@google.com,
        sasha.levin@oracle.com, liuweixing@xiaomi.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 30, 2014 at 12:48 PM, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> On Thu, Dec 25, 2014 at 05:43:26PM +0800, Hui Zhu wrote:
>> In Joonsoo's CMA patch "CMA: always treat free cma pages as non-free on
>> watermark checking" [1], it changes __zone_watermark_ok to substruct CMA
>> pages number from free_pages if system use CMA:
>>       if (IS_ENABLED(CONFIG_CMA) && z->managed_cma_pages)
>>               free_pages -= zone_page_state(z, NR_FREE_CMA_PAGES);
>
> Hello,
>
> In fact, without that patch, watermark checking has a problem in current kernel.
> If there is reserved CMA region, watermark check for high order
> allocation is done loosly. See following thread.
>
> https://lkml.org/lkml/2014/5/30/320
>
> Your patch can fix this situation, so, how about submitting this patch
> separately?
>
> Thanks.
>

Hi Joonsoo,

Thanks for your remind.  I will post a separate patch for current kernel.

Thanks,
Hui
