Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbaAPTeb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 14:34:31 -0500
Received: from sauhun.de ([89.238.76.85]:32937 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298AbaAPTe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 14:34:28 -0500
Date: Thu, 16 Jan 2014 20:33:45 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Romain Baeriswyl <Romain.Baeriswyl@abilis.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Chiau Ee Chew <chiau.ee.chew@intel.com>,
        Shinya Kuribayashi <skuribay@pobox.com>,
        Jean Delvare <khali@linux-fr.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Romain Baeriswyl <romainba@abilis.com>
Subject: Re: [PATCH 2/2] i2c designware add support of I2C standard mode
Message-ID: <20140116193345.GB4127@katana>
References: <20130828153429.GB7066@ab42.lan>
 <1381244455-3836-2-git-send-email-romainba@abilis.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l76fUT7nc3MelDdI"
Content-Disposition: inline
In-Reply-To: <1381244455-3836-2-git-send-email-romainba@abilis.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--l76fUT7nc3MelDdI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 08, 2013 at 05:00:55PM +0200, Romain Baeriswyl wrote:
> Some legacy devices support ony I2C standard mode at 100kHz.=20
> This patch allows to select the standard mode through the DTS=20
> with the use of the existing clock-frequency parameter.
>=20
> When clock-frequency parameter is not set, the fast mode is selected.
> Only when the parameter is set at 100000, the standard mode is selected.
>=20
> Signed-off-by: Romain Baeriswyl <romainba@abilis.com>
> Reviewed-by: Christian Ruppert <christian.ruppert@abilis.com>

Pretty much OK. One change needed, though:

> ---
>  .../devicetree/bindings/i2c/i2c-designware.txt     |    1 +
>  drivers/i2c/busses/i2c-designware-platdrv.c        |   17 ++++++++++++++=
+--
>  2 files changed, 16 insertions(+), 2 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/i2c/i2c-designware.txt b/D=
ocumentation/devicetree/bindings/i2c/i2c-designware.txt
> index 5199b0c..16d0bef 100644
> --- a/Documentation/devicetree/bindings/i2c/i2c-designware.txt
> +++ b/Documentation/devicetree/bindings/i2c/i2c-designware.txt
> @@ -9,6 +9,7 @@ Required properties :
>  Recommended properties :
> =20
>   - clock-frequency : desired I2C bus clock frequency in Hz.
> +   Only standard mode at 100kHz and fast mode at 400kHz are supported.

This should not go the bindings doc, since this is a linux specific
detail. It should go...

> +		if (clk_freq !=3D 100000 && clk_freq !=3D 400000)
> +			return -EINVAL;

=2E.. here as an dev_err message "Only x and y supported".

Rest looks good, thanks!


--l76fUT7nc3MelDdI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJS2DQZAAoJEBQN5MwUoCm2kmsQALLJAM6Xk0o0t1UK4lBSwt4k
0JqR+ny1S48lMjcezUcr4ZKnTZ+q89ZUPYLbj67L0Su1WNz2JOe8x9FVphFscHo1
wNGlQhps04iY/fXchmKVBId6geg+obby00LZMHo/rCYgkF2JMXJA+MM1Qzo7EIkM
fORdk4R3FNySd3mAgSW367CMnmhTzQaQd8Zs+WkNjVOnrw6nWEFXXsf77jt8zWWX
b7asf3mAJanLVTap4wgdl91Z6y4fQ9M+wbnztUYLDE74gCNmpQ/6iSRR7k7h8Zok
yc+jGN6VuPaazURkUysQ/0k9Qcx02alkX7V30pnTBv+T59DRque8ZOoRbyqAno8L
rCPuJxAKGuWQep+JUl+wTiBM7jl+/WY2wzoE8K8RxGYme+iVM1DWtZRVHZbvtouc
J+WRepfbqsBPoYsItB24XQgYj3P3vDxhs9V7OdJNOwyqwY3/rXJIfwD/tWddUlmj
W5y/o/KXGtYH+BV17IcwiOxMeSuEzQgdLfIJS1KhiQz7YvMShVNVZXIevhyNgjpI
iY+AuYsNX3+OKkO1OWAXAuh6ynFrjkwFAuFGgycLNxTL4A++FLQE+cU+f+joFY5r
fKc9j+Kfw8hyhiNVllW88lAhW05JCFVmpZoA4MRjFLz/YoFfu63wh2z3PUwdwdfe
sUccSJhXdCNydh/E1VDk
=AQCa
-----END PGP SIGNATURE-----

--l76fUT7nc3MelDdI--
