Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430AbaK3Jxq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 04:53:46 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:46683 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbaK3Jxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 04:53:44 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] i8k: Add support for temperature sensor labels
Date: Sun, 30 Nov 2014 10:53:39 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.1; x86_64; ; )
Cc: Gabriele Mazzotta <gabriele.mzt@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        linux-kernel@vger.kernel.org
References: <1417277047-15489-1-git-send-email-pali.rohar@gmail.com> <201411292007.36975@pali> <547A5FB3.6030502@roeck-us.net>
In-Reply-To: <547A5FB3.6030502@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1871801.fQ86EstXp2";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411301053.40222@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1871801.fQ86EstXp2
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 30 November 2014 01:07:15 Guenter Roeck wrote:
> On 11/29/2014 11:07 AM, Pali Roh=C3=A1r wrote:
> > On Saturday 29 November 2014 19:58:28 Guenter Roeck wrote:
> >> On 11/29/2014 10:27 AM, Gabriele Mazzotta wrote:
> >>> On Saturday 29 November 2014 18:18:18 Pali Roh=C3=A1r wrote:
> >>>> On Saturday 29 November 2014 18:07:19 Gabriele Mazzotta
> >=20
> > wrote:
> >>>>> On Saturday 29 November 2014 17:09:35 Pali Roh=C3=A1r wrote:
> >>>>>> On Saturday 29 November 2014 17:04:07 Pali Roh=C3=A1r wrote:
> >>>>>>> This patch adds labels for temperature sensors if SMM
> >>>>>>> function with EAX register 0x11a3 reports it. These
> >>>>>>> informations was taken from DOS binary NBSVC.MDM.
> >>>>>>>=20
> >>>>>>> Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> >>>>>>> ---
> >>>>>>>=20
> >>>>>>>    drivers/char/i8k.c |  110
> >>>>>>>=20
> >>>>>>> +++++++++++++++++++++++++++++++++++++++++----------- 1
> >>>>>>> file changed, 88 insertions(+), 22 deletions(-)
> >>>>>>=20
> >>>>>> I tested patch on Latitude E6440 and i8k CPU & GPU
> >>>>>> temps match intel coretemp & amd radeion temps.
> >>>>>>=20
> >>>>>> But I would like if somebody with other Dell laptop can
> >>>>>> test if temperature labels are correct...
> >>>>>=20
> >>>>> I tested it on my XPS13 9333, here what sensors outputs:
> >>>>>=20
> >>>>> acpitz-virtual-0
> >>>>> Adapter: Virtual device
> >>>>> temp1:        +27.8=C2=B0C  (crit =3D +105.0=C2=B0C)
> >>>>> temp2:        +29.8=C2=B0C  (crit =3D +105.0=C2=B0C)
> >>>>>=20
> >>>>> coretemp-isa-0000
> >>>>> Adapter: ISA adapter
> >>>>> Physical id 0:  +62.0=C2=B0C  (high =3D +100.0=C2=B0C, crit =3D
> >>>>> +100.0=C2=B0C) Core 0:         +62.0=C2=B0C  (high =3D +100.0=C2=B0=
C,
> >>>>> crit =3D +100.0=C2=B0C) Core 1:         +61.0=C2=B0C  (high =3D
> >>>>> +100.0=C2=B0C, crit =3D +100.0=C2=B0C)
> >>>>>=20
> >>>>> i8k-virtual-0
> >>>>> Adapter: Virtual device
> >>>>> fan2:           0 RPM
> >>>>> CPU:          +62.0=C2=B0C
> >>>>> Ambient:      +49.0=C2=B0C
> >>>>> SODIMM:       +46.0=C2=B0C
> >>>>> temp4:            N/A
> >>>>>=20
> >>>>> CPU seems to be correct, but I can't say anything on
> >>>>> Ambient and SODIMM. temp4 is constantly equal to SODIMM
> >>>>> without this patch, so I'd say N/A is correct.
> >>>>>=20
> >>>>>=20
> >>>>> Gabriele
> >>>>=20
> >>>> It is unknown for me how to directly read Ambient and
> >>>> SODIMM temperatures (without Dell SMM functions). So we
> >>>> can only trust Dell SMM that it reporting correct values
> >>>> and type is really Ambient and SODIMM.
> >>>>=20
> >>>> And about temp4:
> >>>>=20
> >>>> Label is not set when SMM function fails. Original DOS
> >>>> NBSVC.MDM just ignore all sensors for which SMM type
> >>>> function fails.
> >>>>=20
> >>>> This patch should not disable any sensor, so if you
> >>>> previously had some value (<=3D 128=C2=B0C) and now not, then
> >>>> there is some bug.
> >>>>=20
> >>>> Can you test this patch?
> >>>> https://git.kernel.org/cgit/linux/kernel/git/gregkh/char-> >>>> mi s=
c.git/comm
> >>>> it/?h=3Dchar-misc-testing&id=3D723493ca59c8d81fed3e7f261165fe
> >>>> e 493a29ffa
> >>>>=20
> >>>> It is possible that same value is caused by incorrect use
> >>>> of prev[] array which should be fixed by above patch.
> >>>>=20
> >>>> Can you test i8k with and without above patch?
> >>>=20
> >>> I did some more tests. What I think is happening is that
> >>> temp4_label returns -22, so I sensors prints N/A without
> >>> actually reading temp4_input.
> >>>=20
> >>> I'm doing some tests to understand what's going on with
> >>> temp4_input. It reports the value of the last temp*_input
> >>> I read. If I read it right after I loaded i8k, I get an
> >>> error (-22).
> >>>=20
> >>> The same doesn't happen for temp3_label, which constantly
> >>> returns -22.
> >>>=20
> >>> I already had
> >>> https://git.kernel.org/cgit/linux/kernel/git/gregkh/char-m
> >>> i
> >>> sc.git/commit/?h=3Dchar-misc-testing&id=3D723493ca59c8d81fed3
> >>> e7f 261165fee493a29ffa applied. Without it, things seem
> >>> not to change much. I either get an error (-22) or some
> >>> incorrect values (for now always 1000) when I read
> >>> temp4_input right after i8k was loaded. Once I read some
> >>> other temp*_input, I always get the last value read.
> >>=20
> >> I am seeing exactly the same behavior on an XPS13.
> >>=20
> >> Guenter
> >=20
> > Original Dell DOS executable ignores all temperature sensors
> > if type SMM function fails (if I decoded and understand
> > that DOS assembler code correctly). So maybe we should do
> > same...
> >=20
> > But because our i8k.c code ignores sensor only if it returns
> > invalid temperature, there could be possible regression that
> > on same machines type SMM function is not implemented or
> > not working...
> >=20
> > What do you think?
>=20
> Tested with XPS13, Studio 1555 (with GPU), and XPS M140.
> Reading the type works with all of them. The Studio 1555
> reports the GPU temperature in temp4. The M140 is quite old
> (about 10 years), so I guess we can be reasonably sure that
> all laptops currently in use support reporting the type.
>=20

Good. Then I will split this patch into two parts. One which adds=20
labels and one which change init code to register only those=20
sensors which have valid type.

> Do you know what is returned for the type if the GPU is turned
> off on a system with GPU ? I think that is the only open
> question.
>=20

Yes, on my E6440 in both cases when GPU is turned off and on is=20
returned same type (GPU). So this does not help us.

> Thanks,
> Guenter

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1871801.fQ86EstXp2
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlR66SQACgkQi/DJPQPkQ1JzLACfftB1hmaBQK+zlVA59uNQRupU
AZIAoIfOUssDMoBCEb0XRWPv/ospxPDD
=I+Ju
-----END PGP SIGNATURE-----

--nextPart1871801.fQ86EstXp2--
