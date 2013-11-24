Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab3KXVBB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 16:01:01 -0500
Received: from ring0.de ([91.143.88.219]:33462 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599Ab3KXVA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 16:00:58 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Sun, 24 Nov 2013 22:00:43 +0100
From: Sebastian Reichel <sre@ring0.de>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Anton Vorontsov <anton@enomsg.org>, David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, freemangordon@abv.bg, aaro.koskinen@iki.fi,
        pavel@ucw.cz
Subject: Re: [PATCH v2 2/3] bq2415x_charger: Use power_supply notifier for
 automode
Message-ID: <20131124210041.GA12180@earth.universe>
Mail-Followup-To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
	Anton Vorontsov <anton@enomsg.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Tony Lindgren <tony@atomide.com>,
	Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
	linux-omap@vger.kernel.org, freemangordon@abv.bg,
	aaro.koskinen@iki.fi, pavel@ucw.cz
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com>
 <201311242001.16299@pali>
 <20131124192608.GA11338@earth.universe>
 <201311242041.47075@pali>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline
In-Reply-To: <201311242041.47075@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 24, 2013 at 08:41:46PM +0100, Pali Roh=E1r wrote:
> On Sunday 24 November 2013 20:26:09 Sebastian Reichel wrote:
> > On Sun, Nov 24, 2013 at 08:01:16PM +0100, Pali Roh=E1r wrote:
> > > Currently on Maemo 5 this is handled in userspace (with open
> > > source dsme daemon).
> >=20
> > I assume it currently also takes care of the bq2415x watchdog?
> > That means if the daemon dies charging will stop, because the
> > watchdog does no longer trigger.
> >=20
> > When your patch is applied you have introduced a safety issue.
> > When the daemon dies charging will continue and temperature is
> > no longer checked.
> >=20
> > -- Sebastian
>=20
> No dsme checking battery temperature and does not handle bq24510=20
> timer (previously this was in closed bme daemon which=20
> functionality is now in kernel drivers).

Ok, so then the temperature checks are done by bme.

> But dsme daemon also kicking tlw4030 watchdog, so when daemon dies
> after 30s tlw4030 reboot device.

Yes, but that does not matter if it does not take care of the
charging. If the dsme daemon is not started for some reason
phone will not be rebootet and phone charges.

> But right you can implement correctly this in userspace (e.g.=20
> when daemon not running/crashed, you can restart daemon or reboot=20
> system or disable charing, whatever...) and you do not need to=20
> have it in kernel...

That does not change the fact, that the kernel openes a safety issue
in default configuration. To be on the safe side charging must be
disabled until some safety checking daemon enables it.

-- Sebastian

--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSkmj4AAoJENju1/PIO/qawdQP/jtB4+Ua9MfCJrPTzWXe2uSH
GzYT+K/j0ygcbHtyF9ILL6d3mxEOubzkayyeGORw8S+Snwti4gLWr28C6njG87Ck
JnhatWGIItPRRliBmcyjfIHVjENkW/JwbeICCi5HeeUs5ZxAdlltVbCzycDCmlUy
6kLik0CpIiceigvVihcvWNbfYwcxk9BwgwlROzmgynUGg2vARCNUsOIs3HUGydsG
b4c2WEiwOGz2UBhfPIcvjIKcImDNG3sDlgW8u+yPFf6TbhQw0g+iQsgoh2IqoJLk
tZNguTXLyMdaCNejhpXWIgtI6R0Qxja9g53bxtrk2uj7ikdQRJZaE5SwyXVsmnDj
uY/0A9t2SByWiSdmHHZa2O9/urabi1Un9NEdWcbu0Z7nH4tsa96ExmT8Uujx7VNC
M9Cobq5EhXLVqEDUgn88VPOWuyd8K494TGZl5hNbH+N5HS3KLPOLWeZjaZPHXL30
meIpzdfhJXFhep3Ni+GtNhNYT9h7PSOWXILFvgs07Ovudm3u+gmgny/A+qslSzNB
ArjrL4lEB+zYtCv8/Vr+u6421i1nZCzIEck/KHEwIrnQNehvSz4qkD6wTHCEEkF5
iIcjDLixWYZztZ7yRx5AIAcWwTSrYNdJ5pgURILIxjGRjcoUEu2FF0LP2+iddrOu
r9zB2Dgd7x3XkJi438Ym
=ylqx
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--
