Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008AbaLOMAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 07:00:54 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:59544 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751499AbaLOMAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 07:00:50 -0500
Date: Mon, 15 Dec 2014 12:00:13 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Kuankuan.Yang" <ykk@rock-chips.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>, Zubair.Kakakhel@imgtec.com,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Heiko Stuebner <heiko@sntech.de>,
        Daniel Kurtz <djkurtz@chromium.org>, Sonny Rao <sonnyrao@chromium.org>,
        Dylan Reid <dgreid@chromium.org>, Xu Jianqun <jay.xu@rock-chips.com>,
        =?iso-8859-1?Q?St=E9phane?= Marchesin <marcheu@chromium.org>,
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
Message-ID: <20141215120013.GH11285@n2100.arm.linux.org.uk>
References: <1418609494-15820-1-git-send-email-ykk@rock-chips.com>
 <20141215103830.GD11285@n2100.arm.linux.org.uk>
 <548EC9E1.5040206@rock-chips.com>
 <548ECB66.70004@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <548ECB66.70004@rock-chips.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 07:52:06PM +0800, Kuankuan.Yang wrote:
>  Hi Russell:
> 
>      thks for your replay, actually you also have send me those
> dw-hdmi-audio.c patches, and I also agree it's an beautiful way to make
> hdmi-audio works. Beside,
>  I try to reuse it into our platform, and actually the system have created
> the DW_HDMI sound card successfully, but i cannot play any sound  with this
> sound card.
>      After dump the registers, I found the part of "Audio DMA Registers"
> cannot write and always read with 0x00.  So I searching the document
> "Designware Core
>  HDMI Transmitter Controller Databook", and found that  "Audio DMA
> Registers" only present when the hardware configuration parameter AUDIO_IF
> is set to
>  AHBAUDDMA. Than I communicate with our IC colleagues, they told me that our
> cpu rk3288 only support two way to  transmit audio data( I2S & SPDIF ), in
> that
> way we do not support AHB_DMA, it's very sad, and this it why i give up this
> way, also it's my bad that i should replay to u first in the before mail.

Okay, that means there is some work to be done to figure out how to
support this correctly so that both the iMX and Rockchip code can
co-exist together in the mainline kernel - that means we _both_ need
to work together on this problem _before_ this code gets merged, so
that we have a common approach between the two code bases.

I really don't want to end up in another cocked up situation like
what happened with the Dove audio, where it became politically
impossible for the SolidRun platform to be properly supported by
mainline kernels.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
