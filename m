Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239AbaKXRMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 12:12:50 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:62911 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924AbaKXRMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 12:12:48 -0500
Date: Mon, 24 Nov 2014 18:12:33 +0100
From: Alban Bedel <alban.bedel@avionic-design.de>
To: Mark Brown <broonie@kernel.org>
Cc: Alban Bedel <alban.bedel@avionic-design.de>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH 1/4] devicetree: add a binding for a regulator that
 constrains its supply
Message-ID: <20141124181233.53580998@avionic-0020>
In-Reply-To: <20141124151527.GC7712@sirena.org.uk>
References: <1416834123-23139-1-git-send-email-alban.bedel@avionic-design.de>
	<20141124151527.GC7712@sirena.org.uk>
Organization: Avionic Design
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/cw/fV0vWV54zuUO.XcDBZOH"; protocol="application/pgp-signature"
X-Provags-ID: V02:K0:dfqQoGQB06zXSAjFo0JKo6CXZsJvc/1yYUHFnUrqp/U
 NiPxf+VBuuAyOMVZwN9xqtK0tWZG+zVqGB/Ek4yiuKs3k7xzAN
 dq7a60pme4G8D1xivdVOiYtYdR50+DE2yp6hfCWGM0SsLVoqWI
 UeOuk2mB8+zh9L3/CaVv5IlftspLnuMIVnqjCmbgnoKwgWE3Fp
 ogLO5Z29RKfs/YcUgMKK7vr/baVcoAVuKAAhOx76VJeiJiZqYl
 9P4N1S98SJB/ynllHb3txHTXmQmp9qpCU8+J8+r/TIMLkfXfwJ
 K23ShVkGzaHAN86NbmTl6rYdzj7MkLG5o8wPYfdZq7Jy+TCw5w
 oa/k4G1FVxCQXTD7Z6a1lT1WEQMn7QPJwpbXeISn4dWz+khlGW
 lTzfqzdYC0Hef2Oeec9bmERjZg31KeuhBk=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/cw/fV0vWV54zuUO.XcDBZOH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 24 Nov 2014 15:15:27 +0000
Mark Brown <broonie@kernel.org> wrote:

> On Mon, Nov 24, 2014 at 02:02:00PM +0100, Alban Bedel wrote:
>=20
> > +Constrained Supply Regulator
> > +
> > +This binding allow creating a virtual regulator that constrain its
> > +supply to provides the requested voltage. This is to allow using
> > +simple drivers that don't explicitly request a voltage on boards
> > +that have adjustable hardware regulators.
> > +
> > +Required properties:
> > +- compatible : Must be "regulator-constrained-supply".
> > +- vin-supply : phandle to the parent supply/regulator node
>=20
> Reading this description I'm at a loss to explain what this is intended
> to achieve - it's obviously not describing hardware which is a rather
> large alarm bell and I don't really understand why the constraints
> wouldn't be set on the parent regulator.

Yes, it is not real hardware. The use case is a generic base board with
one regulator for add-on boards that has a settable voltage output. In
the base board DTS the regulator constraints represent the whole range
that the regulator is capable of, for example 1V to 12V.

Using this driver the DTS for the add-on board can further constrain
this supply to get the voltage it need, for example 3.3V. I understand
that normally the drivers for the consumers on the add-on board should
do this, however I don't really see how that is possible with generic
drivers like simple-panel. Such driver target a large range of
hardware, so just setting an  arbitrary voltage doesn't make much sense.
Furthermore even driver that target a specific hardware usually don't
set a voltage and in many case they couldn't do it without some
knowledge of the board design.

I saw 3 ways to solve this problem:

1) This, use a "filter" regulator
2) Extend each and every driver that use a voltage regulator to
   optionally set the voltage
3) Include the required range in the phandle reference

#1 was the easiest :) #2 doesn't seems practical to me, #3 seems pretty
good but I'm really not sure if that would be acceptable.

Alban

--Sig_/cw/fV0vWV54zuUO.XcDBZOH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUc2cBAAoJEHSUmkuduC28I3MP/1MGIxpCg6HmfeSnFzuwmgzO
maXl8EmqfeOT2Kw0TOuveNgfSx+YYiEb51pRtCwjnA20XcB4NGxqiE4lJ22tib8N
e5wwxQiRb5XaODTHwiUvBKwwx29GCSnJE3jfCTI3aLDjUTtKho3iCepo5ziZjy2F
AnUHJ8GIDfYYbJHRTr69P15vhFqOyT4TAZehS8kGP6nI09yYoK5ubYaXdoh+28d2
tng60bx/UuU0FTGBRxb5WH3OjKsQ5lrNYAtHye2+AR30pz+r7V+GNlrKQimJnP4J
o7bCgxTDFcikb9lEBw+wGT39rtrjym1noMB21ZeT3yYLEWjb4XyguJCSVk2TIrAY
Brusy7OGgRfpPBtOnMb8iAQN0mqnQgRTJUacFgzWzp5BJ2gcS9LKXqcSwOH+YK6u
wZWxTP1camaKqGDcnX2Aj8QCAzd2OWIWnI2GzScZf32/4p6qmiH4V9DJlWyc/VZK
ucEIsfujMeZyd8Kv25la7BAF+PKMyuENmMSaJD+yveTpt0QHr8TEW/e0eaed5gV5
KJQpt1bEL+MxyBHgcr69+QBjHpTTPrHzTiy7VEF4KYEAacBx+EjVAz0XtRJR/nGZ
6gQPxlPDHqiJPXRCrLg2qjFfhZonOpyw7EtgX34MwRdfRhtBdS9/6NN0Ak08lJsf
Kfu6e9Fgf+C6S3jy+TtJ
=WT5b
-----END PGP SIGNATURE-----

--Sig_/cw/fV0vWV54zuUO.XcDBZOH--
