Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab3KZDxH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 22:53:07 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:32938 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751205Ab3KZDxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 22:53:02 -0500
Message-ID: <1385437975.23855.35.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.2 63/87] ext4: fix memory leak in xattr
From: Ben Hutchings <ben@decadent.org.uk>
To: Dave Jones <davej@redhat.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, Eric Sandeen <sandeen@redhat.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Dave Jones <davej@fedoraproject.org>
Date: Tue, 26 Nov 2013 03:52:55 +0000
In-Reply-To: <20131125190251.GA5047@redhat.com>
References: <lsq.1385387069.559528559@decadent.org.uk>
	 <lsq.1385387069.431840285@decadent.org.uk>
	 <20131125190251.GA5047@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-M645ejQKipEkN3kUHhsj"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-M645ejQKipEkN3kUHhsj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-11-25 at 14:02 -0500, Dave Jones wrote:
> On Mon, Nov 25, 2013 at 01:44:29PM +0000, Ben Hutchings wrote:
>  > 3.2.53-rc1 review patch.  If anyone has any objections, please let me =
know.
>  >=20
>  > --- a/fs/ext4/xattr.c
>  > +++ b/fs/ext4/xattr.c
>  > @@ -1269,6 +1269,8 @@ retry:
>  >  				    s_min_extra_isize) {
>  >  					tried_min_extra_isize++;
>  >  					new_extra_isize =3D s_min_extra_isize;
>  > +					kfree(is); is =3D NULL;
>  > +					kfree(bs); bs =3D NULL;
>  >  					goto retry;
>  >  				}
>  >  				error =3D -1;
>=20
> There was a follow-on patch that frees the bh too.

I've only worked through cc'd changes up to 3.12 and that one is later,
so unless you think that's urgent I'll leave it to the next update.

Ben.

--=20
Ben Hutchings
Usenet is essentially a HUGE group of people passing notes in class.
                      - Rachel Kadel, `A Quick Guide to Newsgroup Etiquette=
'

--=-M645ejQKipEkN3kUHhsj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUpQbF+e/yOyVhhEJAQoiSQ/+NMMpsR2dpkCPSxIz6sClWMxaWiWJSFpE
PzEl5l7k1Lh+24fmrni2Vz9Hj4ED3ooZSQogFEkpTRR1rH8Uxbr1+L1pqMfNG0vR
c3YgjYlNjfaklfqZozBQJvC0Xuoxt+lofriiUZWxv0MI/AjsMNkhYVKG5yTtVZxj
s2fESJJoxyMjD/4K9NvjECCra00Of9ewoAq0dhsyWh6M60ZsnMzhbR6s0r62LVir
1IpkJSS0zuzeYY8aa+3T3JHxLXa6OaWE3n2+QUjHGd1mJxt+YqZwbS+kE8QeO2FK
qQTj7dvXSxYpJU0aDO1ynV+7MfPrWBzU6FqUwv+XMHkYvVbveV+eVcJuuntUyCMi
Qm1pJStlWGNe/CDIXb/L6QH5cGIR0J36CRV6ciHcgshdZ8AW4+SHTz4he25u+mHn
rh3N1cUrJ5Lc6Psdx7AtmBP5VcrT2OgoahIlXrx9eOqL+uuAT+bZg6Z61kwfCIYN
yxKq5uyggkIzOLqWiGAMKShpWjASxiwE9NyhbYE5rLIWZUh9NNMebrsIuQDh5MLf
nSMb3KLwAvhlNrUeiG4q16iWm7jII70s8hyxvvenaXn0o+K3A2U34EWPuJOCbmr8
+DAX0ZkRgLkcHKwlMS9N6uvGh/qURNooSz5UBLIYnXVUbvJh70r+/1gIFuftyrso
ePWN7s76IN4=
=O7ld
-----END PGP SIGNATURE-----

--=-M645ejQKipEkN3kUHhsj--
