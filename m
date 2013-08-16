Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943Ab3HPHOf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 03:14:35 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:35870 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab3HPHOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 03:14:33 -0400
From: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
To: Martin Peres <martin.peres@labri.fr>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: Re: nouveau: temperature on nv40 is unavailable since ad40d73ef533ab0ad16b4a1ab2f7870c1f8ab954
Date: Fri, 16 Aug 2013 09:14:29 +0200
Message-ID: <1616575.x8rWiILC8l@pali>
User-Agent: KMail/4.10.5 (Linux/3.8.0-27-generic; KDE/4.10.5; x86_64; ; )
In-Reply-To: <520D547F.2060600@labri.fr>
References: <1836330.fGgIDqPTNA@pali> <201308150924.49518@pali> <520D547F.2060600@labri.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3401802.4lgaRm4Sf0"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart3401802.4lgaRm4Sf0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Thursday 15 August 2013 18:21:51 Martin Peres wrote:
> On 15/08/2013 03:24, Pali Roh=E1r wrote:
> > On Thursday 15 August 2013 04:07:24 Martin Peres wrote:
> >> On 14/08/2013 05:02, Pali Roh=E1r wrote:
> >>> On Tuesday 13 August 2013 15:55:28 Martin Peres wrote:
> >>>> On 13/08/2013 09:53, Pali Roh=E1r wrote:
> >>>>> On utorok, 13. augusta 2013 15:32:45 CEST, Martin Peres
> >>>=20
> >>> wrote:
> >>>>>> On 13/08/2013 09:23, Pali Roh=E1r wrote:
> >>>>>>> On Tuesday 13 August 2013 09:01:19 Martin Peres wrote:
> >>>>>>    ...
> >>>>>>=20
> >>>>>> You can check the temperature by running nvidia-settings.
> >>>>>> If you can't see the temperature in it, then nvidia
> >>>>>> doesn't support it on your card and
> >>>>>> I'm not sure we should :s
> >>>>>>=20
> >>>>>> Thanks for the vbios you sent me in private. For the
> >>>>>> others, the reason why he doesn't have temperature
> >>>>>> anymore is because his vbios lacks sensor calibration
> >>>>>> values.
> >>>>>=20
> >>>>> In nvidia-settings tab "GPU 0 - (GeForce 6600 GT)" -->
> >>>>> "Thermal Settings" is:
> >>>>>=20
> >>>>> Thermal Sensor Information:
> >>>>> ID: 0
> >>>>> Target: GPU
> >>>>> Provider: GPU Internal
> >>>>> Temperature: 70 C (now)
> >>>>>=20
> >>>>> I looked in Windows program SpeedFan. It found Nvidia PCI
> >>>>> card and reported "GPU Temp" about 68-70 C. So it looks
> >>>>> like both nvidia driver and windows SpeedFan program
> >>>>> reading same values.
> >>>>=20
> >>>> Great, I'll cook you a patch in a bit and you'll see what
> >>>> the temperature is like. It won't be perfectly accurate
> >>>> but there is some kind of default for nvidia cards of this
> >>>> generation.
> >>>=20
> >>> Ok, send me patch and I can try it if it will work and
> >>> report similar values as windows or nvidia driver.
> >>=20
> >> Sorry for the late answer.
> >>=20
> >> Please test this patch. Be aware that temperature with nouveau
> >> will be higher than with the blob.
> >> I only want to see if nouveau reports a temperature.
> >>=20
> >> The only way to be sure if the values are good-enough would be
> >> to use the blob and run:
> >> nvapeek 0x15b0
> >> Please send me the result along with the temperature reported
> >> by nvidia at the time of the peek.
> >>=20
> >> Martin
> >>=20
> >> PS: This patch has only be compile-tested, I don't have access
> >> to an nv4x right now.
> >=20
> > Hello,
> >=20
> > now after patch nouveau report temperature:
> >=20
> > $ sensors
> > ...
> > nouveau-pci-0500
> > Adapter: PCI adapter
> > temp1:        +63.0=B0C  (high =3D +95.0=B0C, hyst =3D  +3.0=B0C)
> >=20
> >                         (crit =3D +145.0=B0C, hyst =3D  +2.0=B0C)
> >                         (emerg =3D +135.0=B0C, hyst =3D  +5.0=B0C)
>=20
> Ok, that was expected ;)
>=20
> > ...
> >=20
> > I found that nvidia binary driver has command line utility
> > nvidia-smi which report same temperature as X utility nvidia-
> > settings. So I will use nvidia-smi (if it is OK).
> >=20
> > And after reboot nvidia report another temperature value:
> >=20
> > $ nvidia-smi -q -d TEMPERATURE
> > ...
> > GPU 0000:05:00.0
> >=20
> >      Temperature
> >     =20
> >          Gpu                     : 70 C
> >=20
> > Immediately I called nvapeek command:
> >=20
> > $ nvapeek 0x15b0
> > 000015b0: 1000008e
> >=20
> > So value reported by nouveau is lower than value reported by
> > nvidia binary driver.
>=20
> As you didn't run nvapeek 15b0 when running nouveau it is hard to tel=
l
> if it is due to
> calibration values or because the temperature was lower.
>=20

I run it and it always reported value 000000ff (also when temperature c=
hanged).

> Could you please read the temperature + peek 15b0 when running nouvea=
u?
>=20
> Anyway, it is weird because I cannot find 70=B0C with 0x8e as an inpu=
t
> temperature and with
> the current default values :o
>=20

My idea is that register does not contains temperature. Both nouveau an=
d=20
nvidia driver when show different temperature it does not show differen=
t output=20
from "nvapeek 0x15b0".

Now I started computer with nouveau driver. Temperature is incresing, b=
ut=20
nvapeek 0x15b0 is still same.

So do you really needs other tests with nvapeek 0x15b0? Is that registe=
r=20
correct?

> > I wait some some and started nvidia-smi and nvapeek again, here
> > are results:
> >=20
> > $ nvidia-smi -q -d TEMPERATURE
> > ...
> > GPU 0000:05:00.0
> >=20
> >      Temperature
> >     =20
> >          Gpu                     : 67 C
> >=20
> > $ nvapeek 0x15b0
> > 000015b0: 1000008e
> >=20
> > So it looks like that nvapeek returning always same value and
> > does not depends on temperature... It is OK?
>=20
> Well, it looks like the temperature reading is very noisy!
> Could you please get the temperature + peek when the card is as hot a=
s
> possible?
>=20
> There is a very effective solution to get a GPU hot, use a hair drier=
.
> If you could get your
> GPU to at 110=B0C (or less, if you feel like it is too much), that co=
uld
> help me check the formula
> and default values.
>=20
> PS: I attached a new version of the patch that should improve the
> temperature accuracy for
> nv43s. Could you test it and send me your kernel log?

--=20
Pali Roh=E1r
pali.rohar@gmail.com


--nextPart3401802.4lgaRm4Sf0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlIN0VUACgkQi/DJPQPkQ1KG0QCggvDVDU7zUB0x3MqZEPNJ0fBc
HtgAnAm3pwgztfb8u+TxhZXSnUQnaeYb
=tUBm
-----END PGP SIGNATURE-----

--nextPart3401802.4lgaRm4Sf0--

