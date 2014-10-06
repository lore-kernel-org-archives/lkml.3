Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbaJFOHw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 10:07:52 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52240 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbaJFOHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 10:07:41 -0400
Message-ID: <5432A229.70309@codeaurora.org>
Date: Mon, 06 Oct 2014 07:07:37 -0700
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Heesub Shin <heesub.shin@samsung.com>, Pintu Kumar <pintu.k@samsung.com>,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        john.stultz@linaro.org, rebecca@android.com, ccross@android.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
CC: iqbal.ams@samsung.com, pintu_agarwal@yahoo.com, vishnu.ps@samsung.com
Subject: Re: [PATCH 1/1] [ion]: system-heap use PAGE_ALLOC_COSTLY_ORDER for
 high order
References: <1412584263-22531-1-git-send-email-pintu.k@samsung.com> <54326EAF.8060004@samsung.com>
In-Reply-To: <54326EAF.8060004@samsung.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/6/2014 3:27 AM, Heesub Shin wrote:
> Hello Kumar,
>
> On 10/06/2014 05:31 PM, Pintu Kumar wrote:
>> The Android ion_system_heap uses allocation fallback mechanism
>> based on 8,4,0 order pages available in the system.
>> It changes gfp flags based on higher order allocation request.
>> This higher order value is hard-coded as 4, instead of using
>> the system defined higher order value.
>> Thus replacing this hard-coded value with PAGE_ALLOC_COSTLY_ORDER
>> which is defined as 3.
>> This will help mapping the higher order request in system heap with
>> the actual allocation request.
>
> Quite reasonable.
>
> Reviewed-by: Heesub Shin <heesub.shin@samsung.com>
>
> BTW, Anyone knows how the allocation order (8,4 and 0) was decided? I
> think only Google guys might know the answer.
>
> regards,
> heesub
>

My understanding was this was completely unrelated to the costly order
and was related to the page sizes corresponding to IOMMU page sizes
(1MB, 64K, 4K). This won't make a difference for the uncached page
pool case but for the not page pool case, I'm not sure if there would
be a benefit for trying to get 32K pages with some effort vs. just
going back to 4K pages.

Do you have any data/metrics that show a benefit from this patch?

Thanks,
Laura

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
