Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbaCOJOW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 05:14:22 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:48634 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783AbaCOJOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 05:14:20 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Sat, 15 Mar 2014 11:14:13 +0200
From: Jyri Sarha <jsarha@ti.com>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Xiubo Li <Li.Xiubo@freescale.com>, alsa-devel@alsa-project.org,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
In-Reply-To: <20140314194037.7da888cd@armhf>
References: <cover.1394533640.git.moinejf@free.fr>
 <d71a2b62b331302772d35b3cd35c6dc5da1e9e5d.1394533640.git.moinejf@free.fr>
 <5322E4FC.7060605@ti.com> <20140314194037.7da888cd@armhf>
Message-ID: <cbc30d6fcafead46267347269cbabfb7@kapsi.fi>
User-Agent: RoundCube Webmail/0.9.4
X-SA-Exim-Connect-IP: 217.30.184.182
X-SA-Exim-Mail-From: jsarha@ti.com
Subject: Re: [alsa-devel] [PATCH v2 3/4] ASoC: simple-card: accept many DAI
 links
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:26:47 +0000)
X-SA-Exim-Scanned: Yes (on mail.kapsi.fi)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-03-14 20:40, Jean-Francois Moine wrote:
> On Fri, 14 Mar 2014 13:16:12 +0200
> Jyri Sarha <jsarha@ti.com> wrote:
> 
>> On 03/11/2014 11:36 AM, Jean-Francois Moine wrote:
>> > Some simple audio cards may have many DAI links.
>> > This patch extends the simple-card driver for handling such cards.
>> >
>> > Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
>> > ---
>> [...]
>> 
>> Why can't you just use two simple-card instances in your setup?
> 
> My machine has only one audio device (kirkwood). This one has two
> outputs. The first one (I2S) is connected to the HDMI transmitter, and
> the other one (S/PDIF) is connected to both the HDMI transmitter and 
> the
> S/PDIF connector. There can be only one playback stream, either via
> I2S, or S/PDIF, or both, with the final output either to HDMI or S/PDIF
> or both:
> 
>            /--> I2S -----+-> HDMI
> platform -+             /
>            \-> S/PDIF -+
>                         \--> S/PDIF
> 
> DPCM permits to activate both I2S and S/PDIF, but it does not handle
> the format and rate constraints (both outputs are always activated with
> the platform constraints).
> 
> So, the actual solution I use is 3 DAI links (= 3 PCMs):
> - HDMI via I2S
> - HDMI via S/PDIF (no S/PDIF output)
> - S/PDIF via S/PDIF (no HDMI output)
> 

Maybe a HW specific machine-driver would serve your case better. Of 
course it would be great to have a generic implementation that can 
handle this case too, but I am not sure if it should be called a 
simple-card anymore :).

>> You need to update the DT-binding document too when you are changing 
>> the
>> binding. That way it would also be easier to follow what you are 
>> trying
>> to accomplish here.
> 
> Some people want to have 2 different patchs: one for the code and the
> other one for the DT change. Some other people like you want only one
> patch. Which is the right way?
> 

I did not mean it should be in the same patch. Part of the same series 
is fine with me. It is up to maintainer to decide these things anyway. I 
would just like to compare the document with the implementation.

>> The sysclk and tdm properties appear to only work in the dais of the
>> first dai-link and __asoc_simple_card_dai_init() will not be called 
>> for
>> other dais at all. The DT-binding of this implementation would look
>> pretty hairy to me.
> 
> I will add an other dynamic structure for these properties.

Best regards,
Jyri
