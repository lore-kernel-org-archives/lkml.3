Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022AbaJHQOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 12:14:32 -0400
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:50284 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870AbaJHQO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 12:14:29 -0400
X-IronPort-AV: E=Sophos;i="5.04,678,1406617200"; 
   d="scan'208";a="47723715"
Message-ID: <543562EB.8060300@broadcom.com>
Date: Wed, 8 Oct 2014 09:14:35 -0700
From: Ray Jui <rjui@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, Grant Likely <grant.likely@linaro.org>
CC: <linux-spi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        JD Zheng <jdzheng@broadcom.com>, Scott Branden <sbranden@broadcom.com>
Subject: Re: [PATCH] spi: pl022: Fix broken spidev when DMA is enabled
References: <rjui@broadcom.com> <1412743127-4523-1-git-send-email-rjui@broadcom.com> <20141008112143.GT4609@sirena.org.uk>
In-Reply-To: <20141008112143.GT4609@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/8/2014 4:21 AM, Mark Brown wrote:
> On Tue, Oct 07, 2014 at 09:38:47PM -0700, Ray Jui wrote:
>
>> The PL022 SPI driver maps the DMA RX buffer before the DMA TX buffer. In
>> most cases, the sequence of the mapping does not matter. But in cases
>> where TX and RX happen to use the same buffer, e.g., spidev, it causes
>> the cached TX data not written to memory, because the same memory has
>> been marked invalid when dma_map_sg on the RX buffer is called
>
> This seems like it is a bug in spidev, using the same buffer simultaneously
> for both directions isn't something I'd think would be expected to work
> reliably unless it was explicitly mapped as bidirectional.
>
Hi Mark,

Thanks for the reply. It looks like you are also the maintainer of 
spidev. In this case, could you please help to confirm that you expect 
spidev to use separate buffers for TX and RX? If so, I can go ahead and 
make the change in spidev.

+ Grant

Thanks,

Ray
