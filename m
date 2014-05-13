Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942AbaEME5J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 00:57:09 -0400
Received: from bay0-omc3-s28.bay0.hotmail.com ([65.54.190.166]:9837 "EHLO
	bay0-omc3-s28.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751949AbaEME5H convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 00:57:07 -0400
X-TMN: [c80a0ZSJF/lc8l77zyZg08bYVmW5qkZl]
X-Originating-Email: [pintu.k@outlook.com]
Message-ID: <BAY169-W1F113CF53FD2DD325B23BEF340@phx.gbl>
From: Pintu Kumar <pintu.k@outlook.com>
To: Laura Abbott <lauraa@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>
Subject: RE: Questions regarding DMA buffer sharing using IOMMU
Date: Tue, 13 May 2014 10:27:07 +0530
Importance: Normal
In-Reply-To: <5370F66F.7060204@codeaurora.org>
References: <BAY169-W12541AD089785F8BFBD4E26EF350@phx.gbl>,<5218408.5YRJXjS4BX@wuerfel>
 <BAY169-W1156E6803829CAB545274BCEF350@phx.gbl>,<5370F66F.7060204@codeaurora.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 13 May 2014 04:57:07.0442 (UTC) FILETIME=[CA758520:01CF6E67]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Lauraa for your answers.
I have few more queries below. 

----------------------------------------
> Date: Mon, 12 May 2014 09:27:27 -0700
> From: lauraa@codeaurora.org
> To: pintu.k@outlook.com; arnd@arndb.de; linux-arm-kernel@lists.infradead.org
> CC: linux-mm@kvack.org; linux-kernel@vger.kernel.org; linaro-mm-sig@lists.linaro.org
> Subject: Re: Questions regarding DMA buffer sharing using IOMMU
>
> On 5/12/2014 7:37 AM, Pintu Kumar wrote:
>> Hi,
>> Thanks for the reply.
>>
>> ----------------------------------------
>>> From: arnd@arndb.de
>>> To: linux-arm-kernel@lists.infradead.org
>>> CC: pintu.k@outlook.com; linux-mm@kvack.org; linux-kernel@vger.kernel.org; linaro-mm-sig@lists.linaro.org
>>> Subject: Re: Questions regarding DMA buffer sharing using IOMMU
>>> Date: Mon, 12 May 2014 14:00:57 +0200
>>>
>>> On Monday 12 May 2014 15:12:41 Pintu Kumar wrote:
>>>> Hi,
>>>> I have some queries regarding IOMMU and CMA buffer sharing.
>>>> We have an embedded linux device (kernel 3.10, RAM: 256Mb) in
>>>> which camera and codec supports IOMMU but the display does not support IOMMU.
>>>> Thus for camera capture we are using iommu buffers using
>>>> ION/DMABUF. But for all display rendering we are using CMA buffers.
>>>> So, the question is how to achieve buffer sharing (zero-copy)
>>>> between Camera and Display using only IOMMU?
>>>> Currently we are achieving zero-copy using CMA. And we are
>>>> exploring options to use IOMMU.
>>>> Now we wanted to know which option is better? To use IOMMU or CMA?
>>>> If anybody have come across these design please share your thoughts and results.
>>>
>>> There is a slight performance overhead in using the IOMMU in general,
>>> because the IOMMU has to fetch the page table entries from memory
>>> at least some of the time.
>>
>> Ok, we need to check performance later
>>
>>>
>>> If that overhead is within the constraints you have for transfers between
>>> camera and codec, you are always better off using IOMMU since that
>>> means you don't have to do memory migration.
>>
>> Transfer between camera is codec is fine. But our major concern is single buffer
>> sharing between camera & display. Here camera supports iommu but display does not support iommu.
>> Is it possible to render camera preview (iommu buffers) on display (not iommu and required physical contiguous overlay memory)?
>>
>
> I'm pretty sure the answer is no for zero copy IOMMU buffers if one of your
> devices does not support IOMMU. If the data is coming in as individual pages
> and the hardware does not support scattered pages there isn't much you can
> do except copy to a contiguous buffer. At least with Ion, the heap types can
> be set up in a particular way such that the client need never know about the
> existence of an IOMMU or not.

So, the zero copy cannot be achieved between iommu and non-iommu devices?
Do you have any references like in case of QC MSM8974/etc, how this is achieved?

Yes, we are using ION, with SYSTEM_HEAP, for IOMMU, in case of camera, but still we could not 
render the preview on display.
You mean to say, with ION it is possible to do buffer sharing(a.k.a zero copy)  using the IOMMU heap?


>
>> Also is it possible to buffer sharing between 2 iommu supported devices?
>>
>
> I don't see why not but there isn't a lot of information to go on here.

Is this also possible with ION?
Can you point out some use cases?
Like in our cases camera, codec and GPU have IOMMU. Is it possible to do zero copy here?


>
> Thanks,
> Laura
>
> --
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> hosted by The Linux Foundation
 		 	   		  