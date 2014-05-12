Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674AbaELOhP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 10:37:15 -0400
Received: from bay0-omc1-s14.bay0.hotmail.com ([65.54.190.25]:59109 "EHLO
	bay0-omc1-s14.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758627AbaELOhK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 10:37:10 -0400
X-TMN: [XDT09WmwHjnjb92MHI3EjYwoF+H0euti]
X-Originating-Email: [pintu.k@outlook.com]
Message-ID: <BAY169-W1156E6803829CAB545274BCEF350@phx.gbl>
From: Pintu Kumar <pintu.k@outlook.com>
To: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>
Subject: RE: Questions regarding DMA buffer sharing using IOMMU
Date: Mon, 12 May 2014 20:07:10 +0530
Importance: Normal
In-Reply-To: <5218408.5YRJXjS4BX@wuerfel>
References: <BAY169-W12541AD089785F8BFBD4E26EF350@phx.gbl>,<5218408.5YRJXjS4BX@wuerfel>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 12 May 2014 14:37:10.0077 (UTC) FILETIME=[A8086ED0:01CF6DEF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Thanks for the reply.

----------------------------------------
> From: arnd@arndb.de
> To: linux-arm-kernel@lists.infradead.org
> CC: pintu.k@outlook.com; linux-mm@kvack.org; linux-kernel@vger.kernel.org; linaro-mm-sig@lists.linaro.org
> Subject: Re: Questions regarding DMA buffer sharing using IOMMU
> Date: Mon, 12 May 2014 14:00:57 +0200
>
> On Monday 12 May 2014 15:12:41 Pintu Kumar wrote:
>> Hi,
>> I have some queries regarding IOMMU and CMA buffer sharing.
>> We have an embedded linux device (kernel 3.10, RAM: 256Mb) in
>> which camera and codec supports IOMMU but the display does not support IOMMU.
>> Thus for camera capture we are using iommu buffers using
>> ION/DMABUF. But for all display rendering we are using CMA buffers.
>> So, the question is how to achieve buffer sharing (zero-copy)
>> between Camera and Display using only IOMMU?
>> Currently we are achieving zero-copy using CMA. And we are
>> exploring options to use IOMMU.
>> Now we wanted to know which option is better? To use IOMMU or CMA?
>> If anybody have come across these design please share your thoughts and results.
>
> There is a slight performance overhead in using the IOMMU in general,
> because the IOMMU has to fetch the page table entries from memory
> at least some of the time.

Ok, we need to check performance later

>
> If that overhead is within the constraints you have for transfers between
> camera and codec, you are always better off using IOMMU since that
> means you don't have to do memory migration.

Transfer between camera is codec is fine. But our major concern is single buffer 
sharing between camera & display. Here camera supports iommu but display does not support iommu.
Is it possible to render camera preview (iommu buffers) on display (not iommu and required physical contiguous overlay memory)?

Also is it possible to buffer sharing between 2 iommu supported devices?

>
> Note however, that we don't have a way to describe IOMMU relations
> to devices in DT, so whatever you come up with to do this will most
> likely be incompatible with what we do in future kernel versions.
>
> Arnd
 		 	   		  