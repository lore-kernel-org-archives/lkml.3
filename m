Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667AbaKIX0G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 18:26:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54911 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbaKIX0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 18:26:05 -0500
Date: Mon, 10 Nov 2014 10:25:51 +1100
From: NeilBrown <neilb@suse.de>
To: Mark Brown <broonie@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        GTA04 owners <gta04-owner@goldelico.com>, devicetree@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] ASoC: twl4030: allow voice port to be connected
 externally.
Message-ID: <20141110102551.2678d342@notabene.brown>
In-Reply-To: <20141108092622.GC2722@sirena.org.uk>
References: <20141108002637.6561.19002.stgit@notabene.brown>
	<20141108003803.6561.57464.stgit@notabene.brown>
	<20141108092622.GC2722@sirena.org.uk>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.24; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/q+_O70ObzbDZp1yJD37T1cz"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/q+_O70ObzbDZp1yJD37T1cz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 8 Nov 2014 09:26:22 +0000 Mark Brown <broonie@kernel.org> wrote:

> On Sat, Nov 08, 2014 at 11:38:03AM +1100, NeilBrown wrote:
>=20
> > If voice port on twl4030 is not connected to a McBSP (or similar)
> > then we cannot configure the format the way we normally do for a DAI.
>=20
> Yes we can, you need to represent the DAI link to whatever else the
> device is connected to in the driver like we do anything else - and in
> any case this isn't a device specific issue so we shouldn't be doing
> something driver specific to solve it.  Look at something like speyside.

Hi Mark,
 thanks for the reply ... I might need a little bit more help though.

I had a look at sound/soc/samsung/speyside.c, but I'm not entirely sure what
I'm looking for.
Presumably this is an audio processor not unlike the audio module in the
twl4030.

I see that there are 3 dai-links:
  CPU-DSP
  DSP-CODEC
  Baseband

Presumably "Baseband" is similar, in purpose at least, to the "voice"
interface on the twl4030.

Each dai-link has a "cpu_dai_name" and a "codec_dai_name", even though it
appears that only "CPU-DSP" is connected to the CPU.  Maybe that naming is
the source of some of my confusion.

"Baseband" declares
                .cpu_dai_name =3D "wm8996-aif2",
so wm8996 is something with 2 audio interfaces, (aif), and this is the seco=
nd
one?  Maybe the  wm8996 is the audio module, so what is the "speyside"?

http://opensource.wolfsonmicro.com/content/speyside-audio

says it is a "reference platform".  Does that mean it is a board with a bun=
ch
of chips soldered onto it?  If it were a board it should be described by a
dts file, not by a pile of C code (I thought), so I must be wrong about tha=
t.


In my case, I have a board with a GSM module and the twl4030 module.  Each
has an audio interface and these are connected.  I assume that I need to
express this connection in the dts file.
The GSM module doesn't currently appear in the dts file as it is usb-attach=
ed.
However I've been thinking that we will need to add it so we can express
power-on controls (twiddling some GPIOs).  So let's suppose we have the GSM
module in the dts file (child of a USB interface) and the twl4030 as well
(beneath an i2c interface).

The twl4030 needs to know the master/polarity of the clk/frm lines.  The GSM
module declares that these are.  So presumably we need some sort of linkage.
Ahhhh... I found Documentation/devicetree/bindings/sound/simple-card.txt

So I need to make the "voice" port on the twl4030 look like a "cpu" end of a
dai-link, and create a "codec" end in the GSM module, and use "sound-dai" to
point from the twl4030 to the GSM module.
Then I use frame-master, bitclock-master, bitclock-inversion, frame-inversi=
on
for the settings I need.

I suspect I can make that work.

Am I on the right track?

Thanks,
NeilBrown

--Sig_/q+_O70ObzbDZp1yJD37T1cz
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVF/3/znsnt1WYoG5AQLjhw//aEDPnYz+D3TTOrrpi5gTXRlqNTiNmq6W
dOSPSXR1tfUI3gevIXkjO+NlHbRf74/2dOpQ5PJdzIG0tpkdXRr2M+y1zwj/KzIp
hvjLLbc43xiX/pLfp7MnIe0MEeOIMDgbF9q6v9oeBNLpIqgb0Naa5vd6Q97NET4W
ey4uJfkVp9jI6v9JgUeK+2/cTHgCkxJEW2eLrInpoBbHhGuuijIxGPjzPLr+yrv9
6pcIp+JB1LH4RXZgssVw87dm5EYq8mFDNt86GxLKm0Mm0rbi6lojku1LGBC1s0gz
VpUhVi65iXLA8krQaX9RGHIyD4kuLiVVKiQyCo3fTs2fwoHAWJ1moRoCcn96uC9k
GKGcpJnvNXU5qjuTS25U2VvG5mYoGxpwAQHvfL0qAVNEUA+4xGMmooRMyYLVgdRe
PLif6/JVmPQB5hHW3/B88NjdvNjEBCFOZUyTHbxzi5ublElvPAZSqQdSOnd4MEyC
qV14AlThWI9g51f/ARd4wuybfQlpWvFQceIh1JpbYIc+7OP7KiBEdqSXJDsv0na8
h68LiqesfTnALyGI3T3CRtwOozou9dchXjTsXsmmx4ssiZvf26/RR7TDT1yB5OqQ
D3BE89cVdHI3au19ZCJsBmF49KE8rWwdKa/95i0BedWg29xNn9nbjr3YQK8bsOk5
rWwdUid+aJY=
=EZoe
-----END PGP SIGNATURE-----

--Sig_/q+_O70ObzbDZp1yJD37T1cz--
