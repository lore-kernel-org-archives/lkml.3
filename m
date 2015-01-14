Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422AbbANMCq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 07:02:46 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56706 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbbANMCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 07:02:45 -0500
Date: Wed, 14 Jan 2015 12:02:28 +0000
From: Mark Brown <broonie@kernel.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "Wang, Jiada (ESD)" <Jiada_Wang@mentor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "Frkuska, Joshua" <Joshua_Frkuska@mentor.com>
Message-ID: <20150114120228.GT4160@sirena.org.uk>
References: <857E9EDCA6C0904DB3357321AA9123EB0108B66919@NA-MBX-01.mgc.mentorg.com>
 <s5h1tmyiof7.wl-tiwai@suse.de>
 <20150113215412.GS4160@sirena.org.uk>
 <s5hr3ux24em.wl-tiwai@suse.de>
 <54B625A8.8090406@metafoo.de>
 <s5hoaq121gh.wl-tiwai@suse.de>
 <54B63E4F.2010506@metafoo.de>
 <s5hwq4phbzr.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="REOXmE5zpOGz6VLu"
Content-Disposition: inline
In-Reply-To: <s5hwq4phbzr.wl-tiwai@suse.de>
X-Cookie: Keep out of reach of children.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] unload Audio drivers while playback stream is
 active case kernel crash
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--REOXmE5zpOGz6VLu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 14, 2015 at 11:50:48AM +0100, Takashi Iwai wrote:
> Lars-Peter Clausen wrote:

> > > OK, so it's not about active stream.  From the reporter's description,
> > > I supposed that the module gets unloaded while playing a stream, which
> > > shouldn't be allowed.

> > Well one of the ways to trigger this is to remove the module while the=
=20
> > stream is active. But it is not exclusively a problem module unload pro=
blem.=20
> > E.g. the same happens if you hot-unplug the ASoC card.

> Yes, unbinding can trigger a similar problem, ends up the same bad
> code path.

Right, which was my point - we need to be able to cope with the driver
being removed while in use, unbind is just one path where this could
happen and the issue isn't specific to unbind.

> > I don't think that we need to prevent module unload when a stream is ac=
tive.=20
> >  From a framework point of view is not different from hot-unplug. I don=
't=20
> > see a reason why we'd jump through hoops to actively forbid removing th=
e=20
> > module once it works just fine.

> Well, the module unload means a more drastic cleanup.  Even if you
> unbind, the code and data are still there while module unload may
> clean them up all.

> Above all, disallowing the module unload while using is the common
> behavior of any other drivers.  Why do we have to be a rebel against
> all civil manner? :)

That's not true for everything and for ASoC I'd tend to assume that the
user knows what they're doing and has a good reason for it; it's
certainly something that can be helpful in development.

--REOXmE5zpOGz6VLu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUtlrUAAoJECTWi3JdVIfQ5rwH/3nUusP2FRdhMCavIle/Fr/N
TjrE2/6TmIyQuRT7EvNKIyyxZ2sMdNngmJhzRH9HHvDbxjKR/8wmZG2jxgwDRiOf
MnmmFHBuh+O8D8mDJG7QHSjqhrVxF2BYuRyR+B9M2ZkryT5Lj7EaKzhya7fqlY0U
mk0+rrlnNEoKX9S/jP+yGsV3fvENdVBmII5YsVV6EV3FCXXS1Zudd/9DudSjjdIt
K2Xpr1vU4Qn2uafZhJypzU4mY05s5JqQjlEp5BXKCDk7EhKX0W97z4L0+zY1SA9w
58bGm9kD006UBdOuM52IoOBffVDZdSclg3mTpmCxxSUxBuQRNmjcU1wxoG0cElI=
=dfRY
-----END PGP SIGNATURE-----

--REOXmE5zpOGz6VLu--
