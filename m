Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab3KYVuN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 16:50:13 -0500
Received: from ring0.de ([91.143.88.219]:39022 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810Ab3KYVuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 16:50:10 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Mon, 25 Nov 2013 22:50:01 +0100
From: Sebastian Reichel <sre@ring0.de>
To: =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>
Cc: pavel@ucw.cz, pali.rohar@gmail.com, anton@enomsg.org, dwmw2@infradead.org,
        tony@atomide.com, linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, aaro.koskinen@iki.fi
Subject: Re: [PATCH v2 2/3] bq2415x_charger: Use power_supply notifier for
 automode
Message-ID: <20131125214959.GA20107@earth.universe>
Mail-Followup-To: =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= <freemangordon@abv.bg>,
	pavel@ucw.cz, pali.rohar@gmail.com, anton@enomsg.org,
	dwmw2@infradead.org, tony@atomide.com, linux@arm.linux.org.uk,
	linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
	aaro.koskinen@iki.fi
References: <1434978251.31721.1385404366021.JavaMail.apache@mail83.abv.bg>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
In-Reply-To: <1434978251.31721.1385404366021.JavaMail.apache@mail83.abv.bg>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Nov 25, 2013 at 08:32:46PM +0200, =D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=
=BE =D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2 wrote:
> So, AIUI there are 2 options:
>=20
> 1. charger driver polls the battery driver every n (60?) seconds.
> 2. battery driver sends PSY_EVENT_PROP_CHANGED on every degree
>    up or down.
> =20
> In both cases if the temperature is outside of the safe margins, the
> charging should be stopped.

ACK.

> 2 seems more generic to me, but as rx51-battery is missing the
> functionality to send events on temperature change, I guess 1 will
> be easier to implement.

The temperature must be polled anyway, if the ADC does not support
interrupts.

> And I think there should be some method (sysfs entry?, /dev/bqxxx
> opened?) to tell the charger driver to stop polling the battery=20
> driver once (and if) the userspace has started to take care of the=20
> battery temperature - makes no sense to duplicate the checks IMO.

I would just cache the temperature value in the battery driver for a
couple of seconds. Then userspace can check for very high temperatures
(-> system shutdown) and the charging driver can check for
temperatures, which are critical for charging.

-- Sebastian

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSk8YHAAoJENju1/PIO/qaDD8P/2dmcE7jRiQtO26FgEDGlsjO
fb2/4amDr/3rat+6zgRWmHMVRu+LNoRSZKNiBgcSKNGBKE94PzIZ16IunDeCvGJP
O6Heiwrc+wGn5se+dnllEH7fh09yZBioeth0ljI7TwZrF8cuMDejpZ215LVQ11Zf
hmTOtq3tnQAH91otgL0WoWeEzAbJBXLoGVqkhjsoVXrlEySjVqbmCS5zwOKBiS90
qdsqGEUvZFnQnlMfcixYqhuSaBpQ4pAomkjjdOvLUAfZiyM9le6DWH7FRBAFb4PC
mU//G9KifDT54Oo2V7KibPhUbPKtaX5G6IaYF1y0lSP7RkN2yAIFiS/5OTU34F1S
O6ht0NyAi1DhWicr6wq0hOi+Yj4U8uyemiPWIUv0unzsCuDmJpg11Ii/uWJSikJL
aP1zqjJfFlCQ+vr/TbwTCl5fge45BEUy4jnbi/HJ1tAgKevoXeu2Hp7cLPE8ZQ6T
GbYMpyrRL6sNcepup+KGpHyVB+LuSAxyiVg2UM+FMDGwmWRAra7AQPLVN73BPmPR
hGv+NcF3D00enWLozZFYvSddhPGWp9KU1tiln52r2N0QZh7J/rYZyeJYELFe6CIr
lL77i25BhzdzbOXCFlRCkwcvriOldAI6L8lfKX2KNJm25C8DXedTGE1YGgeCWeEv
rAaRz4icSTidrHeRFNUM
=EhwB
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
