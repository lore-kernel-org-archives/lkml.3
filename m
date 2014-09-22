Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737AbaIVLFG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 07:05:06 -0400
Received: from sauhun.de ([89.238.76.85]:49075 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753382AbaIVLFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 07:05:03 -0400
Date: Mon, 22 Sep 2014 13:04:55 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Anders Berg <anders.berg@avagotech.com>
Cc: devicetree <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c: axxia: Add I2C driver for AXM55xx
Message-ID: <20140922110455.GA1463@katana>
References: <1408967482-17723-1-git-send-email-anders.berg@avagotech.com>
 <20140920121242.GA3833@katana>
 <CAE0=X_0VQ8rWrUgbsgKm1MwCP8bwWm3UJPq9p=xNDfjP4CC7Bg@mail.gmail.com>
 <20140922095939.GB1406@katana>
 <CAE0=X_1v_1eNr=dPTgofamFuy6zP9ff=LS7dyexj4CeutDqaPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
In-Reply-To: <CAE0=X_1v_1eNr=dPTgofamFuy6zP9ff=LS7dyexj4CeutDqaPA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> >> >> +     if (msg->len =3D=3D 0 || msg->len > 255)
> >> >> +             return -EINVAL;
> >> >
> >> > Ouch, really? Maybe we should warn the user here.
> >>
> >> Yeah, the transfer length register limits the length to 255. I'll add
> >> a warning here.
> >
> > Please also add this information to the Kconfig description and
> > somewhere at the top of the source file. This is an important flaw which
> > people should easily find out about.
> >
>=20
> You are referring to the "len <=3D 255" restriction being the flaw here,
> right? I'll add a note to Kconfig and the driver about that.

Yes, I meant that. I just remembered we should do something else:

Remove I2C_FUNC_I2C (because it cannot do endless transfers) from
functionality and simply use I2C_FUNC_SMBUS_I2C_BLOCK which does I2C
like transfers with the SMBus Limit of 32 bytes. It seems PMBus allows
for 255 byte which this HW could support, yet I don't recall we have
support for that size currently.

> The other part of the condition (msg->len =3D=3D 0) should actually go
> away. The controller can do zero-length-data transfers. I'll fix that
> for next round.

Great!


--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUIAJXAAoJEBQN5MwUoCm2ot4P/idz7ZXL1HjoDH8KMlAruwpZ
2fBWLCGGBhf4hJJsykZcXdkdFWcgolHPfc8XPy9vn+FpseCPwZgkJl8h228lZi16
hRyNEF6wP1KsWbGMbRXkb6oqpx/mcNSp/C8JkbNtQ9PkFGJxuET3OIjxLb6KyYvD
+vpLBa33D+fiP2UCF6Far2yu2LMYQsn9Cd5ClJYrCqv3xXfrHuTSwrtW4Dm1WnCz
ObYYCO2T37sYPI/iSgmST1sukkwdgHBAUgwOD0s8F3U9A72TbnrQ1vBycRa43dIJ
W7j+IwzzZZ+kFdpusrXaiJTyYzQKINAjOswv3neZyLkc6da/Nwl9oCQ1KZYMp6J1
RRpAkQaOMZ0INHCpA4+Mn2ruaxpry5YLsQC0yk5t/p1W4yIqgZl3bBRtK9rh1eym
wtr4nNivyPXgB0rO8qMRlmOXTaRHA8txyDcxT6CdUE+uUIgpabyrUCENSM3PW50b
H/LxPbDY1bzs4WQoQGtdAoEzBvImIEANc4mdYT9tLD/mrZNunS4nwZ0gjcc1ka0D
FP6cTYMNQgOjvh6IRNdWdWkofFsQOYYu4d0UNnXeTVQPCtdwoyZ9ySwk3VXBk35f
OzwkSzvumUDNEx3u5YeezzDeVy8jUPpl2hQQhjZlojBFvhukTMtfPoV7e2Vja50d
QKSGgarrn94AaCQxB0dj
=/9Zg
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--
