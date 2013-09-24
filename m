Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab3IXUup (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 16:50:45 -0400
Received: from ring0.de ([91.143.88.219]:46354 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754015Ab3IXUun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 16:50:43 -0400
X-Spam-Report: * -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
Date: Tue, 24 Sep 2013 22:50:27 +0200
From: Sebastian Reichel <sre@ring0.de>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        freemangordon@abv.bg, aaro.koskinen@iki.fi, pavel@ucw.cz
Subject: Re: [PATCH 4/4] RX-51: Add platform function and data for bq24150a
 charger
Message-ID: <20130924205026.GA13204@earth.universe>
Mail-Followup-To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
	Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	freemangordon@abv.bg, aaro.koskinen@iki.fi, pavel@ucw.cz
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com>
 <201309232206.47391@pali>
 <20130923204714.GB22995@earth.universe>
 <201309241905.48301@pali>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <201309241905.48301@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Sep 24, 2013 at 07:05:47PM +0200, Pali Roh=E1r wrote:
> No, isp1704 driver is doing fastcharger detection (and then=20
> export charger type via sysfs power supply) based on musb usb=20
> events.
>=20
> Real charging (enabling/disabling and setting properties) is done=20
> by bq24150a chip which has own power driver bq2415x_charger.
>=20
> As already wrote this is not simple and this is reason why I sent=20
> board data and functions only now...

Yes, I'm aware of this. Technically the isp1704 does not provide the
5 volt line, but for the system as a whole that fact does not really
matter.

The isp1704 can provide its functionality via the regulator API
as a simple regulator device. It provides information about the
power "it can supply".

The bq24150a on the other hand can just use the regulator via the
consumer interface.

The regulator framework provides capabilities for events:
"Regulators can notify consumers of external events"

-- Sebastian

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBCAAGBQJSQfsSAAoJENju1/PIO/qaS+MP/0lZBnUEtA/hMALEUVxpOf8C
D0ANugtFato7kqeArHj/bC+wv4d2UIZpvFc64KwOH2xmywcaheFATp6qHFiuwYBl
dZ3SAk8/aa6ezUvRVf6HfWE+IRSw7AdD0na3pNScnvn6Tsw5dt9g95Ot69xztbVs
16tJ87+6YaToeEKsdL+QfEd5Q9kjiAIXpECUcrA8WCRyc5ypS1pKJOHtsGTaVyzR
24p+z2L70fa8m8a7lwn7pRHtNiu3A/k1ZANLoB/zCzq6xSodASwDykT+rpWgpdFg
+mKxCTKyMkR3xjQ8fpDh9uKJRUBGisYGd7aCpQA8YgNQ95z8Os99E317mn2drUv3
Upohxge5AZjPaL4ciZI4C1T1OE3FS/8x5gM23bfepZT6ubuueP6zQ8L8mvcvW/vX
E4CoMPlVm5iozFFp/opRb9Q/PVHbplsmDTW0khmRlqHc1MuxCy5E+1E+IAsgVdVi
Cv+bAzDEt1BMPUPag/fi8NSD3GoZbe7/k6og9uhmZxeYVMm7PAOC52+0IcVOepF8
z91g46S4OC1T7e4zH8wNIpBPtfNZ/lClxNTGBbazar1Kcb3fsKI++4MvsRSEVKP+
EYCeDFm1ap3oTZdkbsv5cmzmnCcQr8kz2xAis29rv6oDZDu+YJtMkHQ5IIfDz+vo
KJDoeHG8eeUIVyOleN35
=O8yW
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
