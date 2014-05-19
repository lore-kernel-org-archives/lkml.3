Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011AbaESQh5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 12:37:57 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:55798 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbaESQhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 12:37:55 -0400
Date: Mon, 19 May 2014 18:37:49 +0200
From: Alban Bedel <alban.bedel@avionic-design.de>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Subject: Re: [PATCH] regulator: core: Fix the init of DT defined fixed
 regulators
Message-ID: <20140519183749.170aada2@avionic-0020>
In-Reply-To: <20140519161838.GB12304@sirena.org.uk>
References: <1400497954-1012-1-git-send-email-alban.bedel@avionic-design.de>
	<20140519143949.GW12304@sirena.org.uk>
	<20140519172556.17c49589@avionic-0020>
	<20140519161838.GB12304@sirena.org.uk>
Organization: Avionic Design
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/z9jTKKmAGY=PVOYg63zYzUY"; protocol="application/pgp-signature"
X-Provags-ID: V02:K0:vHm4t8Sg3tzH7IsM7CopbygXARpWHeJxcD2TZvbyVCi
 jwJVQo34CFDQ/C1Vi80nmrwd8xaBbv26jNELxQcoxqvUPVEor3
 Ebtav1W+cMwPvTECGjv486LWjxwfpRuSvEsZOY+/gpl5dGzF6L
 Zkk9Lm6xxmmTESGPxERPkzP1wId5vcnwxTCapDSxyeAJbzYw/F
 Cus0eC3DspIYnIyY6GS5K4e9vn3m6Chc5kXfWBSmg2899yzWGF
 ZvyS2J8RhA0YMOWJh+X89gnG1zO4zY7MPoD86ah2+9twhBA6sw
 T6KBTtCwTmLghaRfQKiqji4lT3G4oCdVHSYEGAS11ed+5xI+rL
 te5vpj+iFjwsc8DlXI1AR4hDZvWBzvjIR41MYqr1LrLM+dehIa
 1jhAJXM5UccAg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/z9jTKKmAGY=PVOYg63zYzUY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 19 May 2014 17:18:38 +0100
Mark Brown <broonie@kernel.org> wrote:

> On Mon, May 19, 2014 at 05:25:56PM +0200, Alban Bedel wrote:
>=20
> > Would checking that the regulator is at the voltage declared in the DT
> > better? Or should I just add a pseudo set method to the regulator driver
> > that only accept the current voltage? That could also be implemented at
> > the core level using a default method for all regulators that have a get
> > but no set method.
>=20
> We already have code in the core to accept set_voltage() on fixed
> voltage regulators - are you sure you're working with current code?
> Otherwise fixing things to go through the standard set_voltage() path
> would be OK.  There should be no need to add a dummy function for
> setting.

The regulator_set_voltage() function do have code to handle such
read-only regulators. However the regulator init directly call the low
level function _regulator_do_set_voltage() which just error out when no
set method is available, hence my original patch.

Unless there is some better proposal, or objections, I'll submit a new
patch tomorrow to call _regulator_do_set_voltage() only if the current
voltage isn't correct.

Alban

--Sig_/z9jTKKmAGY=PVOYg63zYzUY
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJTejNdAAoJEHSUmkuduC28yzIQAOBeE3rRH+FGby0VwMIdBxuQ
VD2BWfnd9OpFA17TP3gwHhQLySz31x/gMU2rWR2yhQFyc2+RBqtWKP3hxWvRBKK+
VNqW0UOiVEZt7lCwyB1vILTc6SLZBNzd2MihlTQ4Ib0J+VA/130a5I/yuByYhuks
nde+p8DXfwL8Ij5BEcqVyKLgE5WiCAPVsDgirv9FUvhn0l9eCBTdVGsXGjwPZB83
okuJpcXO3PY8bWmm5W3O4QeEXRLEA77RKlnaYL/VFTkT9WRqywiwXpH14wy5cCgm
ClGnoH9J6Yaqtt++V58SsDKBVRPYRI3XqZWQZC2rqC1MsEE3qlsg/m6KTUj8Vl7X
fXohat/vwpRCAoorETuYHqkqhRE35bXwkBG9VeDzXgywQITMKLnqjgAVTojxBvSA
EvFipemTHasZmLS3yc1oj5u76FDt6uEqYzi+jLOQmpBD+2RoK2ZD7syO4hZK6+ho
QIM41rPi+5UZs/nBGartQlnI98Vb6vXEUtijHTWWajXBXdMZbkTXCreFew+Ns/Q1
57otOhn2QQ2XH0ypCBNLuVvgqukBaPVvGzaLU3t6AfzRa9FEbd4eS+l4mTl/Upwu
e/nhavnq+P3ekhyDw+coV8R9V5yv9gGXcg6X7YMAp5l05Uvhu6oga8cMDoOH1vLL
Qkha+cnsa93JKYbL6xnM
=RGNj
-----END PGP SIGNATURE-----

--Sig_/z9jTKKmAGY=PVOYg63zYzUY--
