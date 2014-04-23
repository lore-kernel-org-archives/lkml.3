Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbaDWCH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 22:07:57 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:17768 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaDWCHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 22:07:55 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 22 Apr 2014 18:59:29 -0700
Message-ID: <53572077.6090305@nvidia.com>
Date: Wed, 23 Apr 2014 11:07:51 +0900
From: Alexandre Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Ben Skeggs <bskeggs@redhat.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gnurou@gmail.com" <gnurou@gmail.com>
Subject: Re: [PATCH v2 04/10] drm/nouveau/fb: add GK20A support
References: <1398060142-7937-1-git-send-email-acourbot@nvidia.com> <1398060142-7937-5-git-send-email-acourbot@nvidia.com> <20140422104052.GB22426@ulmo>
In-Reply-To: <20140422104052.GB22426@ulmo>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2014 07:40 PM, Thierry Reding wrote:
> * PGP Signed by an unknown key
>
> On Mon, Apr 21, 2014 at 03:02:16PM +0900, Alexandre Courbot wrote:
> [...]
>> diff --git a/drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c b/drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c
> [...]
>> +		pages = dma_alloc_from_contiguous(dev, ncmin, order);
>> +		if (!pages) {
>> +			gk20a_ram_put(pfb, &mem);
>> +			return -ENOMEM;
>> +		}
>> +
>> +		dma_addr = pfn_to_dma(nv_device_base(nv_device(pfb)),
>> +				      page_to_pfn(pages));
>
> This breaks compilation on x86 because neither pfn_to_dma() nor
> dma_to_pfn() are available. Is there some other way this can be
> allocated so that these functions don't need to be called?

Mmm, this is bad. There is probably another more portable way to do 
this. Let me look for it.

Thanks,
Alex.

