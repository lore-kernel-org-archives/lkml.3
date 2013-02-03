Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab3BCXYO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 18:24:14 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38060 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753815Ab3BCXYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 18:24:10 -0500
Message-ID: <1359933831.4538.4.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 061/128] 8250: blacklist Winbond CIR port
From: Ben Hutchings <ben@decadent.org.uk>
To: Sean Young <sean@mess.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Mon, 04 Feb 2013 00:23:51 +0100
In-Reply-To: <20130203172657.GA23690@pequod.mess.org>
References: <20130203144644.035172954@decadent.org.uk>
	 <20130203144649.474239317@decadent.org.uk>
	 <20130203172657.GA23690@pequod.mess.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-mgOg3N+p/VvEG8GHJZiQ"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 109.129.208.115
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mgOg3N+p/VvEG8GHJZiQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2013-02-03 at 17:26 +0000, Sean Young wrote:
> On Sun, Feb 03, 2013 at 03:47:45PM +0100, Ben Hutchings wrote:
> > 3.2-stable review patch.  If anyone has any objections, please let me k=
now.
> >=20
> > ------------------
> >=20
> > From: Sean Young <sean@mess.org>
> >=20
> > commit 65ecc9c02dbad033a73a32916d17c107c5b25031 upstream.
> >=20
> > The legacy serial driver will detect the Winbond CIR device as a serial
> > port, since it looks exactly like a serial port unless you know what
> > it is from the PNP ID.
> >=20
> > Here we track this port as a special PORT_8250_CIR type, preventing the
> > legacy serial driver from probing it.
>=20
> This commit relies on an earlier commit which ensures that 8250 PNP probe
> is done before legacy 8250 probe, else the Winbond CIR device will be=20
> claimed by the legacy 8250 driver rendering above commit useless.
>
> commit 835d844d1a28efba81d5aca7385e24c29d3a6db2
> Author: Sean Young <sean@mess.org>
> Date:   Fri Sep 7 19:06:23 2012 +0100
>=20
>     8250_pnp: do pnp probe before legacy probe
>    =20
>     We first probe the legacy serial ports and then check pnp. If there
>     is a non-standard configuration then this might not work, also this
>     change is needed so we can blacklist Winbond CIR based on PNP ID.
>    =20
>     For this to work the 8250_pnp driver must be merged into the 8250
>     module.

That looks a bit too disruptive for stable.  I added the Winbond CIR
patch because commit ebebd49a8eab ('8250/16?50: Add support for Broadcom
TruManage redirected serial port') textually depends on it and it looked
like a worthwhile fix too.  Since this doesn't do anything on its own,
I'll drop it and rebase the TruManage patch.

Ben.

--=20
Ben Hutchings
Everything should be made as simple as possible, but not simpler.
                                                           - Albert Einstei=
n

--=-mgOg3N+p/VvEG8GHJZiQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUQ7xh+e/yOyVhhEJAQq0pxAAzWRr95x9XRZRIwprcHJQSWhkKyU55bWg
9d61WlIPiN8xf5VHLzEUFjw5HTLgBYG/u1x1eW5ZKyuRZ3mV/g+fihXfa0dTNIuJ
p9Wo85oF4THuMFMhBIRZIzJ6eyD6GuHchD1jrLp2TJjXCf/EWud/ib4JDsZNYQ4K
XIjfpZ8Pw/G8R8YvO6e1KffAGB274v+QVVex1TG8oFkbXIPAmTocY7qLW5l03h4p
rvtThOz8WPsQ2MMfKI2uEGiWXFAugp1tqWyM1gas5MpudUqarNneIP7OvGXgGYeA
X2RYz0gPGelka1QXpb/YHEkyjxonZHMBcsF7UVM3UrUwVAvwEC4szSX/206VkHwv
Zgo/F+nkms/bbuVedix8KJ0o6SoQFiakLZmOXSNirWGvapIIDcg/bDYvdsSslVI1
kVYec+NyYr4qE77GcbGBM7Q4yHdPOZSjioNO+paj7bWgNF/EQSCMG6bmwZPAZ6dE
qNdRwzCUnKxH1I6tioWadJHFB1wtRXwTpGSuQvPNAT8cpYbnR+LwUhXAKukpZCre
71Tl5Xv/kofIu/8h4NiIqnFvjSzpJ83w6QLbv5EDsdoktO8hMLudV+GMVAWdV4ND
JmmdDxMGkC0iQK44YEq2G+h5G8HJiIE7DT4IrDj2OqqQLnmqlXQlMenjblNT5+JT
d4J0+Kpkgbc=
=oSiH
-----END PGP SIGNATURE-----

--=-mgOg3N+p/VvEG8GHJZiQ--
