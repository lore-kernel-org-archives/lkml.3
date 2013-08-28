Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318Ab3H1MQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 08:16:39 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:53732 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213Ab3H1MQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 08:16:38 -0400
Message-ID: <521DEA20.8020103@gmail.com>
Date: Wed, 28 Aug 2013 14:16:32 +0200
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
References: <20130828113459.48ecbb34@armhf> <521DCD33.2070008@gmail.com> <20130828121943.1c8327ca@skate> <521DD057.4040208@gmail.com> <20130828131548.0009d613@skate> <521DE2B3.9050508@gmail.com> <20130828135827.2307c89e@skate>
In-Reply-To: <20130828135827.2307c89e@skate>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/13 13:58, Thomas Petazzoni wrote:
> On Wed, 28 Aug 2013 13:44:51 +0200, Sebastian Hesselbarth wrote:
>>>> Also, we'll need to distinguish between the different audio controllers
>>>> on a single SoC, i.e. i2s0 and i2s1. I suggest checking the (phys) reg
>>>> base passed.
>>>
>>> For what reason does the driver needs to know whether it's the instance
>>> 0 or instance 1 ? If it's needed for some specific reason, then there
>>> should probably be something like marvell,i2s-channel-id = <0> and
>>> marvell,i2s-channel-id = <1>.
>>
>> On Dove, audio1 has SPDIF out, audio0 hasn't. Russell also mentioned to
>> get rid of "i2s" and use "audio" instead. Most SoC's controllers are
>> i2s only but as soon as SPDIF comes into play, it is a different
>> interface protocol.
>>
>> I am fine with having a "marvell,channel-id" (no "i2s") to discriminate
>> the instances, although reg offset should be sufficient.
>
> Well, the reg offset is a possibility, but it's not really nice, and
> would have to be adapted to each and every SoC even if the reset of the
> audio IP is the same.
>
> Though, if the difference between the two units is the availability of
> SPDIF support, then we shouldn't encode the channel number, but instead
> the availability of SPDIF, i.e:
>
> 	audio0 {
> 		reg = <... ...>;
> 		compatible = "marvell,kirkwood-audio";
> 		marvell,has-spdif;

Agree, if you make it "marvell,has-spdif-in" and "marvell,has-spdif-out"
Dove has either i2s-only or i2s+spdifo, kirkwood has i2s+spdifo+spdifi
for the one audio controller available. Can't tell for Armada 370.

BTW, you might have followed some of the DT discussions with Mark
before; as he insists on having a separate sound card node, he might
argue that above property should be part of that node instead.

Last patch discussion [1] I followed on some spdif sound nodes, took the
patch up to v11 or so. Mainly, because the author updated it too
quickly, but looks like audio bindings are (still) worth a lot of
discussion.

[1] http://comments.gmane.org/gmane.linux.alsa.devel/112004

Sebastian

> 	};
>
> 	audio1 {
> 		reg = <... ...>;
> 		compatible = "marvell,kirkwood-audio";
> 	};



