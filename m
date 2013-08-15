Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760464Ab3HOHYy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 03:24:54 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:61059 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758756Ab3HOHYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 03:24:53 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Martin Peres <martin.peres@labri.fr>
Subject: Re: nouveau: temperature on nv40 is unavailable since ad40d73ef533ab0ad16b4a1ab2f7870c1f8ab954
Date: Thu, 15 Aug 2013 09:24:48 +0200
User-Agent: KMail/1.13.7 (Linux/3.11.0-rc5+synaptics-generic; KDE/4.10.5; x86_64; ; )
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ben Skeggs <bskeggs@redhat.com>
References: <1836330.fGgIDqPTNA@pali> <201308141102.47960@pali> <520C37DC.90902@labri.fr>
In-Reply-To: <520C37DC.90902@labri.fr>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2882823.j4W2SQm6b5";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201308150924.49518@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2882823.j4W2SQm6b5
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thursday 15 August 2013 04:07:24 Martin Peres wrote:
> On 14/08/2013 05:02, Pali Roh=C3=A1r wrote:
> > On Tuesday 13 August 2013 15:55:28 Martin Peres wrote:
> >> On 13/08/2013 09:53, Pali Roh=C3=A1r wrote:
> >>> On utorok, 13. augusta 2013 15:32:45 CEST, Martin Peres
> >=20
> > wrote:
> >>>> On 13/08/2013 09:23, Pali Roh=C3=A1r wrote:
> >>>>> On Tuesday 13 August 2013 09:01:19 Martin Peres wrote:
> >>>>   ...
> >>>>=20
> >>>> You can check the temperature by running nvidia-settings.
> >>>> If you can't see the temperature in it, then nvidia
> >>>> doesn't support it on your card and
> >>>> I'm not sure we should :s
> >>>>=20
> >>>> Thanks for the vbios you sent me in private. For the
> >>>> others, the reason why he doesn't have temperature
> >>>> anymore is because his vbios lacks sensor calibration
> >>>> values.
> >>>=20
> >>> In nvidia-settings tab "GPU 0 - (GeForce 6600 GT)" -->
> >>> "Thermal Settings" is:
> >>>=20
> >>> Thermal Sensor Information:
> >>> ID: 0
> >>> Target: GPU
> >>> Provider: GPU Internal
> >>> Temperature: 70 C (now)
> >>>=20
> >>> I looked in Windows program SpeedFan. It found Nvidia PCI
> >>> card and reported "GPU Temp" about 68-70 C. So it looks
> >>> like both nvidia driver and windows SpeedFan program
> >>> reading same values.
> >>=20
> >> Great, I'll cook you a patch in a bit and you'll see what
> >> the temperature is like. It won't be perfectly accurate
> >> but there is some kind of default for nvidia cards of this
> >> generation.
> >=20
> > Ok, send me patch and I can try it if it will work and
> > report similar values as windows or nvidia driver.
>=20
> Sorry for the late answer.
>=20
> Please test this patch. Be aware that temperature with nouveau
> will be higher than with the blob.
> I only want to see if nouveau reports a temperature.
>=20
> The only way to be sure if the values are good-enough would be
> to use the blob and run:
> nvapeek 0x15b0
> Please send me the result along with the temperature reported
> by nvidia at the time of the peek.
>=20
> Martin
>=20
> PS: This patch has only be compile-tested, I don't have access
> to an nv4x right now.

Hello,

now after patch nouveau report temperature:

$ sensors
=2E..
nouveau-pci-0500
Adapter: PCI adapter
temp1:        +63.0=C2=B0C  (high =3D +95.0=C2=B0C, hyst =3D  +3.0=C2=B0C)
                       (crit =3D +145.0=C2=B0C, hyst =3D  +2.0=C2=B0C)
                       (emerg =3D +135.0=C2=B0C, hyst =3D  +5.0=C2=B0C)
=2E..

I found that nvidia binary driver has command line utility=20
nvidia-smi which report same temperature as X utility nvidia-
settings. So I will use nvidia-smi (if it is OK).

And after reboot nvidia report another temperature value:

$ nvidia-smi -q -d TEMPERATURE
=2E..
GPU 0000:05:00.0
    Temperature
        Gpu                     : 70 C

Immediately I called nvapeek command:

$ nvapeek 0x15b0
000015b0: 1000008e

So value reported by nouveau is lower than value reported by=20
nvidia binary driver.

I wait some some and started nvidia-smi and nvapeek again, here=20
are results:

$ nvidia-smi -q -d TEMPERATURE
=2E..
GPU 0000:05:00.0
    Temperature
        Gpu                     : 67 C

$ nvapeek 0x15b0
000015b0: 1000008e

So it looks like that nvapeek returning always same value and=20
does not depends on temperature... It is OK?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2882823.j4W2SQm6b5
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlIMgkEACgkQi/DJPQPkQ1JzoQCfR92fjesV7b6kwNQ+uLffzcn2
EFYAmwWcBXe0MgTsQob8YY0Ja4ri2xgg
=gob+
-----END PGP SIGNATURE-----

--nextPart2882823.j4W2SQm6b5--
