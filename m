Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab3H1K1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 06:27:12 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:58761 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab3H1K1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 06:27:10 -0400
Message-ID: <521DD057.4040208@gmail.com>
Date: Wed, 28 Aug 2013 12:26:31 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
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
References: <20130828113459.48ecbb34@armhf> <521DCD33.2070008@gmail.com> <20130828121943.1c8327ca@skate>
In-Reply-To: <20130828121943.1c8327ca@skate>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2013 12:19 PM, Thomas Petazzoni wrote:
> Sebastian, Jean-François,
>
> On Wed, 28 Aug 2013 12:13:07 +0200, Sebastian Hesselbarth wrote:
>> On 08/28/2013 11:34 AM, Jean-Francois Moine wrote:
>>> This patch adds the nodes to instantiate the audio devices of the Dove
>>> boards.
>>>
>>> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
>>> ---
>>>    arch/arm/boot/dts/dove.dtsi                  | 18 ++++++++++++++++++
>>>    1 file changed, 18 insertions(+)
>>>
>>> diff --git a/arch/arm/boot/dts/dove.dtsi b/arch/arm/boot/dts/dove.dtsi
>>> index 499abad..78227e2 100644
>>> --- a/arch/arm/boot/dts/dove.dtsi
>>> +++ b/arch/arm/boot/dts/dove.dtsi
>>> @@ -573,6 +573,24 @@
>>>    					phy-handle = <&ethphy>;
>>>    				};
>>>    			};
>>> +
>>> +			i2s0: audio-controller@b0000 {
>>> +				compatible = "marvell,mvebu-audio";
>>
>> [added Gregory to Cc]
>>
>> Jean-Francois,
>>
>> as Mark Brown already took the bindings patch for above generic
>> compatible, how are we going to discriminate different
>> implementations/features of Dove, Kirkwood, and Armada 370?
>
> I agree that mvebu-audio is not a really good compatible string. It
> should use the first SoC that introduced the IP block, so that if
> future SOCs have variations, we can introduce separate compatible
> strings.
>
> So for now, the compatible string should be kirkwood-audio.

Unfortunately, mvebu-audio has already been taken by Mark. Also, we
know the differences for the three SoCs now and should have a compatible
for each (and maybe mvebu-audio for fallback).

Also, we'll need to distinguish between the different audio controllers
on a single SoC, i.e. i2s0 and i2s1. I suggest checking the (phys) reg
base passed.

Sebastian
