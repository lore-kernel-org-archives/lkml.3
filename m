Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933002AbaLDSeN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 13:34:13 -0500
Received: from sauhun.de ([89.238.76.85]:34386 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932455AbaLDSeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 13:34:11 -0500
Date: Thu, 4 Dec 2014 19:34:07 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Harini Katakam <harinik@xilinx.com>
Cc: mark.rutland@arm.com, michal.simek@xilinx.com, soren.brinkmann@xilinx.com,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, vishnum@xilinx.com,
        harinikatakamlinux@gmail.com
Subject: Re: [PATCH v2 3/3] i2c: cadence: Check for errata condition
 involving master receive
Message-ID: <20141204183406.GK7944@katana>
References: <1417610126-7957-1-git-send-email-harinik@xilinx.com>
 <1417610126-7957-4-git-send-email-harinik@xilinx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lildS9pRFgpM/xzO"
Content-Disposition: inline
In-Reply-To: <1417610126-7957-4-git-send-email-harinik@xilinx.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lildS9pRFgpM/xzO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> +		/*
> +		 * This controller does not give completion interrupt after a
> +		 * master receive transfer if HOLD bit is set (repeated start),
> +		 * resulting in SW timeout. Hence, if a receive transfer is
> +		 * followed by any other transfer, an error is returned
> +		 * indicating that this sequence is not supported.
> +		 */
> +		for (count = 0; count < num-1; count++) {
> +			if (msgs[count].flags & I2C_M_RD)
> +				return -EOPNOTSUPP;
> +		}

Yeah, a lot better. Probably it would be good to inform the user with a
warning what went wrong?


--lildS9pRFgpM/xzO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUgKkeAAoJEBQN5MwUoCm2CCoP/jd2i91LvyW0uRWrzwl++RrB
CXmWjLHT9r1+L6J3n6h09LJvx7/sRvQkHMW2QzVOIoq8PfdGkoLUL887UV7k3iMq
QljF7yr8eO3XezO1DHCnCtaMtH7nxDS3PWX8r0pmjgPNSNNUVWAySRF2aQjnymPA
MHonRUARDfQOvaqq63fYjM+IhIIy9FY+PxMoejPeO46eQ+aoD0ecba/TaLIxdLid
ZBZBfnQFHi0nnezOm3LX9H13C0mBPMLqJKxGk2LJTA7Tur03qCvRuzl0xhP0zwkc
bJ1AjJ3SlROWGe8ze9lAgkIgskpXwLIgG3DbdrFUFa5RYYCfhfWoupUchmORs6oN
MLuw+erJEEFN446I7Vyo7ldgrjS6IZXG7E7ouPqWXyc/E6qF8nVRCMfUlT6RNLZk
KwTo1auPg/flxwUyavik4NnaIRgVxbGo/eD8pgtQEchreJEn1eaKbNY63ja0LAsH
sd99x6Zx55biByp3DTk1em0TZWyZ+tJP0I9bRbqQq5kaRdy6fqX+HOJ/DKqGOesK
rO4KDoCnGoUjJEKtqYdDdpeuwOed3XRQklAJCcbATcjeFzC6KKw8H2rglW4eUsQm
AkMoYNqWnrlHlgzsGXO56ZVUKXhCvExZJ8TGYJVW100o4cEvGZtaddY8oJ+WHGJ5
+MyQkkSj5tq+tjPXdu/q
=Xd07
-----END PGP SIGNATURE-----

--lildS9pRFgpM/xzO--
