Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965662Ab3HIJel (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 05:34:41 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:53293 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964961Ab3HIJej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 05:34:39 -0400
Message-ID: <5204B7A6.9050907@gmail.com>
Date: Fri, 09 Aug 2013 11:34:30 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Jean-Francois Moine <moinejf@free.fr>, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 1/1] ASoc: kirkwood: add DT support to the mvebu audio
 subsystem
References: <20130808132201.2610aef3@armhf> <5204A716.6070507@gmail.com> <20130809091953.GO6427@sirena.org.uk>
In-Reply-To: <20130809091953.GO6427@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/13 11:19, Mark Brown wrote:
> On Fri, Aug 09, 2013 at 10:23:50AM +0200, Sebastian Hesselbarth wrote:
>> On 08/08/2013 01:22 PM, Jean-Francois Moine wrote:
>
>>> +i2s1: audio-controller@b4000 {
>>> +	compatible = "mrvl,mvebu-audio";
>>> +	reg = <0xb4000 0x2210>;
>>> +	interrupts = <21>, <22>;
>>> +	clocks = <&gate_clk 13>;
>>> +	clock-names = "internal";
>>> +};
>
>> Also we will need some phandle reference to the audio codec here. As
>> this property is ongoing work in ASoC core, I suggest we wait for it
>> and propose a binding afterwards.
>
> No, as discussed this should be in the binding for the audio subsystem
> not in the binding for an individual component in that subsystem.
>

Mark,

I do understand there may be SoCs requiring sophisticated extra audio
nodes, but Marvell SoCs don't. I prefer having a single node for the
i2s controller *and* exploit the audio subsystem properties from that.

For Marvell audio, we only need a single node for all three ASoC
drivers. No other subsystem _requires_ you to have extra nodes for
it's needs. If you can provide interrupts, just have an interrupt-
controller property. If you can provide clocks, you can link to that
very node - no virtual device node required. Even for media they
do not insist on a virtual node but they do have generic properties
you can exploit.

If you insist on creating a virtual sound card node just because
ASoC wants it that way - okay, your call. But I don't see any value
in that.

Sebastian
