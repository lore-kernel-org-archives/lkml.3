Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbaKJMNg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 07:13:36 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55921 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbaKJMNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 07:13:34 -0500
Date: Mon, 10 Nov 2014 12:11:55 +0000
From: Mark Brown <broonie@kernel.org>
To: NeilBrown <neilb@suse.de>
Cc: Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        GTA04 owners <gta04-owner@goldelico.com>, devicetree@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20141110121155.GN3815@sirena.org.uk>
References: <20141108002637.6561.19002.stgit@notabene.brown>
 <20141108003803.6561.57464.stgit@notabene.brown>
 <20141108092622.GC2722@sirena.org.uk>
 <20141110102551.2678d342@notabene.brown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ghgy3zzpkChQqL5M"
Content-Disposition: inline
In-Reply-To: <20141110102551.2678d342@notabene.brown>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/3] ASoC: twl4030: allow voice port to be connected
 externally.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ghgy3zzpkChQqL5M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 10, 2014 at 10:25:51AM +1100, NeilBrown wrote:

> says it is a "reference platform".  Does that mean it is a board with a bunch
> of chips soldered onto it?  If it were a board it should be described by a
> dts file, not by a pile of C code (I thought), so I must be wrong about that.

No, like I say please see previous discussion ad nauseum about this.

> The twl4030 needs to know the master/polarity of the clk/frm lines.  The GSM
> module declares that these are.  So presumably we need some sort of linkage.
> Ahhhh... I found Documentation/devicetree/bindings/sound/simple-card.txt

Or just write a machine driver.  simple-card is one such machine driver
but it's not going to be suitable for non-trivial systems.  Possibly
your system is simple enough, possibly it isn't - I don't know anything
about it really.  Regardless of how you do this it shouldn't have
individual devices needing to open code configuration for links, it's
something essentially every device is going to need to do and forcing
the DT to configure the same thing twice for a link isn't a good idea
either.

--ghgy3zzpkChQqL5M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUYKuKAAoJECTWi3JdVIfQjGkH+wX0fAdnJ788cNfzTWedEw81
K/BjIh8vHOTnCu8h3zx9qi2fM7oYu9ZrocFkJoNaj4XeilDdaEv86mrKB9neV+2r
RELNoX682GmfY/+5dPIc2tD4JHIf8I2mCOqyNyqmsMHwLIlhv8Ihmv9s58GX2Luy
QiLoZzRn5oPzW+eSx6A7fmNx89B3cBgMRMGaykjsFxd/Iwe/iVmLSNz7lgkwJfak
bV3CeIZL7uiHvyp7a2kPbvgyUyOt7KHB90Ej+WbJUcaby2RZx4BEjbkOWVQtXnuQ
EJOC1SgmH9BQiGFhHpSBU7JqKvL906PkozQ69ARAtUf+9H58clXlHFt+7MXmz6Q=
=QAuy
-----END PGP SIGNATURE-----

--ghgy3zzpkChQqL5M--
