Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab3KXTly (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 14:41:54 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:44865 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab3KXTlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 14:41:51 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Sebastian Reichel <sre@ring0.de>
Subject: Re: [PATCH v2 2/3] bq2415x_charger: Use power_supply notifier for automode
Date: Sun, 24 Nov 2013 20:41:46 +0100
User-Agent: KMail/1.13.7 (Linux/3.11.0-14-generic; KDE/4.11.3; x86_64; ; )
Cc: Anton Vorontsov <anton@enomsg.org>, David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, freemangordon@abv.bg, aaro.koskinen@iki.fi,
        pavel@ucw.cz
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com> <201311242001.16299@pali> <20131124192608.GA11338@earth.universe>
In-Reply-To: <20131124192608.GA11338@earth.universe>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7971141.LebVL2NGrv";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201311242041.47075@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart7971141.LebVL2NGrv
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 24 November 2013 20:26:09 Sebastian Reichel wrote:
> On Sun, Nov 24, 2013 at 08:01:16PM +0100, Pali Roh=C3=A1r wrote:
> > Currently on Maemo 5 this is handled in userspace (with open
> > source dsme daemon).
>=20
> I assume it currently also takes care of the bq2415x watchdog?
> That means if the daemon dies charging will stop, because the
> watchdog does no longer trigger.
>=20
> When your patch is applied you have introduced a safety issue.
> When the daemon dies charging will continue and temperature is
> no longer checked.
>=20
> -- Sebastian

No dsme checking battery temperature and does not handle bq24510=20
timer (previously this was in closed bme daemon which=20
functionality is now in kernel drivers). But dsme daemon also=20
kicking tlw4030 watchdog, so when daemon dies after 30s tlw4030=20
reboot device.

But right you can implement correctly this in userspace (e.g.=20
when daemon not running/crashed, you can restart daemon or reboot=20
system or disable charing, whatever...) and you do not need to=20
have it in kernel...

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart7971141.LebVL2NGrv
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlKSVnsACgkQi/DJPQPkQ1JYowCgv68iwEMUSG+g77Wtv5i6NKxl
XXgAoJ0gyNwf6QmbjfIo8KWBdVczerNY
=Z68E
-----END PGP SIGNATURE-----

--nextPart7971141.LebVL2NGrv--
