Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab3GAUrN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 16:47:13 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44948 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753269Ab3GAUrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 16:47:11 -0400
Date: Mon, 1 Jul 2013 23:46:33 +0300
From: Felipe Balbi <balbi@ti.com>
To: Luciano Coelho <coelho@ti.com>
CC: <mturquette@linaro.org>, <mark.rutland@arm.com>, <balbi@ti.com>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>, <--linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC] wlcore: sdio: add wilink clock providers
Message-ID: <20130701204633.GB805@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372707250-11998-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NDin8bjvE/0mNLFQ"
Content-Disposition: inline
In-Reply-To: <1372707250-11998-1-git-send-email-coelho@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--NDin8bjvE/0mNLFQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jul 01, 2013 at 10:34:10PM +0300, Luciano Coelho wrote:
> diff --git a/arch/arm/boot/dts/omap4-panda-common.dtsi b/arch/arm/boot/dt=
s/omap4-panda-common.dtsi
> index 670c3ce..7f061b8 100644
> --- a/arch/arm/boot/dts/omap4-panda-common.dtsi
> +++ b/arch/arm/boot/dts/omap4-panda-common.dtsi
> @@ -65,11 +65,19 @@
>  		enable-active-high;
>  	};
> =20
> +
>  	wlan {
> -	     compatible =3D "ti,wilink6";
> -	     interrupt-parent =3D <&gpio2>;
> -	     interrupts =3D <21 0x4>;	/* gpio line 53, high level triggered */
> -	     refclock =3D <2>;		/* 38.4 MHz */
> +		compatible =3D "ti,wilink6";
> +		interrupt-parent =3D <&gpio2>;
> +		interrupts =3D <21 0x4>;	/* gpio line 53, high level triggered */
> +		clocks =3D <&refclock>;
> +		clock-names =3D "refclock";

hmmm, shouldn't you provide both clocks (refclock and tcx0clock)
explicitly here ?

Also, you should probably make it clear that the WiLink module is fed by
the 32K sync clock just to make sure clock usecounts are correctly
incremented ?

--=20
balbi

--NDin8bjvE/0mNLFQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR0eqpAAoJEIaOsuA1yqRE5SsP/1OrvXmzGEAMUB8plu2sPDRS
xpWYJFtYXDMTwxfHi6RnBvimRTmP1okmuulV6LgwbDPy00+eMWCGr5ig1BnEm5cJ
5NaHQAk4js08NlgRYffE8+t6jkXR6xiFUvyhAdAn8ZuXeApIjLeoguWLHyG6RvTr
J6lrB7+PRPR4I9fzTbu/QClOlipA073Xyjogd3jA686Oq7UtFj/G/XcBB16SeXcN
q3zYUt9c6LNMnnt1WazQr8v4H5WPLBp+dXcwANbLxcr47aJlYZqzpzH2O7Z9Y7Hx
AAdhhNeeQ1CCGVGMqNI2zS0UW9kZntrWO6Wd+YO1rSPKFBXFpphLO8OYE+QipJHH
d92MmgCqzkWpJggx1NOSFFFC8v7TKc6zjdsEWSuFsZjt3rVkgoe+Vx73uxQr89Gx
mJSe65bnpBZeOZnqaB0wfgMLq+fq0+LIcYQQlVoGG780h5ybpXVlqbXjWcQh1nJe
YpHxyvP2ocWe5kQ+N6iy7nCszdtOaJTEEhAM2veLCCdpl6OsQEN1rcV86vCEgBVy
B+hyio+gDrjP8bo6vcdhG9BWOwTf9qxV560kV5WKGelRwqJxqIlnZ4R00apVgk7q
mC40OzCTVsv1NoxJsBsyeKSxYXiF19WFFx8+gUziMWZ01Z9I4obd6nZ6pcnLhTuM
ggwzY03Wzis6VT8Hrjt3
=TGWR
-----END PGP SIGNATURE-----

--NDin8bjvE/0mNLFQ--
