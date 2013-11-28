Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706Ab3K1GxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 01:53:17 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:42739 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab3K1GxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 01:53:15 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Sebastian Reichel <sre@debian.org>
Subject: Re: [PATCH v2 2/3] bq2415x_charger: Use power_supply notifier for automode
Date: Thu, 28 Nov 2013 07:53:10 +0100
User-Agent: KMail/1.13.7 (Linux/3.11.0-14-generic; KDE/4.11.3; x86_64; ; )
Cc: =?utf-8?q?=D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE?=
	 =?utf-8?q?_=D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2?= 
	<freemangordon@abv.bg>,
        pavel@ucw.cz, anton@enomsg.org, dwmw2@infradead.org, tony@atomide.com,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, aaro.koskinen@iki.fi
References: <1434978251.31721.1385404366021.JavaMail.apache@mail83.abv.bg> <201311272216.47390@pali> <20131128002549.GA5548@earth.universe>
In-Reply-To: <20131128002549.GA5548@earth.universe>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1688946.yaiLlMhO3C";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201311280753.11274@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1688946.yaiLlMhO3C
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thursday 28 November 2013 01:25:50 Sebastian Reichel wrote:
> On Wed, Nov 27, 2013 at 10:16:47PM +0100, Pali Roh=C3=A1r wrote:
> > On Monday 25 November 2013 22:50:01 Sebastian Reichel wrote:
> > > > 2 seems more generic to me, but as rx51-battery is
> > > > missing the functionality to send events on temperature
> > > > change, I guess 1 will be easier to implement.
> > >=20
> > > The temperature must be polled anyway, if the ADC does not
> > > support interrupts.
> >=20
> > Yes, ADC does not support interrupts, temperature must be
> > polled. Also bq27200 chip does not support interrupts, but
> > bq27x00_battery driver using delayed work which every 60s
> > poll all values (timeout can be configured via modprobe
> > param). So similar code can be added to rx51_battery.ko
> > too.
>=20
> I think the safest implementation would be:
>=20
> bq2415x polls the temperature from rx51-battery in the bq2415x
> watchdog handler. That way discontinuation of the charge
> process is guaranteed.
>=20
> To avoid useless ADC conversion the rx51-battery driver caches
> the converted temperature value for a reasonable time (e.g.
> 10 seconds). This helps if multiple users want to read the
> battery temperature (e.g. userspace).
>=20
> This also means, that the kernel stuff can handle charging
> autonomously and the userland daemon checks the battery
> temperature only for emergency shutdown (I guess the
> temperatures for stopping the charging and emergency shutdown
> are different).
>=20
> IMHO it makes sense to move the emergency shutdown also into
> the kernel (but different driver!) in the future, but that's
> another topic :)
>=20
> -- Sebastian

Just to note, here is original nokia table of temperature limits:

https://gitorious.org/rx51-bme-replacement/dsme-thermalobject-surface/sourc=
e/master:modules/thermalobject_surface.c#L40

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1688946.yaiLlMhO3C
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlKW6FcACgkQi/DJPQPkQ1KNnQCgtrtxCG0VgFBASUPp/zO5oLUq
XHAAn2ae97Y7y9UA0eb4FVqwhJn9W9fD
=NHFb
-----END PGP SIGNATURE-----

--nextPart1688946.yaiLlMhO3C--
