Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031Ab3JaFAD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 01:00:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48393 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762Ab3JaFAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 01:00:01 -0400
Date: Thu, 31 Oct 2013 15:59:46 +1100
From: NeilBrown <neilb@suse.de>
To: Mark Brown <broonie@kernel.org>
Cc: Alex Courbot <acourbot@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: Any news on Runtime Interpreted Power Sequences
Message-ID: <20131031155946.1890db5a@notabene.brown>
In-Reply-To: <20131029161816.GE16686@sirena.org.uk>
References: <20131025112224.6e5265e6@notabene.brown>
	<526A0E71.100@nvidia.com>
	<20131025183345.2b963e13@notabene.brown>
	<526E3605.9080002@nvidia.com>
	<20131028221004.3294c1ea@notabene.brown>
	<20131028235344.GB16686@sirena.org.uk>
	<20131029111037.6e59499d@notabene.brown>
	<20131029161816.GE16686@sirena.org.uk>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/c0=jz=PETIeV2VI21Sc2D/y"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/c0=jz=PETIeV2VI21Sc2D/y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 29 Oct 2013 09:18:16 -0700 Mark Brown <broonie@kernel.org> wrote:

> On Tue, Oct 29, 2013 at 11:10:37AM +1100, NeilBrown wrote:
>=20
> > Yes, the device is soldered down and has a reset line that needs to be =
pulsed
> > low at about the same time that the MMC port enables the regulator.
>=20
> > How do you propose that I describe this?  Which driver should know abou=
t the
> > reset GPIO, how to I tell it about the GPIO, and which function should =
do the
> > pulsing?
>=20
> I'd expect the driver for the device to know about this, obviously
> depending on what this actually does it might want to use this at
> runtime (for example, putting the device into reset to minimise power
> while it's idle).  We really need a generic way for devices such as this
> on enumerable buses to run before the current probe() in order to allow
> them to manage their power up sequences in embedded systems, this is
> *far* from a unique situation.

I agree.
To me, this sounds a lot like saying "We need a way for enumerable buses to
be given a power-on-sequence to power on the attached device".  That is what
I hopped RIPS would provide.

Maybe various devices could allow other devices to register for call-backs
when the first device activates or deactivates a port  (whether an MMC port=
 or
USB or Serial or whatever).
Then a driver that needs to control the power-on sequence would register as=
 a
platform-device which registers a call-back with the appropriate parent and
performs the required power-on/off.

Does that sound like the right sort of thing?

NeilBrown

--Sig_/c0=jz=PETIeV2VI21Sc2D/y
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUnHjwjnsnt1WYoG5AQKLeQ/9Fbha3G5j+rFNPQXaFybC7g0tQg5rsoH/
3p/Xl26RTTJO5iWlTXmgWYRPbMzrkHuB2Ozmz0NfEIYgluTdutFP2MSvKlG7IC0o
IM3TbATXG+B8vJwmqQ61nONAB2APtq7UQOxN8IhM8Q44jB1QiitETuElTVDwTa9Z
JwTviW7mNlRElLGu10TP6R5VCRjZjNHDuhkCxfD1sih2LvKxFRC6JUY5lP9tgeJf
tK3Wr74P4A0oyXM6SGYcKRrhbPdkrQ72Sf54pU1WUVtv0N/nLN9sYGw1agVmoHa7
Li+Pn6ey874Hd7+XIHQroHW6MZP3dfvApUDBeo7LmhjsX/Ve6YJIaXEuKdXuw1KA
GjfpVb64SCv/q4nwuYOkgOeCwnKFLzo6BNTH8GhEiAmUcFs+idTqzKO1wBE9p1XV
xzumnJOgpmjL5bV1H2s8mCz1DqvK0G2xn8+G6USmEHogsVOKnG7VBMutxfaa2Mbg
RpahIIde3Q/ofxwSECkjejokzMU5PsDGdW5r711fWq3xHxMUZLYHK7iGLpwqqNv/
C9GcTz09Zv0LPSS3DDIc9XQhQr5Ahrchuu8jvsucJ5EDN3gcoZozoJCeV9IwptSy
h2Ukz7rxks0CB12McsbVAM8shg/zv6thGHgMXZMmDbQnDRp8kOHfJyUs8dWAVLbE
jTHp/wH7nhM=
=AwJp
-----END PGP SIGNATURE-----

--Sig_/c0=jz=PETIeV2VI21Sc2D/y--
