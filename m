Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbaGUIoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 04:44:22 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:51680 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134AbaGUIoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 04:44:21 -0400
Message-ID: <53CCD2DF.4010307@collabora.co.uk>
Date: Mon, 21 Jul 2014 10:44:15 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>,
        Dan Williams <dan.j.williams@intel.com>
CC: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] dmaengine: pl330: Check if the DMA descriptor is
 NULL
References: <1405732907-30964-1-git-send-email-javier.martinez@collabora.co.uk> <53CBCFBF.1040208@metafoo.de> <53CC032C.4000105@collabora.co.uk> <53CCCDAD.5080001@metafoo.de>
In-Reply-To: <53CCCDAD.5080001@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2014 10:22 AM, Lars-Peter Clausen wrote:
> On 07/20/2014 07:58 PM, Javier Martinez Canillas wrote:
>>
>> If this should not really happen and this patch is only a workaround since the
>> bug is elsewhere, please give me some hints and I'll try to fix it properly. I'm
>> not familiar with the PL330 DMA controller but just found what was the NULL
>> pointer being dereferenced and looked at your changes to see what was different now.
> 
> I think the patch is fine as a quick workaround since it is simple and the 
> previous commit broke previously working code.
> 

Agreed, it matches what the old code was doing and other code is relying on this
behavior so works as a quick fix to avoid the current kernel oops.

> The long term fix is to stop calling dma_pl330_rqcb() from 
> pl330_release_channel(). The first thing is you wouldn't expect any transfer 
> to be active when the channel is released. And even if it was by accident we 
> should not call the descriptor callback, but rather but it just back onto 
> the descriptor pool.

Thanks a lot for the clarification. I thought it was something along the lines
of not calling the callback from pl330_release_channel() but preferred to not
change anything that I could not completely understand its side effects.

I'll study the driver more deeply and try to come up with a patch on top of this
one that fixes the actual cause rather than the consequence.

> 
> - Lars
> 

Best regards,
Javier
