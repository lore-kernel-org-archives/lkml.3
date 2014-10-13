Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbaJMOCi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 10:02:38 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50950 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874AbaJMOCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 10:02:35 -0400
Date: Mon, 13 Oct 2014 16:02:18 +0200
From: Mark Brown <broonie@kernel.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Message-ID: <20141013140218.GG27755@sirena.org.uk>
References: <1412675448-11990-1-git-send-email-iivanov@mm-sol.com>
 <1412675448-11990-3-git-send-email-iivanov@mm-sol.com>
 <20141007172606.GG16469@dtor-ws>
 <1412759584.13569.0.camel@iivanov-dev>
 <1412760633.13569.4.camel@iivanov-dev>
 <54357BA7.3010609@codeaurora.org>
 <20141008181314.GC14423@dtor-ws>
 <5435808A.7070203@codeaurora.org>
 <20141008200426.GJ4609@sirena.org.uk>
 <20141008203233.GA15198@dtor-ws>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0W6CLHPDK0Qrxw1x"
Content-Disposition: inline
In-Reply-To: <20141008203233.GA15198@dtor-ws>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/4] Input: pmic8xxx-keypad - use regmap_field for
 register access
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0W6CLHPDK0Qrxw1x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 08, 2014 at 01:32:33PM -0700, Dmitry Torokhov wrote:
> On Wed, Oct 08, 2014 at 09:04:26PM +0100, Mark Brown wrote:
> > On Wed, Oct 08, 2014 at 11:20:58AM -0700, Stephen Boyd wrote:

> > > Srini/Mark, any reason why the regmap_field structure is opaque?

> > So you can't peer into it and rely on the contents.  I can see it being
> > useful to add a bulk allocator.

> And then one have to define offsets in an array and use awkward syntax
> to access individual fields. Can we just reply on reviews/documentation
> for users to not do wrong thing?

I have very little confidence in users not doing awful things to be
honest, this is the sort of API where the users are just random things
all over the kernel so this sort of thing tends to be found after the
fact.  I get a lot of these in drivers that just got thrown over the
wall so nobody really knows what things are doing when you do find them.

If the standard allocators aren't doing a good job (I've not checked)
I'd much rather handle this inside the API if we can.

--0W6CLHPDK0Qrxw1x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUO9tkAAoJECTWi3JdVIfQXpkH/16JpLXmOuCHJvRAifJWLEgo
DqH81xMCO4Pob8n5N3HoaHAKids9dNDLRVgepFZZ3pMvDpq7vBivo+kgiRWxt41p
S4vN7CwIhAFvFdzF15tUtBAGAf+/ua9VVUv81MP+KN510PWnpja6jnR2ZhKbjKxg
AK1dqbGdGkyGM/6Yb2RXayu3mF+MDbdduDdnwI5ANSdFGkv/E+hv3AAVqYlWqcUh
HUXpo5jvMZ6ey1OYEdVvk8Z4dgmgjavqmkpkl3TVhwMeQtaeTXfcgdMWbBDZSE1K
MeCytodGiojtO6METyWQYtxPubg/13kdw9RsPwE+rrtKOBfklPLK8YG7TU/36qg=
=qqvh
-----END PGP SIGNATURE-----

--0W6CLHPDK0Qrxw1x--
