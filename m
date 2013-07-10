Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab3GJStN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 14:49:13 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60470 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295Ab3GJStL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:49:11 -0400
Date: Wed, 10 Jul 2013 11:49:03 -0700
From: Thierry Reding <thierry.reding@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Wei Ni <wni@nvidia.com>, khali@linux-fr.org, swarren@wwwdotorg.org,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v2 2/3] hwmon: (lm90) add support to handle IRQ.
Message-ID: <20130710184902.GD15665@dhcp-172-17-186-34.nvidia.com>
References: <1373455539-2831-1-git-send-email-wni@nvidia.com>
 <1373455539-2831-3-git-send-email-wni@nvidia.com>
 <20130710170552.GA15665@dhcp-172-17-186-34.nvidia.com>
 <20130710181248.GA22430@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2iBwrppp/7QCDedR"
Content-Disposition: inline
In-Reply-To: <20130710181248.GA22430@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2iBwrppp/7QCDedR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 10, 2013 at 11:12:49AM -0700, Guenter Roeck wrote:
> On Wed, Jul 10, 2013 at 10:05:53AM -0700, Thierry Reding wrote:
> > On Wed, Jul 10, 2013 at 07:25:38PM +0800, Wei Ni wrote:
[...]
> > > +	if ((alarms & 0x7f) =3D=3D 0 && (alarms_max6696 & 0xfe) =3D=3D 0) {
> > > +		return IRQ_NONE;
> >=20
> > For non-MAX6696 chips this will evaluate to:
> >=20
> > 	if ((alarms & 0x7f) =3D=3D 0 && (0 & 0xfe) =3D=3D 0)
> >=20
> > and therefore be true for any value of "alarms" and therefore always
> > result in IRQ_NONE being returned.
> >=20
> Not really. If
> 	(alarms & 0xfe) =3D=3D 0
> returns false (ie thee is an alarm) the expression is false and the
> if statement won't be executed. Or maybe I didn't get enough sleep
> last night ;).

You're right. Looks like I am the one that didn't get enough sleep last
night. =3D) So the original code indeed seems to be doing what it should.

Thierry

--2iBwrppp/7QCDedR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJR3ayeAAoJEN0jrNd/PrOhwvwP/1ngSqqxwn8VTdkYb6ICHM77
5Br7uMckgGTGmvXNLfWPCSbxQDioTS11pSukme0Oxzg441BdHhb106J0JUFhxBu3
DL9I3RJSUu0Tf7dheqe/m1J9bMAtkW14QKk/KoeqGrzGQjUCiUu2pJzSk+nK3F+U
BCny1+6DaMIrpto4tHRU6xdsb7nQkjfJpbZZdFn9EV2SoqJcDeF7WfjUC1g34BCg
09EAVi2uniBW7Yoow3urztNMGlEOAMjcAAWQGoV5QFAx5MQBe8zkhGyxdQzQy4ML
yuFnHEFCPOOY7+9gqWR6joobwaFLRYgynkrgIWS4GGflytWDgEJrkc6xD7nP+R+g
IDRFVFB7jaUjeFgKQ2gjg3DJIKqE1JjKg+MiWCE76YWtJ28IDf1jn9hqxPZRGOxv
pQhpGihwk8WMZfU5ofD53pJlkNkaLm7M8hEP2WLVVdFPEcPo+NSMn4fjDZAb7JAg
5BOu0joawiC+WzHthV4U48KayoLKM9yJx2JRjtQ1WN8G9CIL8tvwHN+mcu0MkIn3
fkqXVSYsAJbb27nxK36R1d/vAjAb7wK+HLTcBQD3wtv/Mt5ImQ6XJAieBGrAjKM4
3p6RE2UrHHgZrLDJvXi+OnsBU3pGb9ueoPkVd1AW1BpUXJELfQJnL1IGDRqQUfgr
Ibccp+SFk5xpoOP027Si
=QqwN
-----END PGP SIGNATURE-----

--2iBwrppp/7QCDedR--
