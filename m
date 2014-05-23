Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbaEWFuE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 01:50:04 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:52848 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbaEWFuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 01:50:01 -0400
MIME-Version: 1.0
In-Reply-To: <20140519083355.GA7138@ulmo>
References: <1400483458-9648-1-git-send-email-acourbot@nvidia.com>
 <1400483458-9648-3-git-send-email-acourbot@nvidia.com> <20140519083355.GA7138@ulmo>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Fri, 23 May 2014 14:49:40 +0900
Message-ID: <CAAVeFuKCx677Uxcu3XNLkU+er-GBAxqdj_hUDUXHwUN+CS5EsA@mail.gmail.com>
Subject: Re: [PATCH 2/4] drm/ttm: introduce dma cache sync helpers
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>, David Airlie <airlied@linux.ie>,
        Ben Skeggs <bskeggs@redhat.com>, Lucas Stach <dev@lynxeye.de>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 5:33 PM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Mon, May 19, 2014 at 04:10:56PM +0900, Alexandre Courbot wrote:
>> From: Lucas Stach <dev@lynxeye.de>
>>
>> On arches with non-coherent PCI,
>
> I guess since this applies to gk20a
>
>> we need to flush caches ourselfes at
>
> "ourselves". Or perhaps even reword to something like: "..., caches need
> to be flushed and invalidated explicitly", since dma_sync_for_cpu() does
> invalidate rather than flush.

Rephrased as "On arches for which access to GPU memory is non-coherent, caches
need to be flushed and invalidated explicitly at the appropriate places."

>
>> the appropriate places. Introduce two small helpers to make things easy
>> for TTM based drivers.
>>
>> Signed-off-by: Lucas Stach <dev@lynxeye.de>
>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>> ---
>>  drivers/gpu/drm/ttm/ttm_tt.c    | 25 +++++++++++++++++++++++++
>>  include/drm/ttm/ttm_bo_driver.h | 28 ++++++++++++++++++++++++++++
>>  2 files changed, 53 insertions(+)
>>
>> diff --git a/drivers/gpu/drm/ttm/ttm_tt.c b/drivers/gpu/drm/ttm/ttm_tt.c
> [...]
>> +void ttm_dma_tt_cache_sync_for_device(struct ttm_dma_tt *ttm_dma,
>> +                                   struct device *dev)
>> +{
>> +     int i;
>
> This should probably be unsigned long to match the type of
> ttm_dma->ttm.num_pages.

Fixed.

Thanks,
Alex.
