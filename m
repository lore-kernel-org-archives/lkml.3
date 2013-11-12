Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab3KLAKD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 19:10:03 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:34707 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845Ab3KLAJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 19:09:54 -0500
MIME-Version: 1.0
In-Reply-To: <52809F67.20901@freescale.com>
References: <1380188023-3936-1-git-send-email-hongbo.zhang@freescale.com>
	<1380188023-3936-4-git-send-email-hongbo.zhang@freescale.com>
	<525F7C18.3010409@freescale.com>
	<5278587F.7090500@freescale.com>
	<CAA9_cme3c7SjH3iio0oR3FHpfoMzgrBDO-2k_Yf68G-AgFNqfA@mail.gmail.com>
	<52809F67.20901@freescale.com>
Date: Mon, 11 Nov 2013 16:09:53 -0800
Message-ID: <CAPcyv4h00zGc2=ZLwnCpP3WTQ8JbFteV-torU+qCo98YXrfq5A@mail.gmail.com>
Subject: Re: [PATCH v11 3/3] DMA: Freescale: update driver to support
 8-channel DMA engine
From: Dan Williams <dan.j.williams@intel.com>
To: Hongbo Zhang <hongbo.zhang@freescale.com>
Cc: "Koul, Vinod" <vinod.koul@intel.com>, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com,
        Stephen Warren <swarren@wwwdotorg.org>, ian.campbell@citrix.com,
        devicetree@vger.kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dmaengine@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 1:12 AM, Hongbo Zhang
<hongbo.zhang@freescale.com> wrote:
>>>>> diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
>>>>> index 49e8fbd..16a9a48 100644
>>>>> --- a/drivers/dma/fsldma.c
>>>>> +++ b/drivers/dma/fsldma.c
>>>>> @@ -1261,7 +1261,9 @@ static int fsl_dma_chan_probe(struct
>>>>> fsldma_device
>>>>> *fdev,
>>>>>        WARN_ON(fdev->feature != chan->feature);
>>>>>          chan->dev = fdev->dev;
>>>>> -    chan->id = ((res.start - 0x100) & 0xfff) >> 7;
>>>>> +    chan->id = (res.start & 0xfff) < 0x300 ?
>>>>> +           ((res.start - 0x100) & 0xfff) >> 7 :
>>>>> +           ((res.start - 0x200) & 0xfff) >> 7;
>>>>>        if (chan->id >= FSL_DMA_MAX_CHANS_PER_DEVICE) {
>>
>> Isn't it a bit fragile to have this based on the resource address?
>> Can't device tree tell you the channel id directly by an index into
>> the "dma0: dma@100300" node?
>
>
> Yes, both this way and putting a "cell-index" into device tree work.
> This won't be fragile, because the resource address should always be defined
> correctly, otherwise even if we can tell a channel id by "cell-index" but
> with wrong resource address, nothing will work.
> This piece of code only doesn't seem as neat as using "cell-index", but we
> prefer the style that let the device tree describes as true as what hardware
> really has. This doesn't mean "cell-index" isn't acceptable, if it is
> necessary and unavoidable, we can send another patch to add it, but
> currently there is no need and we don't have to do this.
>

I'm pointing it out because we just had a bug fix to another driver
motivated by the fact that resource addresses may move from one
implementation to another, whereas the cell index provided by device
tree is static.  Just a note, no need to fix it now.

--
Dan
