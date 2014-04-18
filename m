Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbaDRV3v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 17:29:51 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38342 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbaDRV3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 17:29:49 -0400
Date: Fri, 18 Apr 2014 22:29:31 +0100
From: Mark Brown <broonie@kernel.org>
To: Tim Kryger <tim.kryger@linaro.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <20140418212931.GB12304@sirena.org.uk>
References: <1397845810-17002-1-git-send-email-tim.kryger@linaro.org>
 <20140418185225.GA12304@sirena.org.uk>
 <CAAYSxhoXvpxphks9p2Y8f0yUUp-4PeOjd2JiSYpsd_qvrRh6vA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u9ZjGoWtv4kAxd1W"
Content-Disposition: inline
In-Reply-To: <CAAYSxhoXvpxphks9p2Y8f0yUUp-4PeOjd2JiSYpsd_qvrRh6vA@mail.gmail.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: Allow set voltage on fixed regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--u9ZjGoWtv4kAxd1W
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 18, 2014 at 02:07:58PM -0700, Tim Kryger wrote:
> On Fri, Apr 18, 2014 at 11:52 AM, Mark Brown <broonie@kernel.org> wrote:

> > This seems like the wrong place to fix this, it's nothing to do with DT
> > and we shouldn't require that nonsensical permissions are set.  Instead
> > we should fix this at the point where we're implementing the permission
> > check, have the failure case check the current voltage before returning
> > an error.

> Are you saying that REGULATOR_CHANGE_VOLTAGE and
> REGULATOR_CHANGE_CURRENT are nonsense?

Flagging that it's possible to change the voltage of a fixed voltage
regulator is nonsense.

> It does seem like, even in the non-DT case, that the decision of
> whether to call the underlying set_voltage and set_current functions
> could be made solely based on the numerical voltage and current
> constraints.

The reason they're split is to encourage people to put the information
about what's supposed to work in there - you might know what the valid
range is but also know that the drivers are buggy and will break if they
try to actually vary the voltage.  But yes, in general you should never
have a range without the ability to use it once everything is working
properly so having one without the other at least indicates that things
aren't complete in the non-DT case.

It does also make the contract a bit clearer, one of the concerns
initially was that we wanted to be absolutely clear that the
machine integration was responsible for enabling the ability to change
things in case people broke boards.

--u9ZjGoWtv4kAxd1W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTUZk4AAoJELSic+t+oim90swP/230RRgIQQlAl4/dPnQjzDQx
RleqpuyH0B3ISzH/Egnd1j7DiVRA7dKSTtBKymloTbS24jjHPXch2x6bLd+PpxeB
DpL8b5h2UCPnbgHlX49LuV1lCraypQlz3OCmb6O0JuTv1WaPM0HdcHUtg00v6L+H
w4FlxK5nvwCBrt8SdQuxlldjA6BVwDBdU6iRXHyanyVEkihCdsU2NOfKpDzo63Gy
XZMRa6CpeaawYFcvCsyMs8a0Fuaz/GuFKn2h19hzSB1tInos2DXYKglGA+fkTXkT
xlzpPNJ5e6Cp2Mu+2ELTx1QIhYTlNI8uGTHDbk6uYocQJmLoJUlgLsOJbGVm7duj
pgblO846oI0UFD8RYcNp64iSLZyHrfbC66MP6IZ2Kdf/NDl08fOBiWfLNMgR2snI
gQsMskJfkD9Kc8MXX0BKPAiuRU3edz/9WVtk8Vymu3amNcH+5I82JrQvCo9hxr28
KSC0J8KnxvpPMchApSosRjkPj6jCYNzmVCuuPbuLrLSvbPHKpQ8E036sJSEhxAuW
/LBElwDSs5kkuGEpbv9GnzFwYyYJMameYIM8sB8vhQQ4VLhkftynp/fUa0uL2uID
4ls+EbsY9JM4wPtxLNAqgBr7MC6OcTNFpenmICii4Rvvbzcakz/mMlSK4uuHGoVK
HQT6S5n1b+xEJFscY/lA
=4s3K
-----END PGP SIGNATURE-----

--u9ZjGoWtv4kAxd1W--
