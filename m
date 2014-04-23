Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbaDWGLs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 02:11:48 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:65377 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363AbaDWGLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 02:11:22 -0400
MIME-Version: 1.0
In-Reply-To: <53572077.6090305@nvidia.com>
References: <1398060142-7937-1-git-send-email-acourbot@nvidia.com>
 <1398060142-7937-5-git-send-email-acourbot@nvidia.com> <20140422104052.GB22426@ulmo>
 <53572077.6090305@nvidia.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Wed, 23 Apr 2014 15:11:01 +0900
Message-ID: <CAAVeFuKscuN-=HJOarbzFkG1ARq6-Nfc2pf1ibam9b61Cjbs6Q@mail.gmail.com>
Subject: Re: [PATCH v2 04/10] drm/nouveau/fb: add GK20A support
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Thierry Reding <thierry.reding@gmail.com>, Ben Skeggs <bskeggs@redhat.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 11:07 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> On 04/22/2014 07:40 PM, Thierry Reding wrote:
>>
>> * PGP Signed by an unknown key
>>
>>
>> On Mon, Apr 21, 2014 at 03:02:16PM +0900, Alexandre Courbot wrote:
>> [...]
>>>
>>> diff --git a/drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c
>>> b/drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c
>>
>> [...]
>>>
>>> +               pages = dma_alloc_from_contiguous(dev, ncmin, order);
>>> +               if (!pages) {
>>> +                       gk20a_ram_put(pfb, &mem);
>>> +                       return -ENOMEM;
>>> +               }
>>> +
>>> +               dma_addr = pfn_to_dma(nv_device_base(nv_device(pfb)),
>>> +                                     page_to_pfn(pages));
>>
>>
>> This breaks compilation on x86 because neither pfn_to_dma() nor
>> dma_to_pfn() are available. Is there some other way this can be
>> allocated so that these functions don't need to be called?
>
>
> Mmm, this is bad. There is probably another more portable way to do this.
> Let me look for it.

page_to_phys()/phys_to_page() can be used by drivers and will work
just fine here since the CPU and GPU use the same physical addresses
to access memory.

Thanks,
Alex.
