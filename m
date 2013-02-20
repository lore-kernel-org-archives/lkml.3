Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933486Ab3BTAxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 19:53:41 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:56175 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933366Ab3BTAxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 19:53:40 -0500
MIME-Version: 1.0
X-Originating-IP: [114.40.15.212]
In-Reply-To: <5123ACA1.9000408@wwwdotorg.org>
References: <1361015443.11226.1.camel@phoenix>
	<5123ACA1.9000408@wwwdotorg.org>
Date: Wed, 20 Feb 2013 08:53:39 +0800
Message-ID: <CAFRkauAAdArpG5x8MeyZJXUYqi00e669Hr6gPHGO8fxTJnE5YQ@mail.gmail.com>
Subject: Re: [PATCH] regulator: tps6586x: Having slew rate settings for other
 than SM0/1 is not fatal
From: Axel Lin <axel.lin@ingics.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mike Rapoport <mike@compulab.co.il>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/20 Stephen Warren <swarren@wwwdotorg.org>:
> On 02/16/2013 04:50 AM, Axel Lin wrote:
>> Ignore the setting and show "Only SM0/SM1 can set slew rate" warning is enough,
>> then we can return 0 instead of -EINVAL in tps6586x_regulator_set_slew_rate().
>>
>> Otherwise, probe() fails.
>
> Why does probe() fail; what is trying to set a slew rate on a regulator
> that doesn't support it? At least a few days ago in linux-next, this
> patch wasn't needed AFAIK. Is the problem something new?
>

Oh, sorry for my poor Engilish.
I mean probe fails because of having slew rate settings for other than SM0/1
seems not necessary.

In tps6586x_regulator_set_slew_rate() it uses dev_warn rather than dev_err
for the default case.
We can either using "dev_warn with return 0" or use "dev_err with
return -EINVAL"
in tps6586x_regulator_set_slew_rate().

It looks to me that having slew rate settings for other than SM0/1 should be ok
if it actually is harmless ( because we can just ignore the setting ).


BTW, I read the code but I don't have this hardware.

Axel
