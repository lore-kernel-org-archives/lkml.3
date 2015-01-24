Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbbAXHac (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 02:30:32 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:59597 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbbAXHaa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 02:30:30 -0500
Date: Sat, 24 Jan 2015 08:30:27 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Mark Brown <broonie@kernel.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        devicetree@vger.kernel.org, alsa-devel@alsa-project.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Jyri Sarha <jsarha@ti.com>
Subject: Re: [alsa-devel] [PATCH v2 3/3] ASoC: add generic dt-card support
Message-ID: <20150124083027.3b3a018f@armhf>
In-Reply-To: <20150123191343.GW21293@sirena.org.uk>
References: <cover.1421868426.git.moinejf@free.fr>
	<d0c66c2e2f200119f9990fa52a503b1a4af6238f.1421868426.git.moinejf@free.fr>
	<54C0088F.9070609@metafoo.de>
	<20150122090723.50ac0156@armhf>
	<54C14EB3.8080305@metafoo.de>
	<20150123131554.623003f9@armhf>
	<54C252F4.9000504@metafoo.de>
	<20150123193456.276ea512@armhf>
	<20150123191343.GW21293@sirena.org.uk>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2015 19:13:43 +0000
Mark Brown <broonie@kernel.org> wrote:

> On Fri, Jan 23, 2015 at 07:34:56PM +0100, Jean-Francois Moine wrote:
> 
> > A card builder is a device which
> > - scans the graph of ports,
> > - fills the struct snd_soc_card according to the links between the
> >   ports and their properties,
> > - and, eventually, calls snd_soc_register_card().
> 
> > The simple card builder, 'dt-card' (maybe a better name would have been
> > 'graph-card'), acts just like the simple-card except that it does not
> > appear in the DT. Its creation is done by an audio controller.
> 
> Which audio controller?  There may be several CPU side audio interfaces
> in the same card.  For example people often want to have both low
> latency and high latency audio paths from the CPU into the hardware (low
> latency tends to increase power burn).  SoC centric system designs do
> sometimes also have PDM I/O, expecting to be directly connected to DMICs
> and so on, which results in a relatively large number of CPU interfaces.

The audio controller which creates the card depends on the complexity
of the card. When there are many controllers, it is up to the designer
to define either a master audio controller or to instantiate a 'card'
device via the DT for doing the job.

> > > > With a DT graph, each CPU/CODEC would know exactly the widgets and
> > > > routes it has to define.
> 
> > > Which widgets/routes do you mean?
> 
> > Well, forget about this. I never clearly understood why some widgets
> > and routes had to be defined at card level.
> 
> Please do try to understand the idea of representing simple components
> on the board and analogue interconects between devices - it's really
> important and not something that can be neglected.

The problem is that this understanding would stay abstract: I have no
such a hardware. Anyway, if the representation can be done with the
simple-card, it may also be done with a graph of ports.

> > > I'd agree if this was some kind of kernel internal stuff, but this is 
> > > creating ABI and we have to maintain it forever. Rushing this in without 
> > > proper discussion and consideration of the more complex use-cases is in my 
> > > opinion not a good idea.
> 
> > Using a graph of port to describe the audio subsystem has been pushed
> > forwards by many people for a long time, as shown by the creation of
> > the document Documentation/devicetree/bindings/graph.txt.
> 
> That DT binding was done entirely in the context of video applications
> IIRC, this is the first time it's been discussed in this context.

http://mailman.alsa-project.org/pipermail/alsa-devel/2014-January/070622.html
http://mailman.alsa-project.org/pipermail/alsa-devel/2015-January/086273.html

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
