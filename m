Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbaCJKSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 06:18:45 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34972 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092AbaCJKSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 06:18:42 -0400
Message-ID: <531D916C.2010903@ti.com>
Date: Mon, 10 Mar 2014 12:18:20 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
CC: Sascha Hauer <s.hauer@pengutronix.de>, Rob Herring <robherring2@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: Re: [RFC PATCH] [media]: of: move graph helpers from drivers/media/v4l2-core
 to drivers/of
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de> < CAL_Jsq+U9zU1i+STLHMBjY5BeEP6djYnJVE5X1ix-D2q_zWztQ@mail.gmail.com> < 20140217181451.7EB7FC4044D@trevor.secretlab.ca> <20140218070624.GP17250@ pengutronix.de> <20140218162627.32BA4C40517@trevor.secretlab.ca> < 1393263389.3091.82.camel@pizza.hi.pengutronix.de> <20140226110114. CF2C7C40A89@trevor.secretlab.ca> <1393426129.3248.64.camel@paszta.hi. pengutronix.de> <20140307170550.1DFB2C40A0D@trevor.secretlab.ca> <531AF1E8. 50606@ti.com> <20140308114115.BB08EC40612@trevor.secretlab.ca>
In-Reply-To: <20140308114115.BB08EC40612@trevor.secretlab.ca>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="m9agE5FH5X00TA97e9K7BvgiWLaTKpLWn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--m9agE5FH5X00TA97e9K7BvgiWLaTKpLWn
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 08/03/14 13:41, Grant Likely wrote:

>> Ok. If we go for single directional link, the question is then: which
>> way? And is the direction different for display and camera, which are
>> kind of reflections of each other?
>=20
> In general I would recommend choosing whichever device you would
> sensibly think of as a master. In the camera case I would choose the
> camera controller node instead of the camera itself, and in the display=

> case I would choose the display controller instead of the panel. The
> binding author needs to choose what she things makes the most sense, bu=
t
> drivers can still use if it it turns out to be 'backwards'

I would perhaps choose the same approach, but at the same time I think
it's all but clear. The display controller doesn't control the panel any
more than a DMA controller controls, say, the display controller.

In fact, in earlier versions of OMAP DSS DT support I had a simpler port
description, and in that I had the panel as the master (i.e. link from
panel to dispc) because the panel driver uses the display controller's
features to provide the panel device a data stream.

And even with the current OMAP DSS DT version, which uses the v4l2 style
ports/endpoints, the driver model is still the same, and only links
towards upstream are used.

So one reason I'm happy with the dual-linking is that I can easily
follow the links from the downstream entities to upstream entities, and
other people, who have different driver model, can easily do the opposite=
=2E

But I agree that single-linking is enough and this can be handled at
runtime, even if it makes the code more complex. And perhaps requires
extra data in the dts, to give the start points for the graph.

 Tomi



--m9agE5FH5X00TA97e9K7BvgiWLaTKpLWn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTHZFsAAoJEPo9qoy8lh71TxgP/2VBc8qqL7gzkimED+kI2e+J
tDApeGiLcqQEq7MW+Jgq9ssDxPUUY/zoIDEM2xzg1xO9fXVi++TziIXEGrp0vE/r
JAYUT/YQ+St07VakXFrnBPAmvpIfph+mE841yr0gOXVyY+EJKFWK8RUwCCLBL6WJ
jBTuy7gHUQpTcm+Y+gI2rUh12buP8i9kSaqTmI2qIEtV08GmDvQJm5d6u9uGKHk1
kbzuV9IT3/3W2iBiiphIfjdeZ5n+qwxUbPNVy+fdzf8z9+mCl7cqwIQGV1fIdRK1
wapu+JGFoqc36PdtGUiTImJDfkoInPfuyj2IEhEKzTSV2sDM2XYn0g0HNwuKvIro
E9CEQXeqm2G0TUbmtxNPWgHGXu7GOkHa5PhfzYyQIBBoX3hQrS12bRkrsb3gmMM6
tAMZQU/6Jkwjwl0qXXI8tH4p6nvxQbLIXxzkhpbv7Qh4Ue32C6AkD3I1zL043dCr
N2qeWdNz7rVHRL0EFXnJQoem0n70R6SToCXreJiH4NWg9uiTcm1Ey0dc8Dc07cST
ZV4Wxky+zDvnAIKXI7Aa26yHIdJXZPMIsr4carehvRfoLZVtoCoT4Fg7MnUDf2sz
n91XgkSLqlPkzRcSiLf87DAzhuFEtGBE1tvYq924wGr6cPVGIt0ELPNKBofaMzra
yQGD/2hoPCNBi/DVj9BW
=leqH
-----END PGP SIGNATURE-----

--m9agE5FH5X00TA97e9K7BvgiWLaTKpLWn--
