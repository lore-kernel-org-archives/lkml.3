Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab3BZKRL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 05:17:11 -0500
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:55203 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752159Ab3BZKRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 05:17:10 -0500
Message-ID: <512C8B89.6060303@stericsson.com>
Date: Tue, 26 Feb 2013 11:16:41 +0100
From: =?UTF-8?B?QmVuZ3QgSsO2bnNzb24=?= <bengt.g.jonsson@stericsson.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH 05/73] ARM: ux500: Vsmps3 controlled by SysClkReq1
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org> <1359978868-28736-6-git-send-email-lee.jones@linaro.org> <20130204193737.GU4720@opensource.wolfsonmicro.com> <CACRpkdYWZOa=bbJYpG7owxVJXxPq5sx7jHmo5UpRe8pmPGYKMQ@mail.gmail.com> <20130205120134.GY4720@opensource.wolfsonmicro.com> <20130226094412.GD16685@gmail.com>
In-Reply-To: <20130226094412.GD16685@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2013 10:44 AM, Lee Jones wrote:
> On Tue, 05 Feb 2013, Mark Brown wrote:
>
>> On Mon, Feb 04, 2013 at 10:21:36PM +0100, Linus Walleij wrote:
>>
>>> What is needed is some way to model that
>>> electronic relationship into both the regulator
>>> and clock subsystems (Ulf Hansson is working on
>>> the ABx500 clocks as we speak.)
>>> Maybe the actual place to have it would be
>>> somewhere like drivers/mfd/ab8500-core.c.
>>> Have you seen similar stuff in other PMICs?
>> Yes, it's fairly common to at least have hardware enable signals.  If
>> what was going on was actually understood by the driver in some way it
>> might be better but right now...  Especially in a series like this it's
>> really bad to just see loads of patches which boil down to "change the
>> semi-documented magic value" - this just makes the series depressing to
>> read.
> Okay, I've just re-read this thread and it appears you're both talking
> about different things.
>
> Linus is talking about a discussion with Bengt regarding how these
> strange sysclkreq thingies work. When I first read the code they
> appear to be equivalent to GPIO regulators, but in actual fact the
> hardware logic is different on enable/disable. So they probably don't
> belong in regulator code at all.
>
> Where as, Mark is complaining about how the regulators are initialised
> by lots of magic register writes during init. Although, comments are
> inserted for each of the values, they're by no means exhaustive and
> aren't really even helpful if you don't have the uber-s3cr3t design
> specification. What he would like to see is that most of this stuff
> being handled by the framework. Some of this stuff is clearly only
> setting voltages and power-states and the like.
>
> I'd certainly be up for taking this on, but I think an in-depth
> knowledge of the AB8500 regulator subsystem would be required.
>
We got a comment about this some years before and then I thought that it 
was best to just initialise the registers because (1) there are many 
settings that could not be handled by the regulator framework and (2) 
many settings are mixed up in same registers which would lead to many 
more write operations. The risk is also that everything gets more 
complicated if we mix regulator framework initialisation with our own 
initialisation.

I still doubt that letting the framework initialise the regulator 
registers is the way to go but of course we should have a look at it. I 
agree that the current code is depressing, it does not provide much 
understanding. I can go through the register initialisation and propose 
what to do with each bit.


