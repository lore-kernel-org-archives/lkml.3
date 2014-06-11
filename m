Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502AbaFKPiK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 11:38:10 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37232 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbaFKPiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 11:38:08 -0400
Date: Wed, 11 Jun 2014 16:37:43 +0100
From: Mark Brown <broonie@kernel.org>
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, Suman Anna <s-anna@ti.com>,
        Loic Pallardy <loic.pallardy@st.com>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Craig McGeachie <slapdau@yahoo.com.au>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Rob Herring <robherring2@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Josh Cartwright <joshc@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kumar Gala <galak@codeaurora.org>, Girish K S <ks.giri@samsung.com>,
        Jassi Brar <jaswinder.singh@linaro.org>
Message-ID: <20140611153743.GI5099@sirena.org.uk>
References: <1400134105-3847-1-git-send-email-jaswinder.singh@linaro.org>
 <1400134260-3962-1-git-send-email-jaswinder.singh@linaro.org>
 <20140521172701.GV12304@sirena.org.uk>
 <CABb+yY0G9Rn4mzA7Cn4__tR02WE4Q6-RQfQ06U6Kiiayey+RXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i8qr5UOnfIfOw794"
Content-Disposition: inline
In-Reply-To: <CABb+yY0G9Rn4mzA7Cn4__tR02WE4Q6-RQfQ06U6Kiiayey+RXA@mail.gmail.com>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv5 2/4] mailbox: Introduce framework for mailbox
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i8qr5UOnfIfOw794
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2014 at 09:50:21AM +0530, Jassi Brar wrote:
> On Wed, May 21, 2014 at 10:57 PM, Mark Brown <broonie@kernel.org> wrote:

> >> +     if (!cl->tx_tout) /* wait for ever */
> >> +             cl->tx_tout =3D msecs_to_jiffies(3600000);
> >> +     else
> >> +             cl->tx_tout =3D msecs_to_jiffies(cl->tx_tout);

> > Is the default wait for ever the best timeout - I'm not sure it's best
> > from a defensiveness point of view.  It should be fine either way,
> > it's just a matter of taste.

> The client wants the call to be blocking. Out of 'zero', 'infinity'
> and some 'valid' delay, it makes better sense to have 'infinity' than
> zero or another value that might be valid for some platform. I assume
> 1hr to be 'infinity', though I am open to better suggestions. Maybe
> put a WARN() ?

I think my inclination would be to have the client required to specify
what it thinks is a sensible delay and complain loudly if nothing is
specified.  Having zero default to wait for ever (as opposed to
something like a negative number) means that if someone memset()s the
struct (as people tend to) then if things go wrong the system will tend
to run into long timeouts which tend to give an unpleasant experience if
things go wrong. =20

Forcing the user to think what a sensible delay is seems likely to
ensure that sensible values are picked rather than people not thinking
about it at all since if everything is working well and messages get
answers it's OK.

Sorry about the delay in replying here.

--i8qr5UOnfIfOw794
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTmHfEAAoJELSic+t+oim9KdsP/R+UD9Q0AWC5/SF8sai5/K3L
+kgmtBAqeaXg71CilDifIAtV4t303AcyHN/m2jKNsieFdTKN0bYbLzPB2+hQ1vBV
gn4yphB5usKI2Vwv/MsAMuOXEhK+0ZUiu+xFFB73TV9FzvhemfXCIlXuseAp4HSB
o6UoNLX/enRpnhDSFKIshWcjuY2FLd9Nugitz51F9ylBsfNDPCqxMwSMXnW03T9C
oNv8B5RIBNhGVTX2VoNY0/P3zrpOcY72+EGJ0kp+hbbi31JQgZ4jzY8Aj7XreVGT
worWbCWUHm32QvBaUtG6ekXl/jtQLbG5CkthmcC9TpOxuvfrx6I+JsoFgyYmukRv
8tt27gICCXb/4WT0FHHh/P7nIV1wRQ/rPAEWaDcwIsjwpefWwpzStf6SuwCF3Hxe
AT4i02maW3j9uuBRbStutKhtCI/Pu3442cL3DWVZOdBXYsGPnYLYKUnkVAnRhQv0
v1x1bNyZVZln7R4mQda9P2pr7Sn2pDhbrPs7+0Ui+AhF+sxbH0Ken2f2dtytzN4i
0OuGLr+QAlByqtr3MRW1IZ+AkxExShmmmr0dZBlsNFohXwDAzfDwXuvPOoaILXsk
j48NKLGfBHKj2bN1Mf8dMkeWGAL/Hk6AihLTjTh+k/e+9WRIyhp1WUwv/+lEy057
I5jbG/3UI2vGXEwYLkEN
=6orh
-----END PGP SIGNATURE-----

--i8qr5UOnfIfOw794--
