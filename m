Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab3KLHGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 02:06:15 -0500
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:19807
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755515Ab3KLHF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 02:05:58 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(z579ehzbb2dI98dI9371I1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh1155h)
Message-ID: <5281D347.3020903@freescale.com>
Date: Tue, 12 Nov 2013 15:05:43 +0800
From: Hongbo Zhang <hongbo.zhang@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>
CC: "Koul, Vinod" <vinod.koul@intel.com>, <rob.herring@calxeda.com>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, <ian.campbell@citrix.com>,
        <devicetree@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <dmaengine@vger.kernel.org>
Subject: Re: [PATCH v11 3/3] DMA: Freescale: update driver to support 8-channel
 DMA engine
References: <1380188023-3936-1-git-send-email-hongbo.zhang@freescale.com> <1380188023-3936-4-git-send-email-hongbo.zhang@freescale.com> <525F7C18.3010409@freescale.com> <5278587F.7090500@freescale.com> <CAA9_cme3c7SjH3iio0oR3FHpfoMzgrBDO-2k_Yf68G-AgFNqfA@mail.gmail.com> <52809F67.20901@freescale.com> <CAPcyv4h00zGc2=ZLwnCpP3WTQ8JbFteV-torU+qCo98YXrfq5A@mail.gmail.com>
In-Reply-To: <CAPcyv4h00zGc2=ZLwnCpP3WTQ8JbFteV-torU+qCo98YXrfq5A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2013 08:09 AM, Dan Williams wrote:
> On Mon, Nov 11, 2013 at 1:12 AM, Hongbo Zhang
> <hongbo.zhang@freescale.com> wrote:
>>>>>> diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
>>>>>> index 49e8fbd..16a9a48 100644
>>>>>> --- a/drivers/dma/fsldma.c
>>>>>> +++ b/drivers/dma/fsldma.c
>>>>>> @@ -1261,7 +1261,9 @@ static int fsl_dma_chan_probe(struct
>>>>>> fsldma_device
>>>>>> *fdev,
>>>>>>         WARN_ON(fdev->feature != chan->feature);
>>>>>>           chan->dev = fdev->dev;
>>>>>> -    chan->id = ((res.start - 0x100) & 0xfff) >> 7;
>>>>>> +    chan->id = (res.start & 0xfff) < 0x300 ?
>>>>>> +           ((res.start - 0x100) & 0xfff) >> 7 :
>>>>>> +           ((res.start - 0x200) & 0xfff) >> 7;
>>>>>>         if (chan->id >= FSL_DMA_MAX_CHANS_PER_DEVICE) {
>>> Isn't it a bit fragile to have this based on the resource address?
>>> Can't device tree tell you the channel id directly by an index into
>>> the "dma0: dma@100300" node?
>>
>> Yes, both this way and putting a "cell-index" into device tree work.
>> This won't be fragile, because the resource address should always be defined
>> correctly, otherwise even if we can tell a channel id by "cell-index" but
>> with wrong resource address, nothing will work.
>> This piece of code only doesn't seem as neat as using "cell-index", but we
>> prefer the style that let the device tree describes as true as what hardware
>> really has. This doesn't mean "cell-index" isn't acceptable, if it is
>> necessary and unavoidable, we can send another patch to add it, but
>> currently there is no need and we don't have to do this.
>>
> I'm pointing it out because we just had a bug fix to another driver
> motivated by the fact that resource addresses may move from one
> implementation to another, whereas the cell index provided by device
> tree is static.  Just a note, no need to fix it now.

Get it, and will remember it, thank you Dan.
> --
> Dan
>



