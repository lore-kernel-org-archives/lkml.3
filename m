Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab3JZN1c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 09:27:32 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:51291 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab3JZN1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 09:27:31 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Sebastian Reichel <sre@ring0.de>
Subject: Re: N900 DT
Date: Sat, 26 Oct 2013 15:27:25 +0200
User-Agent: KMail/1.13.7 (Linux/3.11.0-1+synaptics-generic; KDE/4.11.1; x86_64; ; )
Cc: Jenny TC <jenny.tc@intel.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        linux-kernel@vger.kernel.org
References: <201310240806.49340@pali> <201310252039.41026@pali> <20131026002500.GA16970@earth.universe>
In-Reply-To: <20131026002500.GA16970@earth.universe>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart8647028.NS9pu2SEek";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201310261527.25787@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart8647028.NS9pu2SEek
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Saturday 26 October 2013 02:25:02 Sebastian Reichel wrote:
> Hi Pali,
>=20
> On Fri, Oct 25, 2013 at 08:39:40PM +0200, Pali Roh=C3=A1r wrote:
> > Now I found this patch and it looks like it will be in
> > mainline kernel. And after that it could be simple to
> > listen for needed events from isp driver in my bq driver
> > (without touching isp).
> >=20
> > https://lkml.org/lkml/2013/7/25/204
> >=20
> > Can you look at isp1704 driver for DT support? I think that
> > only one gpio needs to be passed to driver from board data.
>=20
> I had a quick overview over Jenny's patchset [0] (the patch
> you referenced is part of a bigger patchset). I don't think
> the scenario found in the Nokia N900 is covered by it, but
> probably now is the time to change it :)
>=20
> So for everybody new to this thread:
>=20
> Multiple chips are involved in the charging of the Nokia N900
> battery:
>=20
> bq27200:   This chip is used for reading battery status. AFAIK
>            it's not directly involved in charging the battery.
> bq24150a:  This chip takes care of actually charging the
> battery. It has no clue about USB related stuff. The maximum
> current it draws can be configured, though. isp1704:   USB
> charger detector. This chip is used to detect how much
> current may be used by the bq24150a chip. rx51-temp: Analog
> temperature sensor for the battery, which is connected via an
> analog-digital-converter.
>=20
> The question is how to connected these driver with each other
> if device tree is used to boot the system. Any suggestions?
>=20
> [0] http://thread.gmane.org/gmane.linux.kernel/1377608
>=20
> -- Sebastian

What I need is receive property change event (from isp1704) in=20
bq24150a. And with this patch https://lkml.org/lkml/2013/7/25/204=20
bq24150a driver can receive them and use only these which comes=20
from driver specified in DT (on n900 from isp1704).

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart8647028.NS9pu2SEek
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlJrwz0ACgkQi/DJPQPkQ1KpMgCeK3g5gDnW5bnB9M0Br01iDiFM
y8YAn2oqXcocBH3vrDEq/1J+eRKOpnZM
=3YRN
-----END PGP SIGNATURE-----

--nextPart8647028.NS9pu2SEek--
