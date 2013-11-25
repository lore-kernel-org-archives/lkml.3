Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab3KYKq7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 05:46:59 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:27645 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab3KYKq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 05:46:56 -0500
X-AuditID: cbfec7f4-b7fea6d0000026ac-c2-52932a9dc666
Message-id: <52932A9D.3050305@samsung.com>
Date: Mon, 25 Nov 2013 11:46:53 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101
 Thunderbird/24.1.1
MIME-version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] CMA: Fix the phys_addr_t print types
References: <1385264221-29952-1-git-send-email-santosh.shilimkar@ti.com>
 <20131124034426.GB3873@kroah.com> <52917661.6050005@ti.com>
 <20131124041056.GA7415@kroah.com> <52918071.10408@ti.com>
In-reply-to: <52918071.10408@ti.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGLMWRmVeSWpSXmKPExsVy+t/xq7pztSYHGTSfU7JoXryezWLT42us
	Fpd3zWGzeN23htmBxWP/3DXsHpuX1Hscv7GdyePzJrkAligum5TUnMyy1CJ9uwSujIlX/Que
	8FV82/qKvYHxMXcXIyeHhICJxNbPU5ghbDGJC/fWs3UxcnEICSxllOhaOJMJJCEk8IlRYsFU
	MRCbV0BL4kjjR3YQm0VAVeJA/2Qwm03AUKLrbRdQMweHqECoxPc7IRDlghI/Jt9jAbFFBJIl
	Vp1uAxvJLOAmcXv9PLC9wgKWEvtfL2aGWHWIUaLlWBqIzSmgIrHjxQeoejOJRy3rmCFseYnN
	a94yT2AUmIVkxSwkZbOQlC1gZF7FKJpamlxQnJSea6hXnJhbXJqXrpecn7uJERK2X3YwLj5m
	dYhRgINRiYfXonJSkBBrYllxZS7QMRzMSiK8+SqTg4R4UxIrq1KL8uOLSnNSiw8xMnFwSjUw
	BhbtrNS8qnGv+PsXdfWS9w9UZiYc6zK3eRVg0NHbk8q462Nuwh7VDJa5+59H63sddNaT37h/
	6tWXIUsag+5EC+878KJbci+78F7e/8afnPefe8NRKnjC8/Df1q123pOEXnVN37CAl+VJYO5L
	vUWcCvfmHU+amzdtHeNBm7Rz6XJ/9gtbqG4vU2Ipzkg01GIuKk4EAPnKXOs5AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 2013-11-24 05:28, Santosh Shilimkar wrote:
> On Saturday 23 November 2013 11:10 PM, Greg Kroah-Hartman wrote:
> > On Sat, Nov 23, 2013 at 10:45:37PM -0500, Santosh Shilimkar wrote:
> >> On Saturday 23 November 2013 10:44 PM, Greg Kroah-Hartman wrote:
> >>> On Sat, Nov 23, 2013 at 10:37:01PM -0500, Santosh Shilimkar wrote:
> >>>> @@ -250,8 +249,8 @@ int __init dma_contiguous_reserve_area(phys_addr_t size, phys_addr_t base,
> >>>>  	*res_cma = cma;
> >>>>  	cma_area_count++;
> >>>>
> >>>> -	pr_info("CMA: reserved %ld MiB at %08lx\n", (unsigned long)size / SZ_1M,
> >>>> -		(unsigned long)base);
> >>>> +	pr_info("CMA: reserved %ld MiB at %pa\n", (unsigned long)size / SZ_1M,
> >>>> +		&base);
> >>>
> >>> Why is this pr_info() at all?  That's just noise, please move it to
> >>> pr_debug().
> >>>
> >> Marek can comment better but I think its useful print to know CMA
> >> reserved memory size.
> >
> > Useful to who?
> >
> Useful to anyone wants to know the CMA usage on a platform.
> CMA size is configurable and platforms tend to use different sizes
> based on needs. The info don't appear in /proc/meminfo, so probably
> dmsg grep is easy enough to know how much CMA memory being used on
> a platform. That was my point.
>
> I don't have strong argument here against not making it pr_debug
> but was waiting for Marek's opinion on it.

If possible I would like to keep pr_info. It already helped me a lot
while analyzing someone's logs to find why memory allocation failed.
A simple search for "CMA" messages enabled me to quickly check if CMA
has been enabled and configured properly or not. It also gives a curious
user some information about the memory configuration (especially if he
don't need CMA, he will investigate why kernel has reserved so much
memory).

Best regards
-- 
Marek Szyprowski
Samsung R&D Institute Poland

