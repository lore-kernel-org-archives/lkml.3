Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934292Ab3HIKFJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 06:05:09 -0400
Received: from smtp-out-009.synserver.de ([212.40.185.9]:1177 "EHLO
	smtp-out-008.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934235Ab3HIKFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 06:05:08 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 13192
Message-ID: <5204BF06.3060806@metafoo.de>
Date: Fri, 09 Aug 2013 12:05:58 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Mark Brown <broonie@kernel.org>, Jean-Francois Moine <moinejf@free.fr>,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [alsa-devel] [PATCH v4 1/1] ASoc: kirkwood: add DT support to
 the mvebu audio subsystem
References: <20130808132201.2610aef3@armhf> <5204A716.6070507@gmail.com> <20130809091953.GO6427@sirena.org.uk> <5204B7A6.9050907@gmail.com>
In-Reply-To: <5204B7A6.9050907@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2013 11:34 AM, Sebastian Hesselbarth wrote:
> On 08/09/13 11:19, Mark Brown wrote:
>> On Fri, Aug 09, 2013 at 10:23:50AM +0200, Sebastian Hesselbarth wrote:
>>> On 08/08/2013 01:22 PM, Jean-Francois Moine wrote:
>>
>>>> +i2s1: audio-controller@b4000 {
>>>> +    compatible = "mrvl,mvebu-audio";
>>>> +    reg = <0xb4000 0x2210>;
>>>> +    interrupts = <21>, <22>;
>>>> +    clocks = <&gate_clk 13>;
>>>> +    clock-names = "internal";
>>>> +};
>>
>>> Also we will need some phandle reference to the audio codec here. As
>>> this property is ongoing work in ASoC core, I suggest we wait for it
>>> and propose a binding afterwards.
>>
>> No, as discussed this should be in the binding for the audio subsystem
>> not in the binding for an individual component in that subsystem.
>>
> 
> Mark,
> 
> I do understand there may be SoCs requiring sophisticated extra audio
> nodes, but Marvell SoCs don't. I prefer having a single node for the
> i2s controller *and* exploit the audio subsystem properties from that.

It's not about SoCs, it's about the board. The audio fabric on a board can
easily get complex enough to require its own driver. Speakers, mics, jacks
and jack detection, external amplifiers, bluetooth, baseband, multiple
CODECs. That's what the audio node describes.

- Lars

