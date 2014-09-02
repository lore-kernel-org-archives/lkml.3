Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbaIBKjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 06:39:55 -0400
Received: from sauhun.de ([89.238.76.85]:53671 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272AbaIBKjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 06:39:54 -0400
Date: Tue, 2 Sep 2014 12:39:59 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        linux-sunxi@googlegroups.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] i2c: mv64xxx: continue probe when clock-frequency is
 missing
Message-ID: <20140902103959.GC1266@katana>
References: <1409581693-15943-1-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DIOMP1UsTsWJauNi"
Content-Disposition: inline
In-Reply-To: <1409581693-15943-1-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DIOMP1UsTsWJauNi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 01, 2014 at 10:28:13PM +0800, Chen-Yu Tsai wrote:
> The "clock-frequency" DT property is listed as optional, However,
> the current code stores the return value of of_property_read_u32 in
> the return code of mv64xxx_of_config, but then forgets to clear it
> after setting the default value of "clock-frequency". It is then
> passed out to the main probe function, resulting in a probe failure
> when "clock-frequency" is missing.
>=20
> This patch checks and then throws away the return value of
> of_property_read_u32, instead of storing it and having to clear it
> afterwards.
>=20
> This issue was discovered after the property was removed from all
> sunxi DTs.

Hmm, I don't like that removal. Probably I should take care that this
property is not "optional" but "recommended". The default value is
depending on the driver, mostly because of historic reasons. It is
definately better to explicitly state it. Despite all that...

>=20
> Fixes: 4c730a06c19bb ("i2c: mv64xxx: Set bus frequency to 100kHz if clock=
-frequency is not provided")
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> Cc: stable@vger.kernel.org
> Acked-by: Andrew Lunn <andrew@lunn.ch>
> Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Applied to for-current, thanks!


--DIOMP1UsTsWJauNi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUBZ5/AAoJEBQN5MwUoCm20C8P/jMBBZ/8ko6qmQ8OsKJfaY2C
5zl+S9dKllOcee6xITNDdwZPEhm7whGnJbxgw822CokOpaxtZtRsQlF6d3FLZqiK
Unrzc7kGGKSBkUNGtTOuwix2YfbJ3EtBkVxPwPX3VpWtQDxY6FrvQbRSIJn84Wqz
o8byrnuFhxVHYg6f4AjFpv0hM0APjSrLcy4NV8qN18qSap2WEzZmxk/wOcaf0VLb
h/KkLErzwU9edBVJ4G09PTrElwwGDZ+QbVUNIY6oVw+5dCWbuIFSrYZMjzW21Zq5
+mzQiQXnrIbXsr+d2GtuianbZ6KDXDvFN4FbL7uG+LHlqlWDZZDNNAPUe3K4bQkh
+fKIpXpNX/XRUEmXPVXeOKdhtExE8ZYiPSAVQJ4dpAodbpo5MhOVkYH1e0QQpmmV
UtB5YYJlsiFzfDncwv897+sM4mTAnYYYE27/SPGjvM7nzc1POdNe/pXUxW5NphJ8
+8jl5kIjiiN4BeuDvWWWdcZi03BUF/RsUsQ7b0Zfn3rVxyhGxV9Tq6McojkORHDd
EGbfFEfB7FiGxoBqmjdJih0D2upDS/EpwOhLP87u35llFhXpjd9FwGpsSSydZKVO
+tcLkYgmeJXKAYI5QkugDghgiPNATG3P84zP3hYObg1YuxfGWHnACbqXdCyCBFqK
nbeMjtuBNtYX8obzymRb
=Aw/R
-----END PGP SIGNATURE-----

--DIOMP1UsTsWJauNi--
