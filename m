Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbaKJKuq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 05:50:46 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55552 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbaKJKum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 05:50:42 -0500
Date: Mon, 10 Nov 2014 10:48:57 +0000
From: Mark Brown <broonie@kernel.org>
To: NeilBrown <neilb@suse.de>
Cc: Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        GTA04 owners <gta04-owner@goldelico.com>, devicetree@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20141110104857.GK3815@sirena.org.uk>
References: <20141108002637.6561.19002.stgit@notabene.brown>
 <20141108003803.6561.52497.stgit@notabene.brown>
 <20141108092756.GD2722@sirena.org.uk>
 <20141110105438.39cff12b@notabene.brown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CZI63rpYmK/igF6U"
Content-Disposition: inline
In-Reply-To: <20141110105438.39cff12b@notabene.brown>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/3] ASoC: twl4030: enable routing audio to 'voice'
 interface.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CZI63rpYmK/igF6U
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 10, 2014 at 10:54:38AM +1100, NeilBrown wrote:
> On Sat, 8 Nov 2014 09:27:56 +0000 Mark Brown <broonie@kernel.org> wrote:
> > On Sat, Nov 08, 2014 at 11:38:03AM +1100, NeilBrown wrote:

> > Given your previous patch are these trying to control a digital link by
> > any chance?  If they are they should be removed, and in any case this
> > sort of thing looks like a machine driver issue.

> Depends on what you mean by "control".
> They declare that a digital link is, or is not, active so that the related
> amplifiers, DACs, etc can be powered up or down.

OK, then the driver needs to be fixed so that this is an actual DAI and
not analogue.

> If I shouldn't have these controls here, where should I have them?  How
> should I turn on/off the widgets that drive the VOICE interface?

Via AIF widgets, supply widgets or something else.

> You say it looks like "a machine driver issue".
> alsa/soc/machine.txt says that "machine" is a synonym for "board".
> I thought we were getting rid of board files and replacing them with
> devicetree.  You seem to be implying that we are keeping board files (under
> the name "machine driver") for the audio config.

> Is that correct?  What is the reason for that?

Yes.  The board design for advanced audio subsystems (like those found
it smartphones) is non-trivial and worth representing as a device in
itself.  Please see previous and repeated discussions on list, I'm fed
up of having to go over this with everyone individually.

Note also that even where some generic code that applies to multiple
boards is used you *still* need something out side the driver to join
everything together.

--CZI63rpYmK/igF6U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUYJgYAAoJECTWi3JdVIfQcWkIAINO92rT21TfsLAlqYQUfaat
FCJIc7z+G+5r5V3LZGBjdhksa+HwpQsPiEQA74JgzE34OmVOiUxc+lBhRmTjB0w2
O1wfD2+dLRLKcJg9/f1Tf+klAP+F6aetxz/0STzQlu8KAu5vL6gtEg4ZJVj+HNm/
rcV1K/tSNgwtf1/4p8UCJVY9JlGKUcbLQSppIf2T7MZ1m2hibGZZy8eX/Z4i4iGR
RckMemVzJzww+VFPD1ZYeTG5DuM+KtyHvxQMNw9IZIXc26NRgv5AAzeUZpCEYxnq
AvRJPCQHPsPUBVpLBzc78wHAlkDHz2ef0X4hx5+m19BEl+EioQyRpiCsaGJ4DU0=
=Crrp
-----END PGP SIGNATURE-----

--CZI63rpYmK/igF6U--
