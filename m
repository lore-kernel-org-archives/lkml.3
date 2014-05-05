Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295AbaEEEfK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 00:35:10 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35445 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750882AbaEEEfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 00:35:08 -0400
Date: Sun, 4 May 2014 23:27:26 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Wim Van Sebroeck <wim@iguana.be>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>,
        Jonas Jensen <jonas.jensen@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/5] watchdog: Add API to trigger reboots
Message-ID: <20140505042726.GF11606@lukather>
References: <1398958893-30049-1-git-send-email-linux@roeck-us.net>
 <1398958893-30049-2-git-send-email-linux@roeck-us.net>
 <20140503012243.GG4090@lukather>
 <20140503042925.GB5882@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lIrNkN/7tmsD/ALM"
Content-Disposition: inline
In-Reply-To: <20140503042925.GB5882@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lIrNkN/7tmsD/ALM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 02, 2014 at 09:29:25PM -0700, Guenter Roeck wrote:
> > > +	if (wdd->ops->reboot)
> > > +		wdd_reboot_dev =3D wdd;
> > > +
> >=20
> > Overall, it looks really great, but I guess we can make it a
> > list. Otherwise, we might end up in a situation where we could not
> > reboot anymore, like this one for example:
> >   - a first watchdog is probed, registers a reboot function
> >   - a second watchdog is probed, registers a reboot function that
> >     overwrites the first one.
> >   - then, the second watchdog disappears for some reason, and the
> >     reboot is set to NULL
> >=20
> I thought about that, but how likely (or unlikely) is that to ever happen=
 ?
> So I figured it is not worth the effort, and would just add complexity wi=
thout
> real gain. We could always add the list later if we ever encounter a situ=
ation
> where two watchdogs in the same system provide a reboot callback.

The A31 we were discussing about in the other thread that doesn't have
a watchdog driver yet has four, identical, watchogs. I'm not really
concerned about the mentionned issue, since they will never be
removed, but the situation might happen with an on-SoC watchdog and an
i2c one (if that even exists).

But yes, right, that can be postponed.

> > Or maybe we can just use the start callback, with the min timeout alrea=
dy
> > registered, and prevent the user to kick the watchdog.
> >=20
> Doesn't always work, unfortunately, even now. The moxart driver causes=20
> an explicit and immediate reset. Also, some watchdogs don't reset the sys=
tem
> directly but get an interrupt, which then calls the reset handler. Which,
> in our case, would call the start callback again, and you would have an e=
ndless
> loop.

Ok. You have my Acked-by then.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--lIrNkN/7tmsD/ALM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTZxMuAAoJEBx+YmzsjxAgyb8P/R0wnWr3R5aVKDnkFhoY28CW
1FdXUsvfG9zZaMyyG+rFoRZiPRJ8y3FjeigohT9KUdLMyBLdMFFLfTUNmmJZVS5N
/8WskFzua2EtUFPY+VbETrHb0QUX/Swhth+JswYr1g17GeM87bbEDrvZRptEDi7K
38F3RKDsjsAIQ4KG32eFaUWU5FBZ1aqp0qEXNiAibsVVu7APjCUmr8KTbHbQFBbM
L2pCMFdt+yEC+bavufTjdImfAEcZD+Pf3tfBdnH5QavdlrL+eRSu35I/ttRINLuN
9wiS4a0nZ8Sufiy1JyJ3ky3mjv7mnL0jAvV/0/YBVIAYBTHArx+iI6/r0qUFQo0T
lXLEP9LvRweQgncrAAKjNBrtVyuGj2uynWJobcfO7HmWAcWSZDtB7OqX2/FvL39e
eZJVgticJLcC6bli//N9YVsdSvLpk4trLgRhRv6XnFLZ97/4sE5FsK8Y5gWw1Yt6
bicpRfbErs2gPsA/WzYQ4vKza3rpMuUNpn6hPcFjbqD7GfWvSGXAFiKoMxC3lXTn
wprysQrTUozpphCz1qEqkJVj+DvXF9j/xKPEuvxv8BBcVRYCID50H97C6GMNdXvY
SWet99rwQJl9VJ5n8/qHARH6+fZaJrbEmsQ9ghWjNXy/D9lHZI+tZ/Oy5ljnZpcK
3uqCqnrydLZQoP0SRPCR
=MgzF
-----END PGP SIGNATURE-----

--lIrNkN/7tmsD/ALM--
