Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967632AbaLKXEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 18:04:16 -0500
Received: from mail.kernel.org ([198.145.19.201]:58179 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965914AbaLKXEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 18:04:10 -0500
Date: Fri, 12 Dec 2014 00:04:05 +0100
From: Sebastian Reichel <sre@kernel.org>
To: NeilBrown <neilb@suse.de>
Cc: Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Rutland <mark.rutland@arm.com>, Jiri Slaby <jslaby@suse.cz>,
        NeilBrown <neil@brown.name>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] TTY/slave: add driver for w2sg0004 GPS
Message-ID: <20141211230404.GC11666@earth.universe>
References: <20141211214801.4127.93914.stgit@notabene.brown>
 <20141211215944.4127.57146.stgit@notabene.brown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="4jXrM3lyYWu4nBt5"
Content-Disposition: inline
In-Reply-To: <20141211215944.4127.57146.stgit@notabene.brown>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4jXrM3lyYWu4nBt5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Dec 12, 2014 at 08:59:44AM +1100, NeilBrown wrote:
> This uart-attatched GPS device has a toggle which turns
> both on and off.  For reliable use we need to know what
> start it is in.

I guess you mean "what state it is in"?

> So it registers with the tty for recv events when the tty
> is open, and optionally configures the RX pin as a GPIO
> interrupt when the tty is closed.
>=20
> If it detects data when it should be off, or a lack of data
> when it should be on, it toggles the line.
>=20
> A regulator can also be configured to power the antenna.
> In this case an rfkill device is created.  When the rfkill
> is 'blocked' or the device is otherwise powered down,
> the regulator is turned off.

[...]

> index 000000000000..c9e7838b3198
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/serial/slave-w2sg0004.txt
> @@ -0,0 +1,35 @@
> +w2sg0004 UART-attached GPS receiver
> +
> +Required properties:
> +- compatbile: "tty,w2sg0004"

grep tty=20

$ grep -c tty Documentation/devicetree/bindings/vendor-prefixes.txt
0

This should be something like "wi2wi,w2sg0004"

[...]

-- Sebastian

--4jXrM3lyYWu4nBt5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUiiLkAAoJENju1/PIO/qaJHIP/0JVBvxvEcWMOFKsdla3hTSo
ROWTR/vct+sCUOrY1G46aQReS22L14WObvT/nbVTQxKoGQCVfMVNeIP19xLPgu6C
8d6ByVMmQFXLFG7+2E4RBX8340vNy2Msvx/ZCPO8Hax7NUIBOT72UF5s7oN2TZ/Q
zETxmWKyqqAOZzJ0w1w7bNNtyi/wGkpVsuKzldzQcXZpiDSm3Tbo0vBDeQQqCBKB
I9PsFuaGa4Ed4DtAkn0buSMWeDsCC33WU0EnHFmOnB4JUXb5lerTu+QivbILuMjs
PDCRu+CInphQEJItar7kXShbalWxGyu725oOhX9BJxxtPAfe1CtBvY5YovarnQ1j
9Oed3SPeL6y1OQT30TY6uheb50C54OWl11TeL/8mNuBZ9C5506gf0UNz4N9czNlP
L22IstfHObuYHdybvCQsXuhykqWAR8uxzuZdyBQjWjF4/U0lVt1NrvMu0aNfcuU9
jxe0kfaBNlXYQJ2Elc6z19f5YJ4yIEVsr3jXaCwLIFxkgQrpPO9pgF0+EVdjXuJ1
e/MvA+bb8J4aEUhX024+kZ4gOAJVDjUV+8NcqDbRviQA1Rqfrd4hm8gGDgf1zO/e
wQ1DjrsUnhcwW1EUuzC+XLBhHkmTkn00mEAi5SJVCSy6vlBKKnRniFBRvXl44bVY
Roaybj6FDwdlRXzI3/S6
=amiF
-----END PGP SIGNATURE-----

--4jXrM3lyYWu4nBt5--
