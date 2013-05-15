Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933087Ab3EOVUP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 17:20:15 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:38083 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932698Ab3EOVUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 17:20:13 -0400
Message-ID: <5193FC08.5040002@gmail.com>
Date: Wed, 15 May 2013 23:20:08 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
CC: Linus Walleij <linus.walleij@linaro.org>, Dan Williams <djbw@fb.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [RFC 2/4] dma: add dmaengine driver for Samsung s3c24xx SoCs
References: <201305111330.05046.heiko@sntech.de> <201305111331.25405.heiko@sntech.de> <CACRpkdaT195McX9NeccJYpmWbuYK-AZUTHr9AXKHnJdkf+Qzuw@mail.gmail.com> <201305152231.52423.heiko@sntech.de>
In-Reply-To: <201305152231.52423.heiko@sntech.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2013 10:31 PM, Heiko Stübner wrote:
>>> +       BUG();
>> >
>> >  Isn't that a bit nasty. This macro should be used with care and we
>> >  should recover if possible. dev_err()?
>
> runtime_config already denies any settings not in the 1,2 or 4bytes range -
> the default-part should therefore never be reached. So if any other value
> magically appears in the register and triggers the default-part, something is
> seriously wrong. So my guess is, the BUG might be appropriate.
>
> On the other hand the whole default+BUG part could also simply go away, for
> the same reasons.

IMHO BUG() is not needed at all. As Linus suggested dev_err() is such case
or WARN_ON() would be more appropriate. This has been discussed in the past
extensively, not sure if you are aware of the other Linus' opinion on
BUG()/BUG_ON() proliferation: https://lkml.org/lkml/2012/9/27/461

Regards,
Sylwester
