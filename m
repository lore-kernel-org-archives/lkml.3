Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624AbaFEHYG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 03:24:06 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:50074 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbaFEHYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 03:24:04 -0400
MIME-Version: 1.0
In-Reply-To: <CAF6AEGvLJeF4QVXkTh2YLLePqQ4h4j+igixeX5HL8o=x4S=CuQ@mail.gmail.com>
References: <alpine.LRH.2.00.1406041450310.21286@lnfm1.sai.msu.ru>
	<CAF6AEGvLJeF4QVXkTh2YLLePqQ4h4j+igixeX5HL8o=x4S=CuQ@mail.gmail.com>
Date: Thu, 5 Jun 2014 09:24:02 +0200
X-Google-Sender-Auth: KBCSWLl35EV5cz9PH7gmFQcYgYk
Message-ID: <CAMuHMdUCjC8mceiAJpmEHo1jufa1FXNfBxaP9EiFS+uTO=SJCQ@mail.gmail.com>
Subject: Re: [PATCH] gpu: drm: msm: Replace type of paddr to uint32_t.
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rob Clark <robdclark@gmail.com>
Cc: "Matwey V. Kornilov" <matwey@sai.msu.ru>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        David Airlie <airlied@linux.ie>, linux-arm-msm@vger.kernel.org,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        matwey.kornilov@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2014 at 2:05 AM, Rob Clark <robdclark@gmail.com> wrote:
> On Wed, Jun 4, 2014 at 6:54 AM, Matwey V. Kornilov <matwey@sai.msu.ru> wrote:
>> From e7147352639fd8f92b1cc85cff9bc5046c7a2130 Mon Sep 17 00:00:00 2001
>> From: "Matwey V. Kornilov" <matwey.kornilov@gmail.com>
>> Date: Mon, 2 Jun 2014 20:17:29 +0400
>> Subject: [PATCH] Replace type of paddr to uint32_t.
>>
>> This patch helps to avoid the following build issue:
>>
>> drivers/gpu/drm/msm/msm_fbdev.c:108:2: error: passing argument 3 of
>> 'msm_gem_get_iova_locked' from incompatible pointer type [-Werror]
>>   msm_gem_get_iova_locked(fbdev->bo, 0, &paddr);
>>   ^
>> In file included from drivers/gpu/drm/msm/msm_fbdev.c:18:0:
>> drivers/gpu/drm/msm/msm_drv.h:153:5: note: expected 'uint32_t *' but
>> argument is of type 'dma_addr_t *'
>>  int msm_gem_get_iova_locked(struct drm_gem_object *obj, int id,
>>      ^
>>
>> Signed-off-by: Matwey V. Kornilov <matwey@sai.msu.ru>
>
> Reviewed-by: Rob Clark <robdclark@gmail.com>

Perhaps the uint32_t should become dma_addr_t instead?

drivers/gpu/drm/msm/msm_gem.h has:

        struct {
                // XXX
                uint32_t iova;
        } domain[NUM_DOMAINS];

(note the "XXX").

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
