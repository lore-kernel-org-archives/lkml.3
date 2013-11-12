Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702Ab3KLUkZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 15:40:25 -0500
Received: from ring0.de ([91.143.88.219]:47746 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756659Ab3KLUkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 15:40:19 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Tue, 12 Nov 2013 21:40:14 +0100
From: Sebastian Reichel <sre@ring0.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 4/5 v2] input: tc3589x-keypad: support probing from
 device tree
Message-ID: <20131112204013.GA17674@earth.universe>
Mail-Followup-To: Linus Walleij <linus.walleij@linaro.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Lee Jones <lee.jones@linaro.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	Mark Rutland <mark.rutland@arm.com>
References: <1384265618-10590-1-git-send-email-linus.walleij@linaro.org>
 <20131112153057.GA9683@earth.universe>
 <CACRpkdb_bryGJo7CKGP5tj3RFGv=Gh+Q5m9ucVKqJ068tjPC2g@mail.gmail.com>
 <20131112200514.GA15413@earth.universe>
 <CACRpkdaAaLjm_b+OLj3tobxBN8YGUcTPnXJ=qtBqd02=FTxhjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline
In-Reply-To: <CACRpkdaAaLjm_b+OLj3tobxBN8YGUcTPnXJ=qtBqd02=FTxhjQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 12, 2013 at 09:11:40PM +0100, Linus Walleij wrote:
> > I could find two boards using "gpio-matrix-keypad" in the mainline
> > kernel and not a single instance of "linux,no-autorepeat":
>=20
> In things connected to GPIO, I don't expect the in-kernel
> device trees to be a good way so survey the usage of these
> bindings. Anyone doing device trees on any system with a
> few GPIOs can be using this.
>=20
> But maybe we're lucky and won't break anyone's setup if
> we change this?

AFAIK Device Tree property names are considered as ABI, so existing
property names must not be removed.

But I guess we can add the standardized property name in addition
to the deprecated one. New drivers can use the standardized property
name from the beginning.

Thus I guess we should not use the name, which has the most adopters
in kernel (or out of kernel). Instead the most fitting name should
be used. Current suggestions (taken from kernel) are:

* <<vendor>>,no-autorepeat
* keypad,autorepeat
* linux,keypad-no-autorepeat
* linux,input-no-autorepeat
* linux,no-autorepeat
* autorepeat

I do not really care, which one is chosen, except for two things:

* <<vendor>> seems wrong. This is not vendor specific.
* I would prefer "input-" over "keypad-", since then the same name
  can be used for single keys, buttons, etc.

-- Sebastian

--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSgpItAAoJENju1/PIO/qaKRcP/RTtmfW85fAGrj0QKc6e4uWl
l2m3JbyTe3td3BYpTnHaewGH9HARMxRKszcy04qXAXqClTmI/R9Qbr8hzEp9+Do7
UpXxqOamKZPaGpWs4ESazyDogh3pp98tsixX+fHvDaVwsH5IRJdeQMaTvbeXQ0ey
WEZDMH00GjfUiU2w6CHyHaIr0nQtV/dzG5OgsVCG5hw1+lDkpkLhLUGCNJLqXvwt
HJ1xiW3Cm0L2F+DnVLL3XvYwZfFQgCiPracMNT5seGUsdUBKeXCErJAGcOw0IWFT
2/har3c3F2ZnZoGgt+Q00Yq9B/cCoLtx42kVURLiVpoWacxyTehTn8IX6pk/MH8l
JCU36g2HGpiFgc54hVNaYTJHLwa6W0nUkTNMvlrNAQFMCx7i8ufeJBduFT/2Z03k
ZnkXwL/q8K78A1pZyR3THcxQK6972DD3J1M7/PRpks1HjvpstOzNo/fHmgUGianb
y+ttBKwGsCCnRaznlWwm73e3fpnvLRkBIt4KGKLt2HbflO9E0xXRT2fWl53LEJD7
oNOJPOfZ5uV9k9BGPCXM9ybkHS/4Fxs9q8eW1D1qIMlQVBHaz2p1dvIaGnL31VCZ
ceqnB81THgVzxkbWNFeYfXML5g0Nq+ZUxQFWJX5CcDnfshd/zvlo+xoPBd6YTeBu
0AEJgt2xxZ4F7MSOThz1
=VKPM
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
