Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbbAZSWi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 13:22:38 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:11508 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbbAZSWf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 13:22:35 -0500
Date: Mon, 26 Jan 2015 19:22:44 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mark Brown <broonie@kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        devicetree@vger.kernel.org, alsa-devel@alsa-project.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Jyri Sarha <jsarha@ti.com>
Subject: Re: [alsa-devel] [PATCH v2 3/3] ASoC: add generic dt-card support
Message-ID: <20150126192244.12a79eff@armhf>
In-Reply-To: <54C62AD1.2090207@metafoo.de>
References: <cover.1421868426.git.moinejf@free.fr>
	<d0c66c2e2f200119f9990fa52a503b1a4af6238f.1421868426.git.moinejf@free.fr>
	<54C0088F.9070609@metafoo.de>
	<20150122090723.50ac0156@armhf>
	<54C14EB3.8080305@metafoo.de>
	<20150123131554.623003f9@armhf>
	<54C252F4.9000504@metafoo.de>
	<20150123193456.276ea512@armhf>
	<54C381A7.3020209@metafoo.de>
	<20150124141820.3793bd47@armhf>
	<54C62AD1.2090207@metafoo.de>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2015 12:53:53 +0100
Lars-Peter Clausen <lars@metafoo.de> wrote:
> > - a generic sound node in the case of multi controllers or multi codec
> >    levels (after dt-card extension):
> >
> > 	sound {
> > 		compatible = "linux,dt-card";
> > 		audio-root = <&audio1>;	/* starting point of the graph */
> > 		... card properties ...
> > 	};
> >
> > For the last case, the creation of the simple dt-card builder could be
> > done by a node in the controller, avoiding the DT to have a knowledge
> > of this piece of software:
> >
> > 	&audio1 {
> > 		...
> > 		audio-card {
> > 			... card properties ...
> > 		}
> > 		port@0 {
> > 			...
> > 		};
> > 		...
> > 	};  
> 
> Is there any advantage to putting the card node inside the controller node 
> rather than having it as a separate node?

There is no advantage, but it seems to me that the sound device is a
software entity which should not appear in the devicetree.

> >> I think this is something that needs to be done in the ASoC/ALSA core
> >> itself. Create the graph, wait until all endpoints of the graph have been
> >> registered and then create the card. Or something similar.  
> >
> > To go further, such a function could fully replace
> > snd_soc_register_card()!  
> 
> Yes, if the graph is strongly connected (which it should be) the framework 
> will be able to identify when all components that belong to the graph have 
> been registered and is then able to create a card for it.

Russell's "Componentized device handling" would permit to synchronize
all components avoiding the PROBE_DEFERs, but there is a problem with
the tda998x: this one is a component of both the audio and video
subsystems, and the bind() callback does not indicate by which master
compoment it is called...

> Are you by chance at FOSDEM? If you are maybe we can sit down for a moment 
> and discuss things.

Sorry, I will not be at FOSDEM.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
