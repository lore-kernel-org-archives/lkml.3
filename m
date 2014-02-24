Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775AbaBXQcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 11:32:17 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:52753
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752316AbaBXQcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 11:32:15 -0500
X-Forefront-Antispam-Report: CIP:141.131.128.20;KIP:(null);UIP:(null);IPV:NLI;H:mail2.cirrus.com;RD:mail2.cirrus.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI9371I1432Ide40hzz1f42h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh109h2a8h839hd25he5bhf0ah1288h12a5h12bdh137ah1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1b0ah1b2bh1bceh2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h2052h20b3h20f0h2216h22d0h2336h2438h2461h2487h24ach24d7h2516h2545h255eh34h1155h)
From: "Austin, Brian" <Brian.Austin@cirrus.com>
To: Nicolin Chen <Guangyu.Chen@freescale.com>
CC: Mark Brown <broonie@kernel.org>,
        "Handrigan, Paul" <Paul.Handrigan@cirrus.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: Re: [PATCH] ASoC: cs42888: Add codec driver support
Thread-Topic: [PATCH] ASoC: cs42888: Add codec driver support
Thread-Index: AQHPMS1KzgusFkzpNEqgijBE3/gW+5rEqciAgABJRACAAAQHgIAABxAA
Date: Mon, 24 Feb 2014 16:32:06 +0000
Message-ID: <FF523989-CEF7-4A91-92A0-63D5FB90D897@cirrus.com>
References: <1393224929-7555-1-git-send-email-Guangyu.Chen@freescale.com>
 <20140224113011.GE25940@sirena.org.uk>
 <B745DBDD-8A64-4B98-819B-72F8AFF602DE@cirrus.com>
 <20140224160648.GC6132@MrMyself>
In-Reply-To: <20140224160648.GC6132@MrMyself>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [141.131.108.115]
Content-Type: multipart/signed;
	boundary="Apple-Mail=_329C7435-941F-4099-B667-9AF20083595A";
	protocol="application/pgp-signature"; micalg=pgp-sha512
MIME-Version: 1.0
X-OriginatorOrg: cirrus.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Apple-Mail=_329C7435-941F-4099-B667-9AF20083595A
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252


On Feb 24, 2014, at 10:06 AM, Nicolin Chen <Guangyu.Chen@freescale.com> =
wrote:

> On Mon, Feb 24, 2014 at 03:52:24PM +0000, Austin, Brian wrote:
>>>> +	if (!IS_ERR(cs42888->clk))
>>>> +		clk_disable_unprepare(cs42888->clk);
>>>=20
>>> Does the device work without MCLK?
>> Yes, MCLK is required. If you can=92t get the clock you should error =
out.
>=20
> Wait...Regarding this clock part, I just forgot the reason I put the =
code:
>=20
> 385         cs42888->clk =3D devm_clk_get(&i2c->dev, "mclk");
> 386         if (IS_ERR(cs42888->clk))
> 387                 dev_warn(&i2c->dev, "failed to get the clock: =
%ld\n",
> 388                                 PTR_ERR(cs42888->clk));
>=20
> was because the MCLK might be provided from SoC (DAI master) so it =
could
> be totally controlled by CPU DAI driver, ESAI for example has its own
> dividers to derive the HCKT clock (MCLK for Tx) from ahb clock in SoC
> clock tree, in which case we might not easily pass a valid clock =
phandle
> via DT. (RFC to this thought.)
OK, It=92s an external MCLK source, so why not just handle that in the =
machine driver?=20
Usually you would want the clock enabled/disabled in the machine driver =
so if you don=92t get it, you can bail out there.=20
At least that is how I do our MCLK=92s. Since you are only using the =
freq of the clock to derive modes, just put the clock initialization =
outside and just pass in the freq like you do in set_sysclk

--Apple-Mail=_329C7435-941F-4099-B667-9AF20083595A
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQEcBAEBCgAGBQJTC3QGAAoJEHdXZdGWfiO7RQgIAKppnNelAKpiRR/Bmgyby3rB
k0zh4GzYx4bwXoZBTVNQnjuGKcC2DvV9EDvmTEynzhmxKCfrKGRreiksDOO9I3Q3
pb7C2tbudG3nSUAC4xosmMh3U/URPhpWAN5tU9gmN+kPz1M/FHInNlrw5/fWIqhz
4fp7030xcFV0FzLwu3J8rMd434WKEIbEv/dpAJxxwj2q8NnfnIIiSahkjIYSNSJ7
RFuf/lYz1ArnirWRt4NXsEbkWY079GirPePIgvt7OKgxQj3boAqZetJ2mhlPpgpn
B52dtDNhrgYCF1/ihNcayD6+uC6xOMdHdT8pvLGBu2c2jwggrs/Zm/To8kgpbcc=
=h0Jn
-----END PGP SIGNATURE-----

--Apple-Mail=_329C7435-941F-4099-B667-9AF20083595A--
