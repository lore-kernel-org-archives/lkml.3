Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178AbaHTCvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 22:51:36 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:56770 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbaHTCve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 22:51:34 -0400
MIME-Version: 1.0
X-Originating-IP: [36.239.242.219]
In-Reply-To: <20140818141051.GY14537@sirena.org.uk>
References: <1408329248.12083.2.camel@phoenix>
	<20140818141051.GY14537@sirena.org.uk>
Date: Wed, 20 Aug 2014 10:51:33 +0800
Message-ID: <CAFRkauAZGnd5JDkvYtZDbNPTt1JT==zyg1a96hbkY24h2kofng@mail.gmail.com>
Subject: Re: [PATCH] regulator: core: Fix build error due to const qualifier
 for ops
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Guodong Xu <guodong.xu@linaro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-18 22:10 GMT+08:00 Mark Brown <broonie@kernel.org>:
> On Mon, Aug 18, 2014 at 10:34:08AM +0800, Axel Lin wrote:
>> Drop const qualifier for ops of struct regulator_desc.
>> Allow regulator drivers to update ops before registering regulator.
>
> Applied, thanks.

Hi Mark,
I found this commit is applied and I got below build warning in your for-next
tree.

  CC [M]  drivers/regulator/hi6421-regulator.o
drivers/regulator/hi6421-regulator.c:356:2: warning: initialization
discards 'const' qualifier from pointer target type [enabled by
default]
drivers/regulator/hi6421-regulator.c:358:2: warning: initialization
discards 'const' qualifier from pointer target type [enabled by
default]
drivers/regulator/hi6421-regulator.c:360:2: warning: initialization
discards 'const' qualifier from pointer target type [enabled by
default]
drivers/regulator/hi6421-regulator.c:362:2: warning: initialization
discards 'const' qualifier from pointer target type [enabled by
default]
drivers/regulator/hi6421-regulator.c:364:2: warning: initialization
discards 'const' qualifier from pointer target type [enabled by
default]
drivers/regulator/hi6421-regulator.c:366:2: warning: initialization
discards 'const' qualifier from pointer target type [enabled by
default]
drivers/regulator/hi6421-regulator.c:368:2: warning: initialization
discards 'const' qualifier from pointer target type [enabled by
default]
drivers/regulator/hi6421-regulator.c:370:2: warning: initialization
discards 'const' qualifier from pointer target type [enabled by
default]
drivers/regulator/hi6421-regulator.c:372:2: warning: initialization
discards 'const' qualifier from pointer target type [enabled by
default]
drivers/regulator/hi6421-regulator.c:374:2: warning: initialization
discards 'const' qualifier from pointer target type [enabled by
default]
drivers/regulator/hi6421-regulator.c:376:2: warning: initialization
discards 'const' qualifier from pointer target type [enabled by
default]
drivers/regulator/hi6421-regulator.c:378:2: warning: initialization
discards 'const' qualifier from pointer target type [enabled by
default]
drivers/regulator/hi6421-regulator.c:380:2: warning: initialization
discards 'const' qualifier from pointer target type [enabled by
default]
drivers/regulator/hi6421-regulator.c:382:2: warning: initialization
discards 'const' qualifier from pointer target type [enabled by
default]
drivers/regulator/hi6421-regulator.c:384:2: warning: initialization
discards 'const' qualifier from pointer target type [enabled by
default]
drivers/regulator/hi6421-regulator.c:386:2: warning: initialization
discards 'const' qualifier from pointer target type [enabled by
default]
drivers/regulator/hi6421-regulator.c:388:2: warning: initialization
discards 'const' qualifier from pointer target type [enabled by
default]
drivers/regulator/hi6421-regulator.c:390:2: warning: initialization
discards 'const' qualifier from pointer target type [enabled by
default]
drivers/regulator/hi6421-regulator.c:392:2: warning: initialization
discards 'const' qualifier from pointer target type [enabled by
default]
drivers/regulator/hi6421-regulator.c:394:2: warning: initialization
discards 'const' qualifier from pointer target type [enabled by
default]
drivers/regulator/hi6421-regulator.c:396:2: warning: initialization
discards 'const' qualifier from pointer target type [enabled by
default]
drivers/regulator/hi6421-regulator.c:398:2: warning: initialization
discards 'const' qualifier from pointer target type [enabled by
default]
drivers/regulator/hi6421-regulator.c:400:2: warning: initialization
discards 'const' qualifier from pointer target type [enabled by
default]
drivers/regulator/hi6421-regulator.c:401:2: warning: initialization
discards 'const' qualifier from pointer target type [enabled by
default]
drivers/regulator/hi6421-regulator.c:402:2: warning: initialization
discards 'const' qualifier from pointer target type [enabled by
default]
drivers/regulator/hi6421-regulator.c:403:2: warning: initialization
discards 'const' qualifier from pointer target type [enabled by
default]
drivers/regulator/hi6421-regulator.c:405:2: warning: initialization
discards 'const' qualifier from pointer target type [enabled by
default]
drivers/regulator/hi6421-regulator.c:407:2: warning: initialization
discards 'const' qualifier from pointer target type [enabled by
default]

As I mentioned in the commit log:
    Drop const qualifier for ops of struct regulator_desc.
    Allow regulator drivers to update ops before registering regulator.
    So I don't think it's necessary to add const for ops in struct
regulator_desc.
    (I think the original point was the "regulator core" won't modify the ops).

The fix is either drop the 'const' qualifier in hi6421-regulator driver or
add back const qualifier for ops of struct regulator_desc in
include/linux/regulator/driver.h.
Which one do you prefer?

Thanks,
Axel
