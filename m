Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbaLDLwL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 06:52:11 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48085 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420AbaLDLwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 06:52:09 -0500
Date: Thu, 4 Dec 2014 11:51:38 +0000
From: Mark Brown <broonie@kernel.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Darren Hart <dvhart@linux.intel.com>, Ben Zhang <benzh@chromium.org>,
        alsa-devel <alsa-devel@alsa-project.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Bard Liao <bardliao@realtek.com>,
        Oder Chiou <oder_chiou@realtek.com>,
        Anatol Pomozov <anatol@google.com>, Dylan Reid <dgreid@chromium.org>,
        flove@realtek.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <20141204115138.GU7712@sirena.org.uk>
References: <1416034608-24238-1-git-send-email-benzh@chromium.org>
 <2127240.rWRTDu6LHQ@vostro.rjw.lan>
 <20141129115209.GD7712@sirena.org.uk>
 <1820241.GUleD5gbzs@vostro.rjw.lan>
 <20141204111234.44C0FC40874@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="q1e9gQ/ARJj/k4o3"
Content-Disposition: inline
In-Reply-To: <20141204111234.44C0FC40874@trevor.secretlab.ca>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] ASoC: rt5677: Add ACPI device probing
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--q1e9gQ/ARJj/k4o3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 04, 2014 at 11:12:34AM +0000, Grant Likely wrote:
> On Sat, 29 Nov 2014 23:27:52 +0100

> > There basically are two ways around that.  The first one is to have all
> > knowledge related to device IDs in drivers (which effectively is what
> > Windows does and which implies "board files" of sorts) and the second one is
> > to make it possible to use overlays on top of the existing ACPI tables that
> > will allow people to provide the properties expected by a more generic driver
> > (this way, if the vendor didn't care to provide _DSD, for example, in the
> > original ACPI tables, the system integrator would be able to use an overlay
> > in an initramfs or boot partition to amend them).

> Either approach amounts to pretty much the same thing. The
> kernel/distribution needs to carry around device specific driver data
> which is exactly how we've supported x86 hardware. Whether the data is
> in-kernel or in-userspace is kind of an implementation detail. :-)

This isn't entirely what we've doing for x86 up until now - there's always
been an expectation that the firmware will be setting things up to work
by default (or so we can read the setup back from the hardwaer when we
take over) and we're mostly just carrying quirk data when that doesn't
pan out.

> _DSD support is a different situation though. Even if Windows doesn't
> care to directly support _DSD, drivers are free to use _DSD properties.
> This is the scenario where the shared binding repository will be
> important.

Right, this would be ideal for the devices we're looking at.

--q1e9gQ/ARJj/k4o3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUgErKAAoJECTWi3JdVIfQqzoH/3kp45j+8QfDzEGHBssTIH7f
80j5xhSIYlEv/fJ7koaVYuP8uhTIsm6EkxT3G9TPqaYwujTFIfSJYKD/JAw4aLXb
sWoCbmGIcaoNithOzUlkmMGXX1zDfFM/lAtC7IDbbLV6hlU1lNMIBrvSiQwREdrS
PFLYtzfpHONsnXBQoVObQyzjhiubk7VT8HNp2v/M/cB+T1QCpnW8ZB8ttcc6ujpd
vBzCwr2wOs/a5fMNBpvRp2ptGAYnYJ4P1z9z+gBcg2vFIOEHEff76BeKDHiCMXBn
QuSKqgos3n5VFcIQwpI/kRN1YDUsUpHqM9NePcFLJUEfvbY3xgCNAsQI00aYsDY=
=Mx5W
-----END PGP SIGNATURE-----

--q1e9gQ/ARJj/k4o3--
