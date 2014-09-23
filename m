Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbaIWIFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 04:05:46 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:46934 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbaIWIFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 04:05:42 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-1e-542129d22ef7
Message-id: <542129D0.1040808@samsung.com>
Date: Tue, 23 Sep 2014 10:05:36 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.1
MIME-version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-mm-sig@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Michal Nazarewicz <mina86@mina86.com>,
        Grant Likely <grant.likely@linaro.org>,
        Laura Abbott <lauraa@codeaurora.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v2 0/3] CMA & device tree, another approach
References: <1410434561-9294-1-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1410434561-9294-1-git-send-email-m.szyprowski@samsung.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsVy+t/xq7qXNBVDDBa/U7aYs34Nm8XfScfY
	LQ782cFosbK7mc1i57p3jBZnm96wW2zvnMFu8eXKQyaLTY+vsVpc3jWHzWLB8RZWB26P378m
	MXpc7utl8uh6e4XJ4861PWweJ2b8ZvHYvKTe4/a/x8we6/68YvLo27KK0ePzJrkArigum5TU
	nMyy1CJ9uwSujI9XHjAXHBGtWH56NnMD42zBLkYODgkBE4nHK9i6GDmBTDGJC/fWg9lCAksZ
	JXadD4WwPzFK3DtYBGLzCmhJnOnoZgVpZRFQlejYmA8SZhMwlOh62wXWKioQI7H04x4WiHJB
	iR+T74HZIgK6Eque72LuYuTiYBb4zSSxYPEhsAZhAXuJW319TBC73CUu7t4AFucU8JCY/G0S
	O4jNLGAm8eXlYVYIW15i85q3zBMYBWYh2TELSdksJGULGJlXMYqmliYXFCel5xrqFSfmFpfm
	pesl5+duYoREzpcdjIuPWR1iFOBgVOLh9VijECLEmlhWXJl7iFGCg1lJhLdfUTFEiDclsbIq
	tSg/vqg0J7X4ECMTB6dUA2O1oztPnJWMiCuzYciZKF3/11Muz5vM6+C7umrBW2O2tg8MHIyr
	joT+EI6xX990LXjZgykN8h5SS/5yuOiwNrqYFPVtF5JS75LonH94ia00/6ZlJ0obH5Q8v1mq
	v/bZ4bg3JztLWZXnfBEq9BfIf3rZ35zv6MwQk5nlCxzmyrNOexTd7djUo8RSnJFoqMVcVJwI
	AOGT+vB6AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On 2014-09-11 13:22, Marek Szyprowski wrote:
> Hello,
>
> This is another approach to finish support for reserved memory regions
> defined in device tree. Previous attempts
> (http://lists.linaro.org/pipermail/linaro-mm-sig/2014-February/003738.html
> and https://lkml.org/lkml/2014/7/14/108) ended in merging parts of the
> code and documentation. Merged patches allow to reserve memory, but
> there is still no reserved memory drivers nor any code that actually
> uses reserved memory regions.
>
> The final conclusion from the above mentioned threads is that there is
> no automated reserved memory initialization. All drivers that want to
> use reserved memory, should initialize it on their own.
>
> This patch series provides two driver for reserved memory regions (one
> based on CMA and one based on dma_coherent allocator). The main
> improvement comparing to the previous version is removal of automated
> reserved memory for every device and support for named memory regions.
>
> Those patches are for merging, rebased on top of recent linux-next tree.

Andrew: could you take those patches to your "next" branch together with
other CMA-related changes that are already there?

> Best regards
> Marek Szyprowski
> Samsung R&D Institute Poland
>
> Changes since v1 (https://lkml.org/lkml/2014/8/26/339):
> - removed patches for named reserved regions - they will be discussed
>    separately
> - added a check for 'no-map' property to dma coherent allocator
>    (suggested by Laura Abbott)
> - removed example code for s5p-mfc driver
>
> Changes since '[PATCH v2 RESEND 0/4] CMA & device tree, once again' version:
> (https://lkml.org/lkml/2014/7/14/108)
> - added return error value to of_reserved_mem_device_init()
> - added support for named memory regions (so more than one region can be
>    defined per device)
> - added usage example - converted custom reserved memory code used by
>    s5p-mfc driver to the generic reserved memory handling code
>
> Patch summary:
>
> Marek Szyprowski (3):
>    drivers: of: add return value to of_reserved_mem_device_init
>    drivers: dma-coherent: add initialization from device tree
>    drivers: dma-contiguous: add initialization from device tree
>
>   drivers/base/dma-coherent.c     | 145 ++++++++++++++++++++++++++++++++++------
>   drivers/base/dma-contiguous.c   |  71 ++++++++++++++++++++
>   drivers/of/of_reserved_mem.c    |   3 +-
>   include/linux/cma.h             |   3 +
>   include/linux/of_reserved_mem.h |   9 ++-
>   mm/cma.c                        |  62 ++++++++++++++---
>   6 files changed, 259 insertions(+), 34 deletions(-)
>

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

