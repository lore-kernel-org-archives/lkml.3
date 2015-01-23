Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387AbbAWN1Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 08:27:24 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:58413 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbbAWN1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 08:27:20 -0500
Message-ID: <54C24C2B.1070907@gmail.com>
Date: Fri, 23 Jan 2015 16:27:07 +0300
From: Dmitry Osipenko <digetx@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Alexandre Courbot <gnurou@gmail.com>, Wolfram Sang <wsa@the-dreams.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Bob Mottram <bob.mottram@codethink.co.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] i2c: tegra: Maintain CPU endianness
References: <1421756555-20266-1-git-send-email-digetx@gmail.com> <20150122074001.GB427@ulmo> <CAAVeFuJHST9VOWXe_cZNvLmfGdamuU4HSgdZC6EoQvrsGFt+Fg@mail.gmail.com> <54C115D1.10206@gmail.com> <54C12010.8040504@gmail.com> <54C130EA.2050505@gmail.com> <20150123094552.GD3835@ulmo>
In-Reply-To: <20150123094552.GD3835@ulmo>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

23.01.2015 12:45, Thierry Reding пишет:
> On Thu, Jan 22, 2015 at 08:18:34PM +0300, Dmitry Osipenko wrote:
>> 22.01.2015 19:06, Dmitry Osipenko пишет:
>>> 22.01.2015 18:22, Dmitry Osipenko пишет:
>>>> 22.01.2015 10:55, Alexandre Courbot пишет:
>>>>> On Thu, Jan 22, 2015 at 4:40 PM, Thierry Reding
>>>>> <thierry.reding@gmail.com> wrote:
>>>>>>
>>>>>> Should this not technically be le32_to_cpu() since the data originates
>>>>> >from the I2C controller?
>>>>
>>>> No, i2c_readl returns value in CPU endianness, so it's correct. But for
>>>> i2c_writel should be used le32_to_cpu(), since it takes value in CPU endianness.
>>>> It's my overlook, V2 is coming.
>>>>
>>>>>>
>>>>>> Why does this have to be initialized to 0 now?
>>>>>
>>>>> I suspect this is because we are going to memcpy less than 4 bytes
>>>>> into it, but I cannot figure out how that memcpy if guaranteed to
>>>>> produce the expected result for both endiannesses.
>>>>>
>>>> That's correct. Memcpy is working with bytes, so it doesn't care about
>>>> endianness and produces expected result, since I2C message is char array.
>>>>
>>> I'll spend some more time reviewing, to see if nullifying should go as separate
>>> patch.
>>>
>> Well, I2C_FIFO_STATUS returns 8-bit value. The rest of bits very likely to
>> be RAZ, however I don't see anything on it in documentation. In that case it
>> won't cause any problems with LE value and nullifying is only needed for BE
>> mode.
>
> What does I2C_FIFO_STATUS have to do with anything?
>
> My point was more that we already tell hardware how much data is to be
> transferred (via the packet header in tegra_i2c_xfer_msg()), hence the
> hardware shouldn't care whether the FIFO is padded with random data or
> zeros.
>
> Thierry
>
Got your point. I was thinking it's expected behavior, but now I'll elaborate 
this more.

-- 
Dmitry
