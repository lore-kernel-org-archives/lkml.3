Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145AbbAVPXM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 10:23:12 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:41558 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbbAVPXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 10:23:09 -0500
Message-ID: <54C115D1.10206@gmail.com>
Date: Thu, 22 Jan 2015 18:22:57 +0300
From: Dmitry Osipenko <digetx@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Alexandre Courbot <gnurou@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: Wolfram Sang <wsa@the-dreams.de>, Stephen Warren <swarren@wwwdotorg.org>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Bob Mottram <bob.mottram@codethink.co.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] i2c: tegra: Maintain CPU endianness
References: <1421756555-20266-1-git-send-email-digetx@gmail.com> <20150122074001.GB427@ulmo> <CAAVeFuJHST9VOWXe_cZNvLmfGdamuU4HSgdZC6EoQvrsGFt+Fg@mail.gmail.com>
In-Reply-To: <CAAVeFuJHST9VOWXe_cZNvLmfGdamuU4HSgdZC6EoQvrsGFt+Fg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

22.01.2015 10:55, Alexandre Courbot пишет:
> On Thu, Jan 22, 2015 at 4:40 PM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
>>
>> Should this not technically be le32_to_cpu() since the data originates
>> from the I2C controller?

No, i2c_readl returns value in CPU endianness, so it's correct. But for 
i2c_writel should be used le32_to_cpu(), since it takes value in CPU endianness.
It's my overlook, V2 is coming.

>>
>> Why does this have to be initialized to 0 now?
>
> I suspect this is because we are going to memcpy less than 4 bytes
> into it, but I cannot figure out how that memcpy if guaranteed to
> produce the expected result for both endiannesses.
>
That's correct. Memcpy is working with bytes, so it doesn't care about 
endianness and produces expected result, since I2C message is char array.

-- 
Dmitry
