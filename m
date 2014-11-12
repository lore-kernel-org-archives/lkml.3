Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbaKLR2E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 12:28:04 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35214 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568AbaKLR2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 12:28:01 -0500
Date: Wed, 12 Nov 2014 17:26:36 +0000
From: Mark Brown <broonie@kernel.org>
To: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Message-ID: <20141112172636.GO3815@sirena.org.uk>
References: <20141112111835.GA12635@opensource.wolfsonmicro.com>
 <20141112113541.GD3815@sirena.org.uk>
 <20141112130735.GA16426@opensource.wolfsonmicro.com>
 <20141112145802.GK3815@sirena.org.uk>
 <20141112165856.GA30010@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xf33TQxjaCq0D/bC"
Content-Disposition: inline
In-Reply-To: <20141112165856.GA30010@opensource.wolfsonmicro.com>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: export function to check if regulator
 always on
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xf33TQxjaCq0D/bC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 12, 2014 at 04:58:56PM +0000, Richard Fitzgerald wrote:
> On Wed, Nov 12, 2014 at 02:58:02PM +0000, Mark Brown wrote:

> > > > and I'd also like to understand why this is
> > > > a better approach than using a callback to postpone these expensive
> > > > operations until the regulator is actually powered off like we already
> > > > do for some things like register cache resyncs.  That is normally better
> > > > since it also avoids the work in cases where the regulator isn't always
> > > > on like reenabling during a delayed powerdown or shared regulators.

> > > The runtime_suspend() for the Arizona drivers has to do a bunch of
> > > preparation before disabling the DCVDD regulator (and there's more
> > > preparation steps that need to be upstreamed). There's no point doing
> > > any of this if at the end the regulator isn't going to switch off.

> > I'm not sure that this addresses my concern about postponing the
> > expensive work until the regulator is actually powered off at all?

> The point is that the work we want to avoid has to happen while the
> regulator is still powered up. We can't just rip power from the codec,
> it has to be setup ready for the DCVDD to be turned off. So it's
> pre-power down work we're avoiding by knowing that a power-down will
> never actually happen, it's not post-power-down work.

I'm sorry but you're still not addressing my question - to repeat, my
question is why this is better than postponing these expensive
operations to a callback at the time we want to power off.  You keep
saying that you want to avoid these operations when they're not needed
but that's not what I'm asking about, what I'm asking is why polling
this particular possible reason is better than a notifier?

--xf33TQxjaCq0D/bC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUY5hLAAoJECTWi3JdVIfQBgkH/1hhOehhB14Q9T7qHMlXT2pl
xq14FhMwN+pyqWj7kOT0gIvGB9FAdHkQemJw9VNhPUA/PE8eGchCg8jwnsK8XElG
vbsubygMWpkdi4YXtidiKocrrpkvBOvjEPa+4tkeQ/2ue0K7PWD6P7tXDKCqG9WY
zghc0yL8GNTRQXMCwzU3c+VrL854jjjCT35Vi4a+nSLRSDjmxH9hzVvbuC10mDap
GA7fVNqW22YQkc6aT5HGA8jlAeCH0sPrf00Sbw2ntji0hw0bmtXnEl3PDTTHDEZt
Cfj2Vp/tjWA9wmVWWfrPNH90DVqXupU7cQexGJphgLJXjwkLmKK3MzKiA1+gSGs=
=dKdE
-----END PGP SIGNATURE-----

--xf33TQxjaCq0D/bC--
