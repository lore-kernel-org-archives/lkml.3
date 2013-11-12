Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538Ab3KLUF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 15:05:28 -0500
Received: from ring0.de ([91.143.88.219]:47606 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755317Ab3KLUFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 15:05:21 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	*  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was blocked.
	*       See http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
	*      for more information.
	*      [URIs: lkml.org]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Tue, 12 Nov 2013 21:05:14 +0100
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
Message-ID: <20131112200514.GA15413@earth.universe>
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
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="82I3+IH0IqGh5yIs"
Content-Disposition: inline
In-Reply-To: <CACRpkdb_bryGJo7CKGP5tj3RFGv=Gh+Q5m9ucVKqJ068tjPC2g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 12, 2013 at 06:06:49PM +0100, Linus Walleij wrote:
> On Tue, Nov 12, 2013 at 4:30 PM, Sebastian Reichel <sre@ring0.de> wrote:
> > On Tue, Nov 12, 2013 at 03:13:38PM +0100, Linus Walleij wrote:
>=20
> >> +     plat->no_autorepeat =3D of_property_read_bool(np, "linux,no-auto=
repeat");
> >> +     plat->enable_wakeup =3D of_property_read_bool(np, "linux,wakeup"=
);
> >
> > There is currently discussion going on for the property name of
> > autorepeat:
> >
> > https://lkml.org/lkml/2013/11/11/680
>=20
> So this binding is documented for GPIO keys in:
> Documentation/devicetree/bindings/input/gpio-matrix-keypad.txt
>=20
> This is probably the most used binding as GPIO matrixes are
> not uncommon. But I don't know, yes it is a mess. (As usual.)

I could find two boards using "gpio-matrix-keypad" in the mainline
kernel and not a single instance of "linux,no-autorepeat":

arch $ grep "gpio-matrix-keypad" **/*.dts **/*.dtsi
arm/boot/dts/am335x-evm.dts:               compatible =3D "gpio-matrix-keyp=
ad";
powerpc/boot/dts/ac14xx.dts:               compatible =3D "gpio-matrix-keyp=
ad";

arch $ grep "autorepeat" **/*.dts **/*.dtsi
arch/arm/boot/dts/am335x-evm.dts:          autorepeat;
arch/arm/boot/dts/ea3250.dts:              autorepeat;
arch/arm/boot/dts/exynos4210-smdkv310.dts: linux,keypad-no-autorepeat;
arch/arm/boot/dts/exynos4412-origen.dts:   linux,keypad-no-autorepeat;
arch/arm/boot/dts/exynos4412-smdk4412.dts: linux,keypad-no-autorepeat;
arch/arm/boot/dts/omap4-sdp.dts:           linux,input-no-autorepeat;
arch/arm/boot/dts/spear1310-evb.dts:       autorepeat;
arch/arm/boot/dts/spear1340-evb.dts:       autorepeat;
arch/arm/boot/dts/spear300-evb.dts:        autorepeat;
arch/arm/boot/dts/ste-stuib.dtsi:          st,no-autorepeat;

-- Sebastian

--82I3+IH0IqGh5yIs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSgon6AAoJENju1/PIO/qay38P/RnuZZd7bzikUgj/fEQdfRc9
Keb+fbiB8iWTTtTBVHl1fbA4ATxznNISNWfzAeUJkakSA/lH6iiaL6cOYsvWQHwY
7HHLRT33yntSMq55eKSGZI4YDzNT86KinMzvuyq2y8/QsaPwSS3AmxPFVwiwQvaa
bcoz3fEgul6Na2vkuEr98DfZ7/0glGAWsfFoz0viYSua1evBnDMgybo163UpYMAs
VaoSQeaBY+zj5tDTctn9vy44lnqhzCuhMszyuaUzpq8SXIwEsij/yW8ghOXXtOrH
h2cvMVwfJiNWPpV126q94v1BDWuNE4sr9+J1FlX/wyDAG9ZSBFZrdEOD0VtXbT4C
1id+GYgpyUX281WrJyWz11kquPT/BhZtXEIaXZ3pyp9KkIzmmcMnoZdEm35X58I4
D/Xi6R0TKVABeaTHktg/O19PX/X3DXFF7qxwCAvlxekOZ/VRVMH56mLHNrInkK5G
kecPW+JZk5Zz8kzKPADrwIiFMrHki2C+bo4xi3KwKZHG1Dd5ivUGSW4yOMU0obZX
7trmfPwaggs8PnR3ouHQ9o+KPedKainptwQlvjLoo0taitiW/C3jNnU/4bAb9Dv3
dFua01FEogeHNkuj/2j+cWxkDKi2ht64TY6pLPLFWbdB3wk3XykVNfryxcUmo3iv
wL6D9w1EDC1YHHfSxmUT
=x9ZB
-----END PGP SIGNATURE-----

--82I3+IH0IqGh5yIs--
