Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091Ab3H2ON7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 10:13:59 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:46739 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460Ab3H2ON5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 10:13:57 -0400
Message-ID: <521F5723.6070408@cogentembedded.com>
Date: Thu, 29 Aug 2013 18:13:55 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 1/2] ARM: Dove: Add the audio devices in DT
References: <20130828113459.48ecbb34@armhf> <521E5438.90109@cogentembedded.com> <20130829113848.6d8f7f21@armhf>
In-Reply-To: <20130829113848.6d8f7f21@armhf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 29-08-2013 13:38, Jean-Francois Moine wrote:

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

>>       According to ePAPR [1] the node should be called "sound", not
>> "audio-controller".

>>> +				compatible = "marvell,mvebu-audio";
>>> +				reg = <0xb0000 0x2210>;
>>> +				interrupts = <19>, <20>;
>>> +				clocks = <&gate_clk 12>;
>>> +				clock-names = "internal";
>>> +				status = "disabled";
>>> +			};

> AFAIK, "sound" describes the global audio subsystem. For the Cubox,
> this will be done by something like:

> 	sound {
> 		compatible = "simple-audio";
> 		audio-controller = <&i2s1>;
> 		audio-codec = <&spdif>;
> 		codec-dai-name = "dit-hifi";
> 	};

    Well, then "sound-controller" sounds somewhat more appropriate.

WBR, Sergei

