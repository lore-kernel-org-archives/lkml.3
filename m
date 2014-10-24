Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619AbaJXUJw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 16:09:52 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47130 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755285AbaJXUJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 16:09:50 -0400
Date: Fri, 24 Oct 2014 15:08:33 -0500
From: Felipe Balbi <balbi@ti.com>
To: Johan Hovold <johan@kernel.org>
CC: Felipe Balbi <balbi@ti.com>, Andrew Morton <akpm@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Tony Lindgren <tony@atomide.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        <nsekhar@ti.com>, <t-kristo@ti.com>, <j-keerthy@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <rtc-linux@googlegroups.com>,
        <linux-kernel@vger.kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH v2 00/20] rtc: omap: fixes and power-off feature
Message-ID: <20141024200833.GI11455@saruman>
Reply-To: <balbi@ti.com>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
 <1413913086-12730-1-git-send-email-johan@kernel.org>
 <20141024160845.GM26941@saruman>
 <20141024190251.GB19377@localhost>
 <20141024192540.GD11455@saruman>
 <20141024192948.GE11455@saruman>
 <20141024193655.GD19377@localhost>
 <20141024194442.GG11455@saruman>
 <20141024195532.GF19377@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LG0Ll82vYr46+VA1"
Content-Disposition: inline
In-Reply-To: <20141024195532.GF19377@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--LG0Ll82vYr46+VA1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 24, 2014 at 09:55:32PM +0200, Johan Hovold wrote:
> On Fri, Oct 24, 2014 at 02:44:42PM -0500, Felipe Balbi wrote:
> > On Fri, Oct 24, 2014 at 09:36:55PM +0200, Johan Hovold wrote:
> > > On Fri, Oct 24, 2014 at 02:29:48PM -0500, Felipe Balbi wrote:
> > > > Hi,
> > > >=20
> > > > On Fri, Oct 24, 2014 at 02:25:40PM -0500, Felipe Balbi wrote:
>=20
> > > > > with this I always get to "Power off failed -- system halted". If=
 I
> > > > > switch to v3.18-rc1 vanilla, then it works. So it's definitely ca=
used by
> > > > > your rtc-only patches.
> > >=20
> > > That's expected (see below). It works with v3.18-rc1 vanilla because
> > > machine_halt is called instead of machine_power_off as there is no
> > > registered power-off handler.
> >=20
> > yeah, that much I figured :-)
> >=20
> > > > ok, so it seems like it takes more than 1 second for things to
> > > > propagate. If I increase that mdelay() to 3000, then everything wor=
ks
> > > > fine on my end. I think we should get RMK's input on this 3000ms de=
lay
> > > > to machine_power_off(). Should it be generic, or should we add it t=
o our
> > > > rtc pm_power_off implementation ?
> > >=20
> > > As I wrote above, we still need a 2-second mdelay in rtc-omap, which I
> > > intend to add to the pmic_power_en patch.
> >=20
> > oh, alright then. If you can Cc me, I'll make sure to test that too ;-)
>=20
> I will. :) Just wanted to see whether Andrew preferred I resend the
> whole series or just that one patch first.
>=20
> The diff is minimal:
>=20
> diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
> index e74750f00b18..e4f97ad9eb21 100644
> --- a/drivers/rtc/rtc-omap.c
> +++ b/drivers/rtc/rtc-omap.c
> @@ -423,6 +423,8 @@ static void omap_rtc_power_off(void)
>         val =3D rtc_read(rtc, OMAP_RTC_INTERRUPTS_REG);
>         rtc_writel(rtc, OMAP_RTC_INTERRUPTS_REG,
>                         val | OMAP_RTC_INTERRUPTS_IT_ALARM2);
> +
> +       mdelay(2000);
>  }

you can add my:

Tested-by: Felipe Balbi <balbi@ti.com>

for this too. Now it's all good.

--=20
balbi

--LG0Ll82vYr46+VA1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUSrHBAAoJEIaOsuA1yqRETL4P/j2+2S8Eum0WZ4Ed7IeMAWrT
drWTYcsVbcXO8qUyfrD/5YTBgLcYiE/w2flcUANCGb6oPv2tXMv7hYJH4v+ez9Mu
Me9Xq0mX6oy6vzskzoguFNh8IPZNlBVVZ01a9xMVc/HzfCsGXyO9yXAdKpDtyaRN
7fFdOG4ROvCHvbh2vuCTM2OFwvgQCAM5k0ahEzXeJMcwQLBedyJXTlFimMr/l8Ek
WsJvYz79XnlH0lvx5z2cM+cnJYKBRO/Bb8lC9KMBBJRCLUyrfyKkBtJNW/pbv39R
bFWpqRWC/m0tJJHiZdHuoxuWpUMATUWPZEXI9fsTGF8bYLYKo4Ph4v/8LRYqIp83
eXD2WLbC0Vor6mTBnw/G+tYGOFYZKbyTealZZ1oH9tmjhk3WniYcRXIWU9+KuDp9
wuQJ/spBIatf2Bt/+Its8l+VN0ACCT0+RGT3sRo9CtsrDZ2m0bA5MyCWrZxgi0qu
LgG2xV6rxxuXBMk/tSu5F/7URjsD+eb42tQKpz4Jq47hIl62oXt4Dc0gVyv3cJ/3
vtKZ7vagn5mUR0yDu5P5t9QPhAvnV6TTfXIBbyi/5oIN//fwDeiHPnbKooQe7Woy
HXWRpNRtLaCdjwmpBLXWB0Xbyz3h/ebg4HS3uI+RMR5RMed8dAv3AH3DbTNwjD7V
9b5yWt3/Q3xLIXTMTWL4
=chnY
-----END PGP SIGNATURE-----

--LG0Ll82vYr46+VA1--
