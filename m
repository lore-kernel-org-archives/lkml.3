Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbaEAHPD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 03:15:03 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:6399 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbaEAHPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 03:15:00 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 01 May 2014 00:09:22 -0700
Message-ID: <5361F470.5050306@nvidia.com>
Date: Thu, 1 May 2014 16:14:56 +0900
From: Alexandre Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ben Skeggs <skeggsb@gmail.com>
CC: Ben Skeggs <bskeggs@redhat.com>, Alexandre Courbot <gnurou@gmail.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v3 0/9] drm/nouveau: support for GK20A, cont'd
References: <1398410396-23338-1-git-send-email-acourbot@nvidia.com> <CACAvsv5x6uZcTGUTa3-wBRo0sJ-557sJ_d8r0kscODhr18yzBA@mail.gmail.com>
In-Reply-To: <CACAvsv5x6uZcTGUTa3-wBRo0sJ-557sJ_d8r0kscODhr18yzBA@mail.gmail.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2014 04:11 PM, Ben Skeggs wrote:
> On Fri, Apr 25, 2014 at 5:19 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
>> Changes since v2:
>> - Enabled software class
>> - Removed unneeded changes to nouveau_accel_init()
>> - Replaced use of architecture-private pfn_to_dma() and dma_to_pfn() with
>>    the portable page_to_phys()/phys_to_page()
> page_to_phys() looks well defined and used everywhere, phys_to_page()
> not so much (including on amd64) :(

Argh, dammit. Now I *really* wonder what one is supposed to use in such 
cases...

Let me come with a v4 then. I will address the other issue with external 
firmware at the same time.

Sorry for the inconvenience.

>
>> - Fixed incorrect comment/commit log talking about bytes instead of words
>>
>> Hope this looks good! Once this gets merged the next set will be to use this
>> driver on Jetson and Venice2 boards.
>>
>> Cheers,
>>
>> Alexandre Courbot (9):
>>    drm/nouveau/bar: only ioremap BAR3 if it exists
>>    drm/nouveau/bar/nvc0: support chips without BAR3
>>    drm/nouveau/ibus: add GK20A support
>>    drm/nouveau/fb: add GK20A support
>>    drm/nouveau/fifo: add GK20A support
>>    drm/nouveau/graph: enable when using external firmware
>>    drm/nouveau/graph: pad firmware code at load time
>>    drm/nouveau/graph: add GK20A support
>>    drm/nouveau: support for probing GK20A
>>
>>   drivers/gpu/drm/nouveau/Makefile                   |   6 +
>>   drivers/gpu/drm/nouveau/core/engine/device/nve0.c  |  17 +++
>>   drivers/gpu/drm/nouveau/core/engine/fifo/gk20a.c   |  35 +++++
>>   drivers/gpu/drm/nouveau/core/engine/fifo/nve0.h    |   1 +
>>   .../gpu/drm/nouveau/core/engine/graph/ctxgk20a.c   |  53 +++++++
>>   .../gpu/drm/nouveau/core/engine/graph/ctxnvc0.h    |   9 ++
>>   .../gpu/drm/nouveau/core/engine/graph/ctxnve4.c    |  14 +-
>>   drivers/gpu/drm/nouveau/core/engine/graph/gk20a.c  |  47 ++++++
>>   drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c   |  13 +-
>>   drivers/gpu/drm/nouveau/core/engine/graph/nvc0.h   |   2 +
>>   drivers/gpu/drm/nouveau/core/engine/graph/nve4.c   |   4 +-
>>   drivers/gpu/drm/nouveau/core/include/engine/fifo.h |   1 +
>>   .../gpu/drm/nouveau/core/include/engine/graph.h    |   1 +
>>   drivers/gpu/drm/nouveau/core/include/subdev/fb.h   |   1 +
>>   drivers/gpu/drm/nouveau/core/include/subdev/ibus.h |   1 +
>>   drivers/gpu/drm/nouveau/core/subdev/bar/base.c     |   6 +-
>>   drivers/gpu/drm/nouveau/core/subdev/bar/nvc0.c     | 114 +++++++-------
>>   drivers/gpu/drm/nouveau/core/subdev/fb/gk20a.c     |  56 +++++++
>>   drivers/gpu/drm/nouveau/core/subdev/fb/priv.h      |   1 +
>>   drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c  | 167 +++++++++++++++++++++
>>   drivers/gpu/drm/nouveau/core/subdev/ibus/gk20a.c   | 103 +++++++++++++
>>   21 files changed, 583 insertions(+), 69 deletions(-)
>>   create mode 100644 drivers/gpu/drm/nouveau/core/engine/fifo/gk20a.c
>>   create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/ctxgk20a.c
>>   create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/gk20a.c
>>   create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/gk20a.c
>>   create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c
>>   create mode 100644 drivers/gpu/drm/nouveau/core/subdev/ibus/gk20a.c
>>
>> --
>> 1.9.2
>>
>> _______________________________________________
>> dri-devel mailing list
>> dri-devel@lists.freedesktop.org
>> http://lists.freedesktop.org/mailman/listinfo/dri-devel

