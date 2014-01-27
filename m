Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbaA0Kaq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 05:30:46 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55265 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753847AbaA0Kao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 05:30:44 -0500
Message-ID: <1390818638.2735.136.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH net] net: hyperv: initialize link status correctly
From: Ben Hutchings <ben@decadent.org.uk>
To: Jason Wang <jasowang@redhat.com>
Cc: David Miller <davem@davemloft.net>, kys@microsoft.com,
        haiyangz@microsoft.com, devel@linuxdriverproject.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 27 Jan 2014 10:30:38 +0000
In-Reply-To: <52E634DA.3040200@redhat.com>
References: <1390807854-4469-1-git-send-email-jasowang@redhat.com>
		 <20140127.003559.2290408024387922847.davem@davemloft.net>
		 <52E629A8.5010302@redhat.com>
	 <1390818121.2735.130.camel@deadeye.wl.decadent.org.uk>
	 <52E634DA.3040200@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-56IykHN8/pSwD5rjO7vl"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.239
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-56IykHN8/pSwD5rjO7vl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-01-27 at 18:28 +0800, Jason Wang wrote:
> On 01/27/2014 06:22 PM, Ben Hutchings wrote:
> > On Mon, 2014-01-27 at 17:40 +0800, Jason Wang wrote:
> >> On 01/27/2014 04:35 PM, David Miller wrote:
> >>> From: Jason Wang <jasowang@redhat.com>
> >>> Date: Mon, 27 Jan 2014 15:30:54 +0800
> >>>
> >>>> Call netif_carrier_on() after register_device(). Otherwise it won't =
work since
> >>>> the device was still in NETREG_UNINITIALIZED state.
> >>>>
> >>>> Fixes a68f9614614749727286f675d15f1e09d13cb54a
> >>>> (hyperv: Fix race between probe and open calls)
> >>>>
> >>>> Cc: Haiyang Zhang <haiyangz@microsoft.com>
> >>>> Cc: K. Y. Srinivasan <kys@microsoft.com>
> >>>> Reported-by: Di Nie <dnie@redhat.com>
> >>>> Tested-by: Di Nie <dnie@redhat.com>
> >>>> Signed-off-by: Jason Wang <jasowang@redhat.com>
> >>> A device up can occur at the moment you call register_netdevice(),
> >>> therefore that up call can see the carrier as down and fail or
> >>> similar.  So you really cannot resolve the carrier to be on in this
> >>> way.
> >> True, we need a workqueue to synchronize them.
> > Whatever for?  All you need to do is:
> >
> > 	rtnl_lock();
> > 	register_netdevice();
> > 	netif_carrier_on();
> > 	rtnl_unlock();
> >
> > It would be nice if we could make the current code work with a change i=
n
> > the core, though.
> >
> > Ben.
> >
>=20
> Looks like the link status interrupt may happen during this (after
> netvsc_device_add() was called by rndis_filter_device_add()) without any
> synchronization. This may lead a wrong link status here.

Now I'm confused - if there's a link status interrupt, why are you
setting the carrier on initially?

Ben.

--=20
Ben Hutchings
If at first you don't succeed, you're doing about average.

--=-56IykHN8/pSwD5rjO7vl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUuY1Tue/yOyVhhEJAQrjCA//biMTbPGxReR86S/jyvSTgRD8v7DzxLeC
BKoqfToZEMsnaNj8PS137rfyKUtdd0NfC/crPv1vox5fMftygNc82i0eoDVZJCDn
t/jKYPSWGXZvOqVAWrV6P0VnwJ6YHh2j9lEpzGOt3VNPpDyZDJ47Cp4dqVVrT5c0
TPWLizma8zQqUvVVE97rn6DHJ+l9a68sydRRZRklkT5HKBV7+S+fhzIPYDGDynqt
F73Dom8OvlFxYr4dRIMM34ULUdINDeUT5G/xeksokJXW2GjeNVDBDhA3lQkZEcOo
XUq2N12oPPMb94U7UXnNntCnxDgPFafdWk2eJx4TriYA3NgWCU+su4bOuBY8tR7l
UIR9aXUv7i52jm6aKNXzPD6cPF5ldDn3+l4fUWyWdgRnmjkvtonx1eSQmaLgO+mg
fM8GzMUBN0Hj3kWylGzPyN/8bTyAaIlny4yfWcGmIZ5F++FLHjLyb+racMgjUoKg
uYaJYny6SoFyM7vc0ecxooXSVK4cOBfPkP1PdeCQ8qaR/yKt1nVEmc/nzCwVZfRS
9pu5IykYRWFha5Guc5qtL4Ka4A2sLa+bBK9h003hlr66tohvX1043/mLqazIJsZK
dCZdDSs4uAsKHnqjAx8Plrv0AaBymPAG23EdkoMo1FPk1OGRzmMGdwkpcglyGDQy
OtrX39qjiLA=
=Z9Dz
-----END PGP SIGNATURE-----

--=-56IykHN8/pSwD5rjO7vl--
