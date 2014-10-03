Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbaJCKFs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 06:05:48 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:38485 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbaJCKFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 06:05:46 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH 3/3] input: alps: Reset mouse and ALPS driver immediately after first invalid packet
Date: Fri, 3 Oct 2014 12:05:42 +0200
User-Agent: KMail/1.13.7 (Linux/3.17.0-031700rc6-generic; KDE/4.14.1; x86_64; ; )
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Yunkang Tang <yunkang.tang@cn.alps.com>,
        Tommy Will <tommywill2011@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1412329392-5580-1-git-send-email-pali.rohar@gmail.com> <1412329392-5580-4-git-send-email-pali.rohar@gmail.com> <542E72A8.2030908@redhat.com>
In-Reply-To: <542E72A8.2030908@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3156729.R03uagbh4H";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201410031205.42927@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3156729.R03uagbh4H
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Friday 03 October 2014 11:55:52 Hans de Goede wrote:
> Hi,
>=20
> On 10/03/2014 11:43 AM, Pali Roh=C3=A1r wrote:
> > For unknown reasons linux psmouse alps driver sometimes
> > receive totally invalid packet sequences on Dell Latitude
> > laptops. According to ALPS HW engineers these invalid
> > packets do not come from ALPS devices. So it looks like bug
> > in BIOS and EC incorrectly split keyboard and touchpad PS/2
> > data when laptops are under heavy loads (big I/O together
> > with powersave governor, running on battery).
> >=20
> > There are sequences of invalid packets (which are dropeed)
> > and some sequences which look like valid. But these valid
> > packets cause random trackstick button pressing, random
> > cursor moving/jumping and in these condition it is not
> > possible to use ALPS device (trackstick+touchpad).
> >=20
> > To prevent random button press and random cursor jumps
> > immediately reset ALPS device after first invalid packet.
> > This will cause that touchpad and trackstick will not
> > respond for one or two seconds and it better then random
> > cursor jumps.
>=20
> This one probably should have:
>=20
> Bug: https://bugzilla.redhat.com/show_bug.cgi?id=3D1145954
>=20

Yes, in that bug is described same problem as on my E6440.

> And you may want to add Bug: tags to the relevant patches for
> the launchpad issues too.
>=20

I just added links to famous ALPS bugs which looks like that one=20
which I have on my E6440. But I'm not sure if my patches will=20
resolve these problems on other machines too.

> While on the topic of tags, once we've agreed upon the return
> value to use for the 2nd patch, can you please resend with a
> "Cc: stable@vger.kernel.org" added to all 3 patches?
>=20

I would like if somebody else can test patches on other machines=20
with ALPS devices. Specially this third if it does not break=20
something else.

Note that this third patch does not fixing problem correctly with=20
jumping & clicking. It just immediately reset ps/2 device if it=20
receive invalid packages. So it only try to prevent jumping &=20
clicking. On my E6440 machine it somehow working. When driver=20
doing ps/2 reset keyboard, touchpad and trackstick not=20
responding. I think it is better then having random clicks but=20
somebody else really should try and test patches how it will work=20
on other machines.

Proper fix would be to understand why invalid packets are=20
received and try to force buggy component to not send these=20
invalid packets.

> > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> > Tested-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
>=20
> Looks good and seems sensible:
>=20
> Acked-by: Hans de Goede <hdegoede@redhat.com>
>=20
> Thanks & Regards,
>=20
> Hans

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart3156729.R03uagbh4H
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlQudPYACgkQi/DJPQPkQ1IoqwCguY4NHk+iXrFuDrMSYe2RlbO0
EZ8AoKFn5RAITwLHegChFIPOH4AruKgi
=yXbE
-----END PGP SIGNATURE-----

--nextPart3156729.R03uagbh4H--
