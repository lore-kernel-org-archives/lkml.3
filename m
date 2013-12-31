Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab3LaRpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 12:45:31 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:40584 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753897Ab3LaRpa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 12:45:30 -0500
Date: Tue, 31 Dec 2013 18:44:30 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: make snd_soc_dai_link more symmetrical
Message-ID: <20131231184430.3a4c9414@armhf>
In-Reply-To: <20131231165533.GK31886@sirena.org.uk>
References: <20131212185917.7ed6b21f@armhf>
	<20131231165533.GK31886@sirena.org.uk>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Dec 2013 16:55:33 +0000
Mark Brown <broonie@kernel.org> wrote:

> On Thu, Dec 12, 2013 at 06:59:17PM +0100, Jean-Francois Moine wrote:
> 
> > This patch renders optional the CODEC name / OF node on sound card register,
> > as it is done for the CPU side, in the case the CODEC DAI name is unique.
> 
> > This simplifies the definition of CODECs with multiple DAIs, especially
> > in DTs, while keeping compatibility.
> 
> So, this is similar to one of the comments I made on the DT patch you
> sent today: you're saying that this makes things better but you're not
> saying why it makes things better.  I've been sitting on this partly
> because I've been wanting to sit down and try to work out what the
> benefit is.  This information should be readily avaiable and omiting it
> seems like it will make things more fragile.
> 
> If anything I'd expect DT to want to move towards specifying things by
> CODEC plus optional DAI index rather than anything else, that's the more
> common pattern for DT based things (really phandle plus index) and it's
> what the current generic card is doing.
> 
> It's possible there is a benefit I'm just not seeing but you'll need to
> tell me.

The first benefit I got was in the front-end definition: the codec side
is the dummy codec, and this one has no phandle.

Then, finding the CODEC DAI from phandle asks for more code
(of_xlate_dai_name in the CODEC drivers) and finding it from the CODEC
name asks for a double loop in soc_bind_dai_link. On the other way, a
simple loop without any more change may be used when the DAI is simply
specified by its name. I would say that the DAI name is more meaningful
than a DAI index and that it is less subject to internal changes of the
CODEC driver.

Eventually, I don't think that, using only the name of the CODEC side
DAI to identify it, is not more fragile than identifying the CPU side
of the DAI link by its name.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
