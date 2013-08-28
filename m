Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab3H1Lo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 07:44:58 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:37333 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab3H1Lo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 07:44:56 -0400
Message-ID: <521DE2B3.9050508@gmail.com>
Date: Wed, 28 Aug 2013 13:44:51 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: Jean-Francois Moine <moinejf@free.fr>, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Ian Campbell <ian.campbell@citrix.com>
Subject: Re: [PATCH 1/2] ARM: Dove: Add the audio devices in DT
References: <20130828113459.48ecbb34@armhf> <521DCD33.2070008@gmail.com> <20130828121943.1c8327ca@skate> <521DD057.4040208@gmail.com> <20130828131548.0009d613@skate>
In-Reply-To: <20130828131548.0009d613@skate>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/13 13:15, Thomas Petazzoni wrote:
> On Wed, 28 Aug 2013 12:26:31 +0200, Sebastian Hesselbarth wrote:
>>>> as Mark Brown already took the bindings patch for above generic
>>>> compatible, how are we going to discriminate different
>>>> implementations/features of Dove, Kirkwood, and Armada 370?
>>>
>>> I agree that mvebu-audio is not a really good compatible string. It
>>> should use the first SoC that introduced the IP block, so that if
>>> future SOCs have variations, we can introduce separate compatible
>>> strings.
>>>
>>> So for now, the compatible string should be kirkwood-audio.
>>
>> Unfortunately, mvebu-audio has already been taken by Mark. Also, we
>> know the differences for the three SoCs now and should have a compatible
>> for each (and maybe mvebu-audio for fallback).
>
> For 3.12, right? So 3.12 hasn't been released yet, so it's still time
> to fix this.

I guess, yes.

>> Also, we'll need to distinguish between the different audio controllers
>> on a single SoC, i.e. i2s0 and i2s1. I suggest checking the (phys) reg
>> base passed.
>
> For what reason does the driver needs to know whether it's the instance
> 0 or instance 1 ? If it's needed for some specific reason, then there
> should probably be something like marvell,i2s-channel-id = <0> and
> marvell,i2s-channel-id = <1>.

On Dove, audio1 has SPDIF out, audio0 hasn't. Russell also mentioned to
get rid of "i2s" and use "audio" instead. Most SoC's controllers are
i2s only but as soon as SPDIF comes into play, it is a different
interface protocol.

I am fine with having a "marvell,channel-id" (no "i2s") to discriminate
the instances, although reg offset should be sufficient.

Jean-Francois: Can you please also rename the DT nodes to "audio0" and
"audio1" instead?

Sebastian
