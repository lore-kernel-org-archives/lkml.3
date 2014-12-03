Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343AbaLCNPq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 08:15:46 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738AbaLCNPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 08:15:44 -0500
Message-ID: <547F0CFE.4010107@nod.at>
Date: Wed, 03 Dec 2014 14:15:42 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Harald Geyer <harald@ccbib.org>
CC: jic23@kernel.org, knaack.h@gmx.de, lars@metafoo.de, pmeerw@pmeerw.net,
        sanjeev_sharma@mentor.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: iio: dht11 Updates
References: <1417563176-31972-1-git-send-email-richard@nod.at> <E1Xw8sp-0001B6-Ul@stardust.g4.wien.funkfeuer.at>
In-Reply-To: <E1Xw8sp-0001B6-Ul@stardust.g4.wien.funkfeuer.at>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harald,

Am 03.12.2014 um 13:18 schrieb Harald Geyer:
> Hi Richard,
> 
> thanks for all the work you put into this!
> 
> Richard Weinberger writes:
>> Please see my current patches for your driver.
>> As discussed in an earlier mail I'm testing with the DHT22 sensor only.
>> With the IRQ changes I see 84 edges.
> 
> This still surprises me. With the IRQ changes I would expect the
> preamble to be 2 edges only. I must be missing something. Can you
> explain this to me?

I'll try to find out!

> I'll look into this as soon as I've time.
> 
>> I have also a question on your driver. Why you increment
>> DHT11_DATA_BIT_LOW/timeres by one in the ambiguity check?
>>
>>         threshold = DHT11_DATA_BIT_HIGH / timeres;
>>         if (DHT11_DATA_BIT_LOW/timeres + 1 >= threshold)
>>                 pr_err("dht11: WARNING: decoding ambiguous\n");
> 
> This is to take ambiguity of when the bit started relativ to the
> clock ticks into account. For example with common 32kHz clocks:
> DHT11_DATA_BIT_LOW / timeres = 0
> DHT11_DATA_BIT_HIGH / timeres = 2
> but since the bit might not start at a clock tick the actual t of
> a low bit can be either 0 or 1 while the actual t of a high bit
> can be either 2 or 3.
> 
> This case is fine.
> 
> But if we had a 38kHz clock:
> DHT11_DATA_BIT_LOW / timeres = 1    t can be 1 or 2
> DHT11_DATA_BIT_HIGH / timeres = 2   t can be 2 or 3
> so we have an ambiguity. The ambiguity could be removed by a smarter
> decoder, that looks at the t of other bits, but I'm not going to do
> that unless somebody is promising to test it on affected hardware.
> 
> Feel free to add some comment about this to the code.

Will do, thanks a lot for the explanation.

I was asking because I see the "dht11: WARNING: decoding ambiguous"
very often. (with and without my patches)

>> [PATCH 1/4] iio: dht11: Add locking
>> [PATCH 2/4] iio: dht11: IRQ fixes
>> [PATCH 3/4] iio: dht11: Logging updates
>> [PATCH 4/4] iio: dht11: Fix out-of-bounds read
> 
> You can add my Acked-by or Reviewed-by to 1/4 and 4/4 if you want to.
> Maybe Jonathan wants the patches reordered so that fixes come first, but
> then 4/4 should not cause any problems in practice, so perhaps it doesn't
> matter.
> 
> I really have to understand this preamble length thing on 2/4 and I will
> reply to 3/4 separately.

Thanks a lot!
//richard
