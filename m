Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbaLVIHn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 03:07:43 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:47914 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbaLVIHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 03:07:41 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 10/10] i8k: Add support for fan labels
Date: Mon, 22 Dec 2014 09:07:36 +0100
User-Agent: KMail/1.13.7 (Linux/3.13.0-44-generic; KDE/4.14.2; x86_64; ; )
Cc: Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
References: <1419191683-31435-1-git-send-email-pali.rohar@gmail.com> <1419191683-31435-11-git-send-email-pali.rohar@gmail.com> <5497515D.9060106@roeck-us.net>
In-Reply-To: <5497515D.9060106@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2787152.WrU1ADtWlV";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412220907.37405@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2787152.WrU1ADtWlV
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Monday 22 December 2014 00:01:49 Guenter Roeck wrote:
> > +static ssize_t i8k_hwmon_show_fan_label(struct device *dev,
> > +					struct device_attribute *devattr,
> > +					char *buf)
> > +{
> > +	static const char * const labels[] =3D {
> > +		"Processor Fan",
> > +		"Motherboard Fan",
> > +		"Video Fan",
> > +		"Power Supply Fan",
> > +		"Chipset Fan",
> > +		"Other Fan",
> > +	};
> > +	int index =3D to_sensor_dev_attr(devattr)->index;
> > +	bool dock =3D false;
> > +	int type;
> > +
> > +	type =3D i8k_get_fan_type(index);
> > +	if (type < 0)
> > +		return type;
> > +
> > +	if (type & 0x10) {
> > +		dock =3D true;
> > +		type &=3D 0x0F;
> > +	}
> > +
>=20
> What if bit 5..7 is set ? This would result in a result of
> "other fan", which given the above does not seem to be
> correct. Given that, I wonder why the type mask is only
> applied if bit 4 is set and not unconditionally.
>=20
> Thanks,
> Guenter
>=20

NBSVC.MDM maps values 0x0-0x5 to exactly to strings in labels[].=20
Next it maps 0x10-0x15 to values same values in strings labels[]=20
but with prefix "Docking". I do not see nothing more in NBSVC.MDM=20
so for other values is "Other Fan" better than nothing.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2787152.WrU1ADtWlV
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSX0UkACgkQi/DJPQPkQ1Lt9QCgsNoLS2a6XzSef1sBQBJgT7d8
DaMAn0CeI73kyDyXYMtObir/QHg/VvAB
=rQPE
-----END PGP SIGNATURE-----

--nextPart2787152.WrU1ADtWlV--
