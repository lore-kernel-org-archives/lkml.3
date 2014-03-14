Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbaCNSkp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 14:40:45 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:58339 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755037AbaCNSkn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 14:40:43 -0400
Date: Fri, 14 Mar 2014 19:40:37 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Jyri Sarha <jsarha@ti.com>
Cc: Mark Brown <broonie@kernel.org>, <alsa-devel@alsa-project.org>,
        Xiubo Li <Li.Xiubo@freescale.com>, <linux-kernel@vger.kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: Re: [alsa-devel] [PATCH v2 3/4] ASoC: simple-card: accept many DAI
 links
Message-ID: <20140314194037.7da888cd@armhf>
In-Reply-To: <5322E4FC.7060605@ti.com>
References: <cover.1394533640.git.moinejf@free.fr>
	<d71a2b62b331302772d35b3cd35c6dc5da1e9e5d.1394533640.git.moinejf@free.fr>
	<5322E4FC.7060605@ti.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2014 13:16:12 +0200
Jyri Sarha <jsarha@ti.com> wrote:

> On 03/11/2014 11:36 AM, Jean-Francois Moine wrote:
> > Some simple audio cards may have many DAI links.
> > This patch extends the simple-card driver for handling such cards.
> >
> > Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
> > ---
> [...]
> 
> Why can't you just use two simple-card instances in your setup?

My machine has only one audio device (kirkwood). This one has two
outputs. The first one (I2S) is connected to the HDMI transmitter, and
the other one (S/PDIF) is connected to both the HDMI transmitter and the
S/PDIF connector. There can be only one playback stream, either via
I2S, or S/PDIF, or both, with the final output either to HDMI or S/PDIF
or both:

           /--> I2S -----+-> HDMI
platform -+             /
           \-> S/PDIF -+
                        \--> S/PDIF

DPCM permits to activate both I2S and S/PDIF, but it does not handle
the format and rate constraints (both outputs are always activated with
the platform constraints).

So, the actual solution I use is 3 DAI links (= 3 PCMs):
- HDMI via I2S
- HDMI via S/PDIF (no S/PDIF output)
- S/PDIF via S/PDIF (no HDMI output)

> You need to update the DT-binding document too when you are changing the 
> binding. That way it would also be easier to follow what you are trying 
> to accomplish here.

Some people want to have 2 different patchs: one for the code and the
other one for the DT change. Some other people like you want only one
patch. Which is the right way?

> The sysclk and tdm properties appear to only work in the dais of the 
> first dai-link and __asoc_simple_card_dai_init() will not be called for 
> other dais at all. The DT-binding of this implementation would look 
> pretty hairy to me.

I will add an other dynamic structure for these properties.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
