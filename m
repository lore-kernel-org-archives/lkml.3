Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbaCMVVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 17:21:19 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54975 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbaCMVVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 17:21:17 -0400
Date: Thu, 13 Mar 2014 21:20:55 +0000
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <Guangyu.Chen@freescale.com>
Cc: Jyri Sarha <jsarha@ti.com>, mark.rutland@arm.com,
        devicetree@vger.kernel.org, alsa-devel@alsa-project.org,
        kuninori.morimoto.gx@renesas.com, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, Li.Xiubo@freescale.com,
        linux-doc@vger.kernel.org, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org, rob@landley.net,
        galak@codeaurora.org, moinejf@free.fr
Message-ID: <20140313212055.GN366@sirena.org.uk>
References: <1394593331-22867-1-git-send-email-Guangyu.Chen@freescale.com>
 <5320280C.6080004@ti.com>
 <20140312093353.GH1177@MrMyself>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="c6397Mob2532IpCX"
Content-Disposition: inline
In-Reply-To: <20140312093353.GH1177@MrMyself>
X-Cookie: Some assembly required.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH v2] ASoC: simple-card: overwrite
 cpu_dai->fmt with codec_dai->fmt
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--c6397Mob2532IpCX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 12, 2014 at 05:33:54PM +0800, Nicolin Chen wrote:

> I'm not sure if there's any defect from this idea, but as long as we
> keep DAIFMT settings identical for both dai-link ends, it'll be a
> neater way.

> So I'd like to pend this patch and wait for further solution from that
> topic.

My understanding of the binding had been that exactly one of the devices
on the link would have each master flag set and the code was parsing
both devices together in order to come up with the setting.  Obviously I
didn't check the code closely enough here.  It seems that the Renesas
devices actually do this, though just due to a bug in the master/slave
handling.  The patch you posted would essentially implement that
(without validating the settings on the CPU side, but that could be
added).

The above suggestion would also work though it *is* a change in the
binding and right now we don't have code for it.  We need something here
very soon, the merge window is going to open shortly and we ought to
avoid having the problematic code in v3.15 if we can - indeed I'd really
prefer to get something into v3.14 if possible (though this patch
doesn't apply cleanly there and it's *very* late).

Thoughts?

--c6397Mob2532IpCX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTIiE0AAoJELSic+t+oim9MTwP/iIqldFiWtJrJf0jh4W9uJ3A
gl3AVyXfFJ2K9IL/vaOdISreKa8DBqDrXbKTyofGL6WSC79jvKdgVQpOvTH+2fYm
M6wXR/Z6KZCujdPPbe92W3mbfhvVbJ31tOX/asDn5KkBKxwaYUml0Pxqno1NG7fi
UuO5biq4t9v7ofdkK99CareN11Lvgn+IFqsafRnT222YJx6bFzCgYgQaftbjxa/9
NxQvFKYK/SH+PUifH9nnqYKEwZzWmHjPFTNfEE6SuQ5gZ11ZK5/sAeRblgr079YH
j/8uOuizME3cuwo21qqrRWz72gBOVp5X/pBPFzoalz+Fu5jWtg4xBfwvauileSHJ
Lgzr+9RlY4JgtAa+7HnHV9QteVCceYbEefe/hEl+AhKiayLUge66+TiUJLhueno6
Xtiz/syOYirPkBbIRmiJmWLZ0wTb9YMlCh4Wq1lr+KZ+huY/uyrjupRC9DotRPVZ
YI3DCSxa1H+XhtDTPftcW2Wqg4hrbfoCVQ14Er2Hg/awLsxQ2afdRA8LAMDCN0gX
C3oItFUSvrnTjnp7W8t7XCuIrvD1cmDGKK71IKdJVMY+R+j4xQgNnUXY/L++gHgZ
mnqBOe9M3TMRHBrIAnJrEwDgUOfkdybkxuiiSXB8wu0CNfG4IcRiOi4XZNrZgVjh
EK1ytWVQR3v7tlUYmU+p
=ZYFF
-----END PGP SIGNATURE-----

--c6397Mob2532IpCX--
