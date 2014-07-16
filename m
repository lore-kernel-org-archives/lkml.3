Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030586AbaGPQrv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 12:47:51 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38698 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030559AbaGPQrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 12:47:48 -0400
Date: Wed, 16 Jul 2014 11:46:54 -0500
From: Felipe Balbi <balbi@ti.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: <balbi@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>, <linux-kernel@vger.kernel.org>,
        <linux-serial@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH 4/5] tty: serial: 8250 core: add runtime pm
Message-ID: <20140716164654.GC3016@saruman.home>
Reply-To: <balbi@ti.com>
References: <1405521903-5877-1-git-send-email-bigeasy@linutronix.de>
 <1405521903-5877-5-git-send-email-bigeasy@linutronix.de>
 <20140716151604.GG1365@saruman.home>
 <53C6A050.2050409@linutronix.de>
 <20140716160614.GI1365@saruman.home>
 <53C6AAE1.7090802@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0/kgSOzhNoDC5T3a"
Content-Disposition: inline
In-Reply-To: <53C6AAE1.7090802@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0/kgSOzhNoDC5T3a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 16, 2014 at 06:40:01PM +0200, Sebastian Andrzej Siewior wrote:
> On 07/16/2014 06:06 PM, Felipe Balbi wrote:
>=20
> >>> well, other than in probe and other functions which need to
> >>> make sure clocks are on, but it seems unnecessary to
> >>> enable/disable in every function.
> >>=20
> >> What do you have in mind? Do you plan to let the uart on while
> >> the minicom is attached but is doing nothing? In that case,
> >> ->startup() and ->shutdown() should be enough.
> >=20
> > no the idea was to keep it on for as long as it's transferring=20
> > characters and idle it otherwise, if that can't be done easily,
> > then I guess your way is the only way.
>=20
> But maybe we have to add some additional logic here to keep it up for
> the transfer. I've been just (maybe over)thinking: If you send 300
> bytes over DMA via 300 baud it should take 10 seconds. The PM-timeout
> could hit before the transfer is complete.

hmm, good point. So we _do_ need a way to get early and only put after
we know transfer has completed and I was assuming stop_tx() to be that
hint, but apparently it isn't.

> Same thing with hw-flowcontrol where you could get stalled for a few
> seconds.
> However it doesn't seem to be a problem in current omap-serial driver.

I don't think current omap-serial driver is a great example.

--=20
balbi

--0/kgSOzhNoDC5T3a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTxqx+AAoJEIaOsuA1yqREGGkQAJGQExdnjH70V1d2k/Ek8VMY
CHpXRdrKBG1vlg7Hhdtuenbr7Rz5RvFt/hR33dUEaRooyVrJY3GWvaP5ykR0PnLe
q0X8VYyimKAslSwjo/fny5IFuhqQv0Uuy2BU78FqgFMnfcQaNiEMz8JPntAdVXMO
Iar7vUzwDlIG1tL6v4UnS1nHOKwgI7bGokTqCkMOEJmdcJ/g3b0X9TESfVkEunUf
Fb0Y7+N5zaE7z1appjBzSI1SNlcYNPO8ArUlLONwrRKM64bUL+o471yXEATtUNVN
jx54eBOIqN8FsZe4EbinbayxCy8ULIcFUq0lEti2Kj0tmFtR3KVuzyaKJeLFGeUI
7aBDQgKQfqb/ur5je3g0sZ4CBa/bNAJ+XKeawO3bzyYH2KJSzxepw1ayCLlqCBtj
ZvWmA+lIVRNDTJ/0cHyeQ7HACx4lvfHSbkmAkujmjYh98Sux/IuRZY1MV2sb9uOp
IPiLP4UDP2J0dLTQfKx90+01jalvqeDSKMOr9zRi5gf/uo6BorpxScGGhx1M9O7T
y+p70bZ9q/l04k9TCf2HVm1AEb8snfnQRDkvhm+AHzuUWCuovldD7i7d/j2iBiIs
TSccADYTsh6qKumjgPnMHzu8gRXDNqXyR4zHajlNEQHIkQOIEfKDcPMLv52dx5IL
3AKNr746/KGIqTBQ22oB
=4A1U
-----END PGP SIGNATURE-----

--0/kgSOzhNoDC5T3a--
