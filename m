Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751159AbaLOMrH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 07:47:07 -0500
Received: from regular1.263xmail.com ([211.150.99.140]:40995 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbaLOMrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 07:47:02 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: ykk@rock-chips.com
X-FST-TO: jsarha@ti.com
X-SENDER-IP: 104.167.231.21
X-LOGIN-NAME: ykk@rock-chips.com
X-UNIQUE-TAG: <4624e936dd8ee98669b8a259b5fb4161>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <548ED81E.2000108@rock-chips.com>
Date: Mon, 15 Dec 2014 20:46:22 +0800
From: "Kuankuan.Yang" <ykk@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Philipp Zabel <p.zabel@pengutronix.de>, Zubair.Kakakhel@imgtec.com,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Heiko Stuebner <heiko@sntech.de>,
        Daniel Kurtz <djkurtz@chromium.org>, Sonny Rao <sonnyrao@chromium.org>,
        Dylan Reid <dgreid@chromium.org>, Xu Jianqun <jay.xu@rock-chips.com>,
        =?UTF-8?B?U3TDqXBoYW5lIE1hcmNoZXNpbg==?= <marcheu@chromium.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Brian Austin <brian.austin@cirrus.com>,
        Bard Liao <bardliao@realtek.com>, Max Filippov <jcmvbkbc@gmail.com>,
        Oder Chiou <oder_chiou@realtek.com>, Arnd Bergmann <arnd@arndb.de>,
        Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Herring <robh+dt@kernel.org>, David Airlie <airlied@linux.ie>,
        Sean Cross <xobs@kosagi.com>, Grant Likely <grant.likely@linaro.org>,
        linux-rockchip@lists.infradead.org, Pawel Moll <pawel.moll@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Zhang <benzh@chromium.org>, devicetree@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Jaroslav Kysela <perex@perex.cz>,
        Mark Brown <broonie@kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Mark Rutland <mark.rutland@arm.com>, Jyri Sarha <jsarha@ti.com>
Subject: Re: [RFC PATCH 0/6] Those patches is used for dw_hdmi audio.
References: <1418609494-15820-1-git-send-email-ykk@rock-chips.com> <20141215103830.GD11285@n2100.arm.linux.org.uk> <548EC9E1.5040206@rock-chips.com> <548ECB66.70004@rock-chips.com> <20141215120013.GH11285@n2100.arm.linux.org.uk>
In-Reply-To: <20141215120013.GH11285@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell:

I got an idea that we can split the pcm dma part code out, after that we 
can chose the buffer transmit way (AUD_DMA or I2S).
In that way i will make another i2s driver to transmit those buffer, but 
in the mainline kernel already lanched an rockchip i2s driver
(rockchip_i2s.c), so seams it maybe not an good way.

what's your opinion, russell?

Best Regards.

在 2014年12月15日 20:00, Russell King - ARM Linux 写道:
> On Mon, Dec 15, 2014 at 07:52:06PM +0800, Kuankuan.Yang wrote:
>>   Hi Russell:
>>
>>       thks for your replay, actually you also have send me those
>> dw-hdmi-audio.c patches, and I also agree it's an beautiful way to make
>> hdmi-audio works. Beside,
>>   I try to reuse it into our platform, and actually the system have created
>> the DW_HDMI sound card successfully, but i cannot play any sound  with this
>> sound card.
>>       After dump the registers, I found the part of "Audio DMA Registers"
>> cannot write and always read with 0x00.  So I searching the document
>> "Designware Core
>>   HDMI Transmitter Controller Databook", and found that  "Audio DMA
>> Registers" only present when the hardware configuration parameter AUDIO_IF
>> is set to
>>   AHBAUDDMA. Than I communicate with our IC colleagues, they told me that our
>> cpu rk3288 only support two way to  transmit audio data( I2S & SPDIF ), in
>> that
>> way we do not support AHB_DMA, it's very sad, and this it why i give up this
>> way, also it's my bad that i should replay to u first in the before mail.
> Okay, that means there is some work to be done to figure out how to
> support this correctly so that both the iMX and Rockchip code can
> co-exist together in the mainline kernel - that means we _both_ need
> to work together on this problem _before_ this code gets merged, so
> that we have a common approach between the two code bases.
>
> I really don't want to end up in another cocked up situation like
> what happened with the Dove audio, where it became politically
> impossible for the SolidRun platform to be properly supported by
> mainline kernels.
>


