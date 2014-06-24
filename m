Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbaFXKzS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 06:55:18 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:19265 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbaFXKzQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 06:55:16 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 24 Jun 2014 03:49:13 -0700
Message-ID: <53A95910.20104@nvidia.com>
Date: Tue, 24 Jun 2014 19:55:12 +0900
From: Alexandre Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        Lucas Stach <dev@lynxeye.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        "gnurou@gmail.com" <gnurou@gmail.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 2/3] drm/ttm: introduce dma cache sync helpers
References: <1403603667-11302-1-git-send-email-acourbot@nvidia.com> <1403603667-11302-3-git-send-email-acourbot@nvidia.com> <20140624100220.GK32514@n2100.arm.linux.org.uk> <53A953E6.2030503@nvidia.com>
In-Reply-To: <53A953E6.2030503@nvidia.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2014 07:33 PM, Alexandre Courbot wrote:
> On 06/24/2014 07:02 PM, Russell King - ARM Linux wrote:
>> On Tue, Jun 24, 2014 at 06:54:26PM +0900, Alexandre Courbot wrote:
>>> From: Lucas Stach <dev@lynxeye.de>
>>>
>>> On architectures for which access to GPU memory is non-coherent,
>>> caches need to be flushed and invalidated explicitly at the
>>> appropriate places. Introduce two small helpers to make things
>>> easy for TTM-based drivers.
>>
>> Have you run this with DMA API debugging enabled?  I suspect you haven't,
>> and I recommend that you do.
>
> # cat /sys/kernel/debug/dma-api/error_count
> 162621
>
> (╯°□°）╯︵ ┻━┻)

*puts table back on its feet*

So, yeah - TTM memory is not allocated using the DMA API, hence we 
cannot use the DMA API to sync it. Thanks Russell for pointing it out.

The only alternative I see here is to flush the CPU caches when syncing 
for the device, and invalidate them for the other direction. Of course 
if the device has caches on its side as well the opposite operation must 
also be done for it. Guess the only way is to handle it all by ourselves 
here. :/
