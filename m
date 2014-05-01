Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274AbaEAOMW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 10:12:22 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53918 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbaEAOMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 10:12:19 -0400
Date: Thu, 1 May 2014 07:11:56 -0700
From: Mark Brown <broonie@kernel.org>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: linux-spi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Message-ID: <20140501141156.GV3245@sirena.org.uk>
References: <1398854171-5187-1-git-send-email-ricardo.ribalda@gmail.com>
 <20140501013402.GL3245@sirena.org.uk>
 <CAPybu_3g=VBW+gGhveBJoc7=tCiPurP_r_+hqOU78bvsg8QJWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YnIutncTLXsDZs5t"
Content-Disposition: inline
In-Reply-To: <CAPybu_3g=VBW+gGhveBJoc7=tCiPurP_r_+hqOU78bvsg8QJWw@mail.gmail.com>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 31.71.205.29
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: Fix hung task timeout when initialization fails
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YnIutncTLXsDZs5t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 01, 2014 at 07:53:58AM +0200, Ricardo Ribalda Delgado wrote:

> Thanks for your comments. This fix does not avoid the task being
> killed (which is not an error). What it does is that IF the task is
> killed or we are out of memory we will exit with all the resources
> properly released and no locks helds, giving the user a chance to
> reload/rebind the module instead of getting and unstable system that
> cannot even reboot without a powercycle.

How does it ensure that?  What's to stop the task being killed after we
check to see if the task was killed.

--YnIutncTLXsDZs5t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTYlYpAAoJELSic+t+oim9CiQP/2Ie7FrfCtO+X5us/U8GDgba
ps+h4ZNWwGzBVIVnidT1/1LogzICAVVd1Co+epQ36rHP3SLUXL7WX2jbitjEk0HY
vWqfxt+n1uRtAsGCYLNKQ23jydaGz7RZ8I47d/dw/hsX6HiE0Q0CvUNwboz8EJ4W
d+25woaVMzXu22rGt/jdHU+fGXomcYr9D7aDZAuyHiVy65derXEBHCSvyZitDEMl
VpMcVnzER85VD4MRqjS+BWTejCXkq5zI8p/6iwID999ZoamOHN775NJm9ByFwAD5
loU6OH70Yi/HZXgJGDfloNEl7DE2lIkE2jdICGlDR2l+ZP1q0wq4mc+gec8xbLa3
015JPym5soDh/Jf8WgiRFT3SNK2XC3MicOOpWS+v5yen+BP85aSIdE4iLCNgjm0L
RG9KZTK+BxqQgL9I3yBU09Sbt9v/piOMi22Bh2PWSup3MPuHAb1FnjuYhSvzCLPQ
choixUNvOLTgd4og2S2Hxb5+3YJHSJiPcssimXOpvYeO7iPhybzI3y5JOAd6UkUL
aW+bSoOeFfntHkW5U9xGLOSVJ+C2mMTEeW9P/Yd8DHznB+jvDuNwZpJKqAqt2UOn
7FNmpD3T26iGiHv2NKfQdtjMfbUygp9RP4zwtWGlfRE8sTfoS2HZRhWYlP7kzUB7
5LeUr7Jh+Yh/XNSjFsyo
=zmMX
-----END PGP SIGNATURE-----

--YnIutncTLXsDZs5t--
