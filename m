Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934489Ab3BTCMy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 21:12:54 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:59941 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933498Ab3BTCMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 21:12:53 -0500
Message-ID: <51243120.1030101@wwwdotorg.org>
Date: Tue, 19 Feb 2013 19:12:48 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mike Rapoport <mike@compulab.co.il>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: tps6586x: Having slew rate settings for other
 than SM0/1 is not fatal
References: <1361015443.11226.1.camel@phoenix> <5123ACA1.9000408@wwwdotorg.org> <CAFRkauAAdArpG5x8MeyZJXUYqi00e669Hr6gPHGO8fxTJnE5YQ@mail.gmail.com>
In-Reply-To: <CAFRkauAAdArpG5x8MeyZJXUYqi00e669Hr6gPHGO8fxTJnE5YQ@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2013 05:53 PM, Axel Lin wrote:
> 2013/2/20 Stephen Warren <swarren@wwwdotorg.org>:
>> On 02/16/2013 04:50 AM, Axel Lin wrote:
>>> Ignore the setting and show "Only SM0/SM1 can set slew rate" warning is enough,
>>> then we can return 0 instead of -EINVAL in tps6586x_regulator_set_slew_rate().
>>>
>>> Otherwise, probe() fails.
>>
>> Why does probe() fail; what is trying to set a slew rate on a regulator
>> that doesn't support it? At least a few days ago in linux-next, this
>> patch wasn't needed AFAIK. Is the problem something new?
>>
> 
> Oh, sorry for my poor Engilish.
> I mean probe fails because of having slew rate settings for other than SM0/1
> seems not necessary.
> 
> In tps6586x_regulator_set_slew_rate() it uses dev_warn rather than dev_err
> for the default case.
> We can either using "dev_warn with return 0" or use "dev_err with
> return -EINVAL"
> in tps6586x_regulator_set_slew_rate().

Oh right, I understand. s/dev_warn/dev_err/ seems more appropriate to
me, I think.

