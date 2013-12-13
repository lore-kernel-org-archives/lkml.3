Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab3LMKkJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 05:40:09 -0500
Received: from top.free-electrons.com ([176.31.233.9]:32883 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752383Ab3LMKkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 05:40:06 -0500
Date: Fri, 13 Dec 2013 11:38:22 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        netdev <netdev@vger.kernel.org>, Rob Herring <rob.herring@calxeda.com>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>
Subject: Re: [PATCH 04/10] net: stmmac: sunxi platfrom extensions for GMAC in
 Allwinner A20 SoC's
Message-ID: <20131213103822.GX3651@lukather>
References: <1386350983-13281-1-git-send-email-wens@csie.org>
 <1386350983-13281-5-git-send-email-wens@csie.org>
 <52A5A52C.50605@st.com>
 <CAGb2v67WiCaMpJEzA_X6o7uOu6i3w3FCEz7=N5HY0amQb01SZA@mail.gmail.com>
 <52A72C6D.60100@st.com>
 <CAGb2v64qQvqJSicA6MTAxeh1sGjWY=Pk=vDq=9J3pTQW+wkXrA@mail.gmail.com>
 <52A87A74.8040807@st.com>
 <20131212090415.GQ3651@lukather>
 <CAGb2v655_83b76PTmgkDmNGCADWwTjTwW13sOgM5HFmCVkeu=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jIdBwf7/i7YThJrI"
Content-Disposition: inline
In-Reply-To: <CAGb2v655_83b76PTmgkDmNGCADWwTjTwW13sOgM5HFmCVkeu=w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jIdBwf7/i7YThJrI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 12, 2013 at 06:31:43PM +0800, Chen-Yu Tsai wrote:
> Hi,
>=20
> On Thu, Dec 12, 2013 at 5:04 PM, Maxime Ripard
> <maxime.ripard@free-electrons.com> wrote:
> > Hi,
> >
> > On Wed, Dec 11, 2013 at 02:45:08PM +0000, srinivas kandagatla wrote:
> >> >>> 1. .tx_coe
> >> >>>    This is not exported in the DT bindings.
> >> >>>    Looking at stmmac code, not setting this seems to disable all
> >> >>>    checksum offloading.
> >> >>
> >> >> Why cant this go via DT as well?
> >> >
> >> > If you and Giuseppe are OK with this, why not?
> >> Am Ok with it.
> >
> > Please note that I'm opposed to this until someone explain why putting
> > it in the DT is relevant (and not just convenient).
>=20
> Checksum offloading is an optional feature[1], implemented starting
> from version 3.20a. It is not tied to a specific IP version. As such,
> using a "snps,dwmac-<version>" compatible isn't a good fit here.

No, but we're not in such case. Since we have a compatible of our own,
we can derive it from that. Putting a property in the DT would only be
redundant.

> stmmac does auto-detection for optional features on MAC version > 3.50a.
> This is what Srinivas was referring to.
>=20
> Unfortunately, our MAC is < 3.50a. No auto-detection. We could add a
> "snps,dwmac-tx-coe" compatible for this, or the seperate DT property.
>=20
> The other way would be to pass the flags in the initial .data with the
> SoC specific compatible. Other SoCs with the same feature won't be
> able to reuse the same compatible though.

Which is already pretty much the case, since we have to deal with
Allwinner specific code and features.

A new compatible is cheap to maintain, a new property is not.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--jIdBwf7/i7YThJrI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSquOeAAoJEBx+YmzsjxAgcm4QALbmEmllnuMC47g9ghh+ZmyS
qo6wligG4OljeJiCRzRJJVIrjsZEvR5aDO9AYwVWmpT8V4izhBK2QbpfLBlbNi6s
MMVFNNjhjHPTOO61Iz2IMl2rS9x6NaKpvrGdOLfHfCoa0OGEC83pxDAVUao2U0s9
NDKQz1WXJ5ymMbyQKO/TSlemkiXv7P8kDaNknA3B+10IsqMEQGR4e4Vh5lRFE7rm
0g+Xm4isExXg14azIwgC0tAm3RmSXju5Z35peso8znZy4SWLYTH7THJ8ayvPM801
5mpMEFDdhxRdYAOo5ee3KHV9QWLDljrSOf3SLeq1Cw4jcUCN1HA0bjUiVafmhUlz
ENE21PE9/L6B1xXhlQ7VvBUCb3i96AQAQYFp1LO+CqZnNLY9F/9FkqJnueeUJzIP
u+3I0xubSnC1EcXcAxeHbXyAOt2XseUff68/Hem47g0wV7mfIThrk2EWIgjXvBFB
ldfGgPa/IC388Z3++L5fjGljGJSnmEiOHJncZ07oq7GmRIOokWgrkmKJSokJ0zOt
O52hgakUZibNDfiMnwkf3Gf40RL+Pc5AiknjFUspIwJK2aJx5ezVdOF8sJhX2KWy
SpSVol36IiqKb0XM4ea5IQ1GGTSsE7DEkzKSepU/2nyZekw6qScGLrgN4B/g6tek
jdyRcyYpdJ4KSaFytCIF
=EFnI
-----END PGP SIGNATURE-----

--jIdBwf7/i7YThJrI--
