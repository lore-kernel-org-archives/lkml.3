Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933374Ab3HGVI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:08:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48203 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933340Ab3HGVIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:08:51 -0400
Message-ID: <1375909722.27403.39.camel@deadeye.wl.decadent.org.uk>
Subject: Re: PREEMPT_RT vs bcache
From: Ben Hutchings <ben@decadent.org.uk>
To: Kent Overstreet <kmo@daterainc.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Date: Wed, 07 Aug 2013 23:08:42 +0200
In-Reply-To: <20130807205357.GD11612@kmo-pixel>
References: <1375907298.27403.35.camel@deadeye.wl.decadent.org.uk>
	 <20130807205357.GD11612@kmo-pixel>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-T06W8eg2hVms2OaFuswN"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 80.83.48.229
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-T06W8eg2hVms2OaFuswN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2013-08-07 at 13:53 -0700, Kent Overstreet wrote:
> On Wed, Aug 07, 2013 at 10:28:18PM +0200, Ben Hutchings wrote:
> > As Kent said back in 2011 (commit 84759c6d18c5), bcache needs
> > {down,up}_read_non_owner().  But these are not implemented by the -rt
> > patchset when PREEMPT_RT_FULL is enabled.  Can they be added, or is
> > there a fundamental conflict here?
>=20
> You should be able to cherry pick
> 84759c6d18c5144432781ddca037d929ee9db8a5 (Revert "rw_semaphore: remove
> up/down_read_non_owner") - that went in when bcache was merged.

That's the commit I was referring to.  But the -rt patchset has a
separate implementation of semaphores for PREEMPT_RT_FULL.

Ben.

--=20
Ben Hutchings
Experience is what causes a person to make new mistakes instead of old ones=
.

--=-T06W8eg2hVms2OaFuswN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUAUgK3Wue/yOyVhhEJAQqkCw/9EVAvx85+upOjUYEkJwK/maLoSeVf3qsl
nAkpRMD8OC3GjkQeWKGgz8fO7Rkb+V4wiwPgCYLyrEQUzNyR70RwnbwOWsTnK2I+
fdSHo4PwxWDaKuTd6YF2gZAXzqfNnAdFuhyCUPf5bOsf50sIEbf2L6FRMVinZbfX
ITNcRuittgdkKg3ynRhb354t0YsYnSLJA0LvFBn4DA5h++DHhe3LcYwSsziEfnRI
kOpKsEzc/T+UKg/oHiXmXEYE6FU3bsYrekgrGp+r48oPov3/V79QGqTr3oWzrHY9
9ib7jTKa4WD6Bq8gsfoYgp3sOMKigJ5GPHjCBB0Vq4u9vDGPLhT/OeVyiFp1xjSh
82vZhgjTRLuJDJIrlJtwoDLCi7eYyaHVhIUnjdLZP9PwBt3sAO1WyyRvbMG8M3GR
IhFe6vTTjuSLO0DLj12O2bdToYzLe+HO7kif55LmTGTHnARHe2SLqnsnYzdj78DJ
J5D0lGXEymj0p7Bn2ogtFfDdBqe2GirSZf3TnVVBXhF7r3cOtTxI4Sb5HZuynG4e
m9rYYb9bjLwUOph6lIZEMw4d3s47s6Oa9c7gnGRFd3dxIRSk+/XgMzK9nSNEvilH
Kq1QffV4BRTEDtpAEPZhz28HpiEigNvR1/z0S29pq4iOz49s8UKeCbCTxgR5CrJy
b0SA+b3X38I=
=oevz
-----END PGP SIGNATURE-----

--=-T06W8eg2hVms2OaFuswN--
