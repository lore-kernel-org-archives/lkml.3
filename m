Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbaJ1ATa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 20:19:30 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51937 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbaJ1AT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 20:19:29 -0400
Date: Tue, 28 Oct 2014 00:19:04 +0000
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <nicoleotsuka@gmail.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        alsa-devel@alsa-project.org
Message-ID: <20141028001904.GH18557@sirena.org.uk>
References: <1414202637-18929-1-git-send-email-nicoleotsuka@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Zlo2GrDIozf6aQFY"
Content-Disposition: inline
In-Reply-To: <1414202637-18929-1-git-send-email-nicoleotsuka@gmail.com>
X-Cookie: FORCE YOURSELF TO RELAX!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: fsl_asrc: Add reg_defaults for regmap to fix
 kernel dump
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Zlo2GrDIozf6aQFY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 24, 2014 at 07:03:57PM -0700, Nicolin Chen wrote:
> Kernel dump (WARN_ON) ocurred during system boot-up inside regmap_write():
>=20
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 47 at kernel/locking/lockdep.c:2744 lockdep_trace_al=
loc+0xe8/0x108()

Applied, thanks.  Please edit down or elide backtraces - they take up a
lot of space in the changelog compared to the amount of information they
contain.

> By looking at 2744 line, we can get that it's because regcache_rbtree_wri=
te()
> would call kmalloc() with GFP flag if it couldn't find an existing block =
to
> insert nodes while this kmalloc() call is inside a spin_lock_irq_save pai=
r,
> i.e. IRQs disabled.

> Even though this may be a bug that should be fixed, I still try to send t=
his
> patch as a quick fix (work around) since it does no harm to assign default
> values of every registers when using regcache.

It's not a bug, it's not reasonable to default allocations to atomic and
we can't really tell what context we're in.  Anything used inside a
heavily locked path should either have a default provided or arrange for
a prior write to set up the cache.

--Zlo2GrDIozf6aQFY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUTuD4AAoJECTWi3JdVIfQJEIH/iDOZISkXC669AIXlfD4zREZ
FlbJ3Nui/RiIAQUYLjFmOPphMH+SwzJyX4GMl99i73c9koKnlp8CxDxXsbUEap0z
/iVwhUrTgteuZl6rK+z+R1gn0Jt+m/kqgl3d5RfAfKSNSp6yfvqhyHXKfKxe9FLR
R8jRyZ3jQDBYh4ua1g5Dxx+eoxK5KucUma0sLXGAwEHPNS9KsZbsajnFs/r6QjAW
4IAkK0XhTrpW1630Hi/n7xlA4q8R+U8Mm2HTzOKqXJBQYy+gUtQdQ93NbuXIFfFa
/9GV3B8KFPsStNOc9xSlWl2LNTrc5mT5mh7xwSJelpWyWZ+rPDlU4RLtsZXiCIY=
=5gSx
-----END PGP SIGNATURE-----

--Zlo2GrDIozf6aQFY--
