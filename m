Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129Ab3GXANh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 20:13:37 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56031 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab3GXANg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 20:13:36 -0400
Date: Wed, 24 Jul 2013 01:13:32 +0100
From: Mark Brown <broonie@kernel.org>
To: Felipe Tonello <eu@felipetonello.com>
Cc: alsa-devel@alsa-project.org, LiamGirdwoodlgirdwood@gmail.com,
        JaroslavKyselaperex@perex.cz, TakashiIwaitiwai@suse.de,
        linux-kernel@vger.kernel.org,
        "Felipe F. Tonello" <ftonello@cercacor.com>
Message-ID: <20130724001332.GW9858@sirena.org.uk>
References: <1374281962-3786-1-git-send-email-eu@felipetonello.com>
 <20130722000157.GI9858@sirena.org.uk>
 <CAGrhNMyAofsnwKYMk+60GyvpaW9pMtoJf_2Q_Tc82G8QCFOiFA@mail.gmail.com>
 <20130723124023.GX9858@sirena.org.uk>
 <CAGrhNMyWXGcDUHxexgvQ2rusKTSbSjEbcEToKZZUudtP-pYxsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XqOulWco09xrjj7X"
Content-Disposition: inline
In-Reply-To: <CAGrhNMyWXGcDUHxexgvQ2rusKTSbSjEbcEToKZZUudtP-pYxsA@mail.gmail.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ALSA: SoC: Added jack detection kcontrol support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XqOulWco09xrjj7X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 23, 2013 at 05:10:29PM -0700, Felipe Tonello wrote:
> On Tue, Jul 23, 2013 at 5:40 AM, Mark Brown <broonie@kernel.org> wrote:

> > This was the existing kernel API at the time that the code was added -
> > I beleive people had been doing that for simple switches that detect the
> > physical presence of a jack since it looks exactly like a button from a
> > hardware point of view.  See the original commit adding the code.

> I saw it. I don't know what you think is the best way to go. I'm not
> sure if someone is using this input event API, since even PulseAudio
> even declined that implementation due KControl implementation.

It's used quite a bit in embedded systems, there are actually patches
for PulseAudio which were deployed for a while - I guess they might have
been removed or something.  The kcontrol stuff was actually implemented
after that was already in place.

> I'm thinking in re-implement core/jack.c using only kcontrol for
> reporting status and leaving input events only for keys (which is
> already implemented). This will break compatibility if any user-space
> checks for jack status using input events, but again, is anyone using
> this?

The jack core should be implementing all three methods of reporting
jacks (input, controls and extcon).

--XqOulWco09xrjj7X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR7xwoAAoJELSic+t+oim9i8EP/izZNeMOqmIDTN83yRbfPWH4
HPrIZD9EAMnmlf52inh8JJ96xf2liIl1xJuMTMbqRmzZdf+Y1IMQgABuDqiysfus
MfASZyDn1KFqQpLu50SuUGa1rOkSgpJb+uEwmM+W+bk0/kEnw2ZuXvquv45OQQaH
2kqdH9ib3JFu3poDwKgBunp4DcZgso/V0LisKDG2Jjr2O3CNDU+fprtzn+may+0O
x9NMmts4U2cNIVAeK5NvkHZOTBXuGpzc3sY1NKobQqk8dA0DiYbQK60Lc6khbkh4
x3HWyvBYMe5Mbs6Kgmxhna3/DXq76lTO51HVFyyurzsjOuraebpgUuCFsz5yU6u0
EAWSlwI3gJ5wJLxE6g0auZQvuUMIfKg/IZBqJPnN7KdXcSUfRa5LapdaCfLT0Xv1
Qi/kSWtL4ou7y0z7MsF7OKTXjyfE5VTCuDsCuF0OUm4gYVs9YYIqKcGqmjwFnEwc
aTqcVB12uegLqGNF2TRbXfJM5ROMpoDfLC818tLI4JIKAQOrX7lgFlnHXsJmvwyN
brA6v0TxDVQwzRBBTytx1obbsdaqwF3OABk6al5CeivXBNozua5Sz7XhNCSIdb0P
dpTOK3CKmmoIgmDjL64Fjdaa7g9iVBMnqzNzJKpH+Ec7rsG1/n9ppmyV9WAcRGyq
VXHktlImFAFtqQXD0mep
=9Xnz
-----END PGP SIGNATURE-----

--XqOulWco09xrjj7X--
