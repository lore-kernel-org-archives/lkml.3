Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072AbaLURZU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 12:25:20 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:46889 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbaLURZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 12:25:17 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Steven Honeyman <stevenhoneyman@gmail.com>
Subject: Re: [PATCH v3] i8k: Autodetect maximal fan speed and fan RPM multiplier
Date: Sun, 21 Dec 2014 18:25:13 +0100
User-Agent: KMail/1.13.7 (Linux/3.13.0-44-generic; KDE/4.14.2; x86_64; ; )
Cc: Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Jean Delvare <jdelvare@suse.de>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>
References: <1419012268-20805-1-git-send-email-pali.rohar@gmail.com> <201412211737.18917@pali> <CABz95_BYOzTxxhfZcUpkdvNriviNNjCgf_owB1yuRd7dS8h8jw@mail.gmail.com>
In-Reply-To: <CABz95_BYOzTxxhfZcUpkdvNriviNNjCgf_owB1yuRd7dS8h8jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1519148.tHIGXQoVzK";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412211825.13943@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1519148.tHIGXQoVzK
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 21 December 2014 17:55:51 Steven Honeyman wrote:
> On 21 December 2014 at 16:37, Pali Roh=C3=A1r <pali.rohar@gmail.com>=20
wrote:
> > On Sunday 21 December 2014 13:23:32 Guenter Roeck wrote:
> >> On 12/21/2014 04:09 AM, Pali Roh=C3=A1r wrote:
> >> > On Sunday 21 December 2014 12:57:08 Guenter Roeck wrote:
> >> >>> -#define I8K_FAN_MULT             30
> >> >>> +#define I8K_FAN_MAX_RPM          30000
> >> >>>=20
> >> >>>    #define I8K_MAX_TEMP           127
> >> >>>   =20
> >> >>>    #define I8K_FN_NONE            0x00
> >> >>>=20
> >> >>> @@ -64,7 +66,7 @@ static DEFINE_MUTEX(i8k_mutex);
> >> >>>=20
> >> >>>    static char bios_version[4];
> >> >>>    static struct device *i8k_hwmon_dev;
> >> >>>    static u32 i8k_hwmon_flags;
> >> >>>=20
> >> >>> -static int i8k_fan_mult;
> >> >>> +static int i8k_fan_mult =3D 30;
> >> >>=20
> >> >> Why did you drop I8K_FAN_MULT ?
> >> >=20
> >> > Because I think it is not needed anymore... It is used
> >> > only in one place (there ^). But if you want I can
> >> > revert it back.
> >>=20
> >> That is not a reason to drop a define.
> >>=20
> >> >>>    static int __init i8k_probe(void)
> >> >>>    {
> >> >>>=20
> >> >>> + const struct i8k_config_data *conf;
> >> >>=20
> >> >> Why did you move this variable declaration ?
> >> >=20
> >> > Comes from previous version of patches where I moved all
> >> > variables to start of function. I will revert this
> >> > change.
> >> >=20
> >> >>> -         const struct i8k_config_data *conf =3D
> >> >>> id->driver_data; +         conf =3D id->driver_data;
> >> >>> +         if (fan_mult <=3D 0 && conf->fan_mult > 0)
> >> >>=20
> >> >> I still don't see the value in accepting fan_mult < 0
> >> >> (compeared to =3D=3D 0).
> >> >=20
> >> > Ok. What kernel driver should do if user load it with
> >> > negative parameter? We should not propagate negative
> >> > value to functions.
> >>=20
> >> You have multiple options: Ignore it (bad idea ;-), abort
> >> loading the module with -EINVAL, or make the module
> >> parameter an unsigned.
> >=20
> > And how to make module parameter as unsigned? It is
> > possible?
> >=20
> > Code
> >=20
> > module_param(fan_mult, unsigned int, 0);
> >=20
> > cause compile error:
> >=20
> > i8k.c:99:1: error: expected =E2=80=98=3D=E2=80=99, =E2=80=98,=E2=80=99,=
 =E2=80=98;=E2=80=99, =E2=80=98asm=E2=80=99 or
> > =E2=80=98__attribute__=E2=80=99 before =E2=80=98int=E2=80=99 i8k.c:99:1=
: error:
> > =E2=80=98param_ops_unsigned=E2=80=99 undeclared here (not in a function)
>=20
> module_param(fan_mult, uint, 0);
>=20
>=20
> Steven.

Thanks! I sent new patch which change module param to uint and=20
after then I sent new version v4 of autodetect patch.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1519148.tHIGXQoVzK
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSXAnkACgkQi/DJPQPkQ1LNOgCgxzNjE2xV0wiEE/wNX+15t2x8
DE8AoLEk+zYCEQAk4dKDEzhQzGxyd2VG
=HqVy
-----END PGP SIGNATURE-----

--nextPart1519148.tHIGXQoVzK--
