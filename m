Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758361Ab3K1AZ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 19:25:57 -0500
Received: from ring0.de ([91.143.88.219]:51840 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753959Ab3K1AZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 19:25:54 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Thu, 28 Nov 2013 01:25:50 +0100
From: Sebastian Reichel <sre@debian.org>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        pavel@ucw.cz, anton@enomsg.org, dwmw2@infradead.org, tony@atomide.com,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, aaro.koskinen@iki.fi
Subject: Re: [PATCH v2 2/3] bq2415x_charger: Use power_supply notifier for
 automode
Message-ID: <20131128002549.GA5548@earth.universe>
Mail-Followup-To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
	=?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= <freemangordon@abv.bg>,
	pavel@ucw.cz, anton@enomsg.org, dwmw2@infradead.org,
	tony@atomide.com, linux@arm.linux.org.uk,
	linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
	aaro.koskinen@iki.fi
References: <1434978251.31721.1385404366021.JavaMail.apache@mail83.abv.bg>
 <20131125214959.GA20107@earth.universe>
 <201311272216.47390@pali>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
In-Reply-To: <201311272216.47390@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 27, 2013 at 10:16:47PM +0100, Pali Roh=E1r wrote:
> On Monday 25 November 2013 22:50:01 Sebastian Reichel wrote:
> > > 2 seems more generic to me, but as rx51-battery is missing
> > > the functionality to send events on temperature change, I
> > > guess 1 will be easier to implement.
> >=20
> > The temperature must be polled anyway, if the ADC does not
> > support interrupts.
> >=20
>=20
> Yes, ADC does not support interrupts, temperature must be polled.=20
> Also bq27200 chip does not support interrupts, but=20
> bq27x00_battery driver using delayed work which every 60s poll=20
> all values (timeout can be configured via modprobe param). So=20
> similar code can be added to rx51_battery.ko too.

I think the safest implementation would be:

bq2415x polls the temperature from rx51-battery in the bq2415x
watchdog handler. That way discontinuation of the charge process
is guaranteed.

To avoid useless ADC conversion the rx51-battery driver caches the
converted temperature value for a reasonable time (e.g. 10 seconds).
This helps if multiple users want to read the battery temperature
(e.g. userspace).

This also means, that the kernel stuff can handle charging
autonomously and the userland daemon checks the battery temperature
only for emergency shutdown (I guess the temperatures for stopping
the charging and emergency shutdown are different).

IMHO it makes sense to move the emergency shutdown also into the
kernel (but different driver!) in the future, but that's another
topic :)

-- Sebastian

--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSlo2NAAoJENju1/PIO/qaxnUP/iWttibMN/h756OOZuedNey+
5Kd2JLv0i9pG0b63nUKjabDJ40ROcPjkHyfQKM0TapY6rZxNDRjFDSh4QS5Lqf4B
u74FYgwFMG57AlBx3tNaGC40ajUDT0mvQEMYvXArD7XezTyKUUWRJB8tl+JqwRfn
uTHiPfqb02k3O09NH4+NQsSGt7stzZqcQoN1OKz81JGuBGb06ypBEOBkEZa2P45S
H4m6Zmls+l55jcGq3S0yHuzCM/EWLzcmKH/SnmAsTvvzBxUX/7YEdnTMv/I2DJYl
aCNimlmO1t57asGdNbUQhMO10E7w3XcRDBiU9lMsLQ5GQMXfkgjqxJHDWm0hyeOX
Xg3L0lYf3KvijG0EwUy4U1sSX6Q5pf7E5hTO2K57uOenW5pZbF6jOt4Z1uWVjkYi
f/AVGvZ4jkECRvT7iW6wa+7+64SaXtU7V1r8h8I4urPYBJD9E0K8MF85kzpnFFni
EJQCrCpcGE6ObuH25gdElWTFhWYQVngSLqvOqK30MqBay+5brG+EOc0uowCTRM4G
9OIsZTuYcTye0wnOTJk2rI5sAyo4yvKUYi43mh9XvlHOw6S9AX0+EMNwyGZ+38T8
zqkopU+oIgD0bO/qxc+XcEtWtZmQHCfCaR1DF8noBL9uRRDDg8Cnx4dxPLjVauw6
lWC1RA9ShdgRXdN6HM7Y
=lveK
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
