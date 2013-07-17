Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab3GQOVP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 10:21:15 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:45883 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176Ab3GQOVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 10:21:14 -0400
MIME-Version: 1.0
In-Reply-To: <51E69F49.10500@samsung.com>
References: <1373880874-9270-1-git-send-email-ricardo.ribalda@gmail.com>
 <51E65577.7010403@samsung.com> <CAPybu_3Je7+0Qh2OdptncnxC12G15Scad+A3yUeF898sVWKo8w@mail.gmail.com>
 <51E69F49.10500@samsung.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Wed, 17 Jul 2013 16:20:53 +0200
Message-ID: <CAPybu_0b9ADaUFFHuw=tKkVR4fiu9bGNJVgy4MGbuE-zAA9sZQ@mail.gmail.com>
Subject: Re: [PATCH] videobuf2-dma-sg: Minimize the number of dma segments
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Pawel Osciak <pawel@osciak.com>, Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again Marek

In my system I am doing the scatter gather compaction on device
driver... But I agree that it would be better done on the vb2 layer.

For the oversize sglist we could do one of this two things.

If we want to have a simple pass processing we have to allocate an
structure A for the worts case, work on that structure. then allocate
a structure B for the exact size that we need, memcpy A to B, and
free(A).

Otherwise we need two passes. One to allocate the pages, and another
one to allocate the pages and find out the amount of sg, and another
to greate the sg structure.

What do you prefer?


Regards!




On Wed, Jul 17, 2013 at 3:42 PM, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
> Hello,
>
>
> On 7/17/2013 11:43 AM, Ricardo Ribalda Delgado wrote:
>>
>> Hi Marek
>>
>>   alloc_pages_exact returns pages of order 0, every single page is
>> filled into buf->pages, that then is used by vb2_dma_sg_mmap(), that
>> also expects order 0 pages (its loops increments in PAGE_SIZE). The
>> code has been tested on real HW.
>>
>> Your concern is that that alloc_pages_exact splits the higher order pages?
>>
>> Do you want that videobuf2-dma-sg to have support for higher order pages?
>
>
> Ah... My fault. I didn't notice that you recalculate req_pages at the
> begginning of each loop iteration, so the code is correct, buf->pages is
> filled correctly with order 0 pages.
>
> So now the only issue I see is the oversized sglist allocation (the size
> of sg list is computed for worst case, 0 order pages) and lack of the max
> segment size support. Sadly there are devices which can handle single sg
> chunk up to some predefined size (see dma_get_max_seg_size() function).
>
> For some reference code, please check __iommu_map_sg() and maybe
> __iommu_alloc_buffer() functions in arch/arm/mm/dma-mapping.c
>
>
> Best regards
> --
> Marek Szyprowski
> Samsung R&D Institute Poland
>
>



-- 
Ricardo Ribalda
