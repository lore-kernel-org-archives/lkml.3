Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265AbaJGQTF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 12:19:05 -0400
Received: from mail-oi0-f41.google.com ([209.85.218.41]:44220 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbaJGQTD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 12:19:03 -0400
MIME-Version: 1.0
In-Reply-To: <02b901cfe248$da28bfa0$8e7a3ee0$@samsung.com>
References: <1689163249.303621412612771982.JavaMail.weblogic@epmlwas07b>
	<CAMbhsRSiA=yo21EHBZX96sq+EPKkjSHrnMqN-02kzWe8pHjkqA@mail.gmail.com>
	<02b901cfe248$da28bfa0$8e7a3ee0$@samsung.com>
Date: Tue, 7 Oct 2014 09:19:02 -0700
X-Google-Sender-Auth: OQ4It0wSU_70ohmzG21MnF6aJ30
Message-ID: <CAMbhsRTxHRkvRxhvfum9NVoUOvv3EAq3W+rF_Dy-s=aRdiSEtg@mail.gmail.com>
Subject: Re: Re: [PATCH 1/1] [ion]: system-heap use PAGE_ALLOC_COSTLY_ORDER
 for high order
From: Colin Cross <ccross@android.com>
To: PINTU KUMAR <pintu.k@samsung.com>
Cc: Laura Abbott <lauraa@codeaurora.org>,
        Heesub Shin <heesub.shin@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Rebecca Zavin <rebecca@android.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        lkml <linux-kernel@vger.kernel.org>,
        IQBAL SHAREEF <iqbal.ams@samsung.com>,
        "pintu_agarwal@yahoo.com" <pintu_agarwal@yahoo.com>,
        Vishnu Pratap Singh <vishnu.ps@samsung.com>,
        "cpgs@samsung.com" <cpgs@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 7, 2014 at 9:07 AM, PINTU KUMAR <pintu.k@samsung.com> wrote:
> ----- Original Message -----
>> From: Colin Cross <ccross@android.com>
>> To: pintu.k@samsung.com
>> Cc: Laura Abbott <lauraa@codeaurora.org>; Heesub Shin <heesub.shin@samsung.com>; "akpm@linux-foundation.org" <akpm@linux-foundation.org>; "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>; "john.stultz@linaro.org" <john.stultz@linaro.org>; "rebecca@android.com" <rebecca@android.com>; "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>; "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>; IQBAL SHAREEF <iqbal.ams@samsung.com>; "pintu_agarwal@yahoo.com" <pintu_agarwal@yahoo.com>; Vishnu Pratap Singh <vishnu.ps@samsung.com>; "cpgs@samsung.com" <cpgs@samsung.com>
>> Sent: Monday, 6 October 2014 11:01 PM
>> Subject: Re: Re: [PATCH 1/1] [ion]: system-heap use PAGE_ALLOC_COSTLY_ORDER for high order
>>
>> On Mon, Oct 6, 2014 at 9:26 AM, PINTU KUMAR <pintu.k@samsung.com> wrote:
>>
>>>
>>> Hi,
>>> >________________________________
>>> > From: Laura Abbott <lauraa@codeaurora.org>
>>> >To: Heesub Shin <heesub.shin@samsung.com>; Pintu Kumar
>> <pintu.k@samsung.com>; akpm@linux-foundation.org;
>> gregkh@linuxfoundation.org; john.stultz@linaro.org; rebecca@android.com;
>> ccross@android.com; devel@driverdev.osuosl.org; linux-kernel@vger.kernel.org
>>> >Cc: iqbal.ams@samsung.com; pintu_agarwal@yahoo.com;
>> vishnu.ps@samsung.com
>>> >Sent: Monday, 6 October 2014 7:37 PM
>>> >Subject: Re: [PATCH 1/1] [ion]: system-heap use PAGE_ALLOC_COSTLY_ORDER
>> for high order
>>> >
>>> >
>>> >On 10/6/2014 3:27 AM, Heesub Shin wrote:
>>> >
>>> >
>>> >
>>> >
>>> >> Hello Kumar,
>>> >>
>>> >> On 10/06/2014 05:31 PM, Pintu Kumar wrote:
>>> >>> The Android ion_system_heap uses allocation fallback mechanism
>>> >>> based on 8,4,0 order pages available in the system.
>>> >>> It changes gfp flags based on higher order allocation request.
>>> >>> This higher order value is hard-coded as 4, instead of using
>>> >>> the system defined higher order value.
>>> >>> Thus replacing this hard-coded value with
>> PAGE_ALLOC_COSTLY_ORDER
>>> >>> which is defined as 3.
>>> >>> This will help mapping the higher order request in system heap
>> with
>>> >>> the actual allocation request.
>>> >>
>>> >> Quite reasonable.
>>> >>
>>> >> Reviewed-by: Heesub Shin <heesub.shin@samsung.com>
>>> >>
>>> >> BTW, Anyone knows how the allocation order (8,4 and 0) was
>> decided? I
>>> >> think only Google guys might know the answer.
>>> >>
>>> >> regards,
>>> >> heesub
>>> >>
>>> >
>>> >My understanding was this was completely unrelated to the costly order
>>> >and was related to the page sizes corresponding to IOMMU page sizes
>>> >(1MB, 64K, 4K). This won't make a difference for the uncached page
>>> >pool case but for the not page pool case, I'm not sure if there
>> would
>>> >be a benefit for trying to get 32K pages with some effort vs. just
>>> >going back to 4K pages.
>>>
>>> No, it is not just related to IOMMU case. It comes into picture also for
>>> normal system-heap allocation (without iommu cases).
>>> Also, it is applicable for both uncached and page_pool cases.
>>> Please also check the changes under ion_system_heap_create.
>>> Here the gfp_flags are set under the pool structure.
>>> This value is used in ion_page_pool_alloc_pages.
>>> In both the cases, it internally calls alloc_pages, with this gfp_flags.
>>> Now, during memory pressure scenario, when alloc_pages moves to slowpath
>>> this gfp_flags will be used to decide allocation retry.
>>> In the current code, the higher-order flag is set only when order is
>> greater than 4.
>>> But, in MM, the order 4 is also considered as higher-order request.
>>> This higher-order is decided based on PAGE_ALLOC_COSTLY_ORDER (3) value.
>>> Hence, I think this value should be in sync with the MM code.
>>> >
>>> >Do you have any data/metrics that show a benefit from this patch?
>>> I think it is not related to any data or metrics.
>>> It is about replacing the hard-coded higher-order check to be in sync with
>>> the MM code.
>>>
>>
>> The selection of the orders used for allocation (8, then 4, then 0) is
>> designed to match with the sizes often found in IOMMUs, but this isn't
>> changing the order of the allocation, it is changing the GFP flags
>> used for the order 4 allocation.  Right now we are using the
>> low_order_gfp_flags for order 4, this patch would change it to use
>> high_order_gfp_flags.  We originally used low_order_gfp_flags here
>> because the MM subsystem can usually satisfy these allocations, and
>> the additional load placed on the MM subsystem to kick off kswapd to
>> free up more order 4 chunks is generally worth it.  Using order 4
>> pages instead of order 0 pages can significantly improve the
>> performance of many IOMMUs by reducing TLB pressure and time spent
>> updating page tables.  Unless you have data showing that this improves
>> something, and doesn't just cause all allocations to be order 0 when
>> under memory pressure, I don't suggest merging this.
>>
>
> Ok agree. It is worth retrying the allocation with order-4 pages.
> But, since 4 is considered higher order for MM and is greater than PAGE_ALLOC_COSTLY_ORDER.
> I guess the retrying will not happen, because of the following check in page_alloc:
> if (order > PAGE_ALLOC_COSTLY_ORDER)
>         goto nopage;

It's not the retry that I'd be particularly worried about, it's
kicking off kswapd, which will run in the background to replenish the
pool of free order 4 pages.  However, when
c654345924f7cce87bb221b89db91cba890421ba (mm: remove __GFP_NO_KSWAPD)
was merged (and then reverted, and then merged again), the
__GFP_NO_KSWAPD flag was removed from high_order_gfp_flags, and when
it was finally reverted again we did not re-add the flag, so we lost
that behavior long ago.
