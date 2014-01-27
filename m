Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbaA0KWL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 05:22:11 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55224 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753526AbaA0KWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 05:22:09 -0500
Message-ID: <1390818121.2735.130.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH net] net: hyperv: initialize link status correctly
From: Ben Hutchings <ben@decadent.org.uk>
To: Jason Wang <jasowang@redhat.com>
Cc: David Miller <davem@davemloft.net>, kys@microsoft.com,
        haiyangz@microsoft.com, devel@linuxdriverproject.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 27 Jan 2014 10:22:01 +0000
In-Reply-To: <52E629A8.5010302@redhat.com>
References: <1390807854-4469-1-git-send-email-jasowang@redhat.com>
	 <20140127.003559.2290408024387922847.davem@davemloft.net>
	 <52E629A8.5010302@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Pm0nFb8yzSmiCkblxa3B"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.239
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Pm0nFb8yzSmiCkblxa3B
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-01-27 at 17:40 +0800, Jason Wang wrote:
> On 01/27/2014 04:35 PM, David Miller wrote:
> > From: Jason Wang <jasowang@redhat.com>
> > Date: Mon, 27 Jan 2014 15:30:54 +0800
> >
> >> Call netif_carrier_on() after register_device(). Otherwise it won't wo=
rk since
> >> the device was still in NETREG_UNINITIALIZED state.
> >>
> >> Fixes a68f9614614749727286f675d15f1e09d13cb54a
> >> (hyperv: Fix race between probe and open calls)
> >>
> >> Cc: Haiyang Zhang <haiyangz@microsoft.com>
> >> Cc: K. Y. Srinivasan <kys@microsoft.com>
> >> Reported-by: Di Nie <dnie@redhat.com>
> >> Tested-by: Di Nie <dnie@redhat.com>
> >> Signed-off-by: Jason Wang <jasowang@redhat.com>
> > A device up can occur at the moment you call register_netdevice(),
> > therefore that up call can see the carrier as down and fail or
> > similar.  So you really cannot resolve the carrier to be on in this
> > way.
>=20
> True, we need a workqueue to synchronize them.

Whatever for?  All you need to do is:

	rtnl_lock();
	register_netdevice();
	netif_carrier_on();
	rtnl_unlock();

It would be nice if we could make the current code work with a change in
the core, though.

Ben.

--=20
Ben Hutchings
If at first you don't succeed, you're doing about average.

--=-Pm0nFb8yzSmiCkblxa3B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUuYzSee/yOyVhhEJAQrwKRAAoNT8UQO+OLP1w55+PzAoFerVeTBYn2e0
jX0ExDZ2U/z08Wqfy6MD/wJ725j5QDLTaMssuaKxA4G07bVwUT58fwk3/dlYZzsS
NmQECLZtXojRScp4FBASMbOW4Rm9Gu7m6gEqi4gtYg1Prj2B6XaYEboVxOsnJ3Pg
LcBgCoeIIoSb31kbFZmz+CsBAOYBxL+gv0DID2cg8USK/DT9nfD/LSWqY8DroXDz
GlUwtUmKFkPkIA+BCKn9pxL76S+wxR1QBqsuZywdZnTT/75e3qtEam/dpzWxh4Jz
PHcqnSliP4Vh4dIJq7SYYoRjqNH+649jyj4MFwrtBbU66GOFlEdjDNaLVxufZbr5
iJOazhuUBhFtQvJy6fFS6IdyWYH4jKnvJ59IzrRAEsETifxydf0j0ikksgBfvKrh
HgungN03288vuvcR6QOgHngN86DSpa3Jy1bRofr5HWqJzYTAussSfaVsiFgzBp0Z
k5fRxhpvXGFe5S/ig61pOrkl7Ws1PZupWfLElqL4W6fpMTy17KTjyllZWIRINL7W
b5lNfz7s9Q7xhxsmu5HJCHXFGaHrUJtQ75j1MOeViaJViEXQsbj4oA0olluNaGXc
2NiN2O0GZaaCIWWjy0ybXxuNNhdxlr+coaK34gw/CYkgbpuk7Sze1ouHkX1LaKZZ
UpuTrllg+Zs=
=2ynY
-----END PGP SIGNATURE-----

--=-Pm0nFb8yzSmiCkblxa3B--
