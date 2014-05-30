Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388AbaE3Mhd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 08:37:33 -0400
Received: from sauhun.de ([89.238.76.85]:45966 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093AbaE3Mh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 08:37:29 -0400
Date: Fri, 30 May 2014 14:36:57 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        grant.likely@linaro.org, linus.walleij@linaro.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c: Make I2C ID tables non-mandatory for DT'ed and/or
 ACPI'ed devices
Message-ID: <20140530123656.GC2742@katana>
References: <1401452797-29521-1-git-send-email-lee.jones@linaro.org>
 <1401452797-29521-2-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NKoe5XOeduwbEQHU"
Content-Disposition: inline
In-Reply-To: <1401452797-29521-2-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NKoe5XOeduwbEQHU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 30, 2014 at 01:26:36PM +0100, Lee Jones wrote:
> Currently the I2C framework insists on devices supplying an I2C ID
> table.  Many of the devices which do so unnecessarily adding quite a
> few wasted lines to kernel code.  This patch allows drivers a means
> to 'not' supply the aforementioned table and match on either DT
> and/or ACPI match tables instead.
>=20
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Sadly, it is not that easy...

> +	/*
> +	 * An I2C ID table is not madatory, if and only if, a suitable Device
> +	 * Tree and/or ACPI match table entry is supplied for the probing
> +	 * device.
> +	 */

That means we end up with drivers which cannot be used for run-time
instantiation via the 'new_device'-file in sysfs. I don't like that.


--NKoe5XOeduwbEQHU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTiHtoAAoJEBQN5MwUoCm2J8IP/jDGkOmDS184FFWYotjvOxE4
pE1ScJJHRtNbzP0+KCzZIf4GHkyQ2qvzpS4qdfpT3O85CWuYHbfTpNzFoEP4UIsI
9t8UHakeT/u7v/TvLtIBaGDXhm2D11waEE/Q25YZCbtJdoPOfHrMpYQnkq20H807
mImBaCBylEoQLIkpLUWR0rtNHp70SuQM4BfJS/ozpUb6SSsiSDKo/ZkOYQNVoMAo
K0nx3/tJcjvWaKmu5KH0dZlTAgYyzNEq0E8UJDfHU40f73SsolE7XvVqod7K2yFk
aULjsjix+f6iBRF4FEqozpHFQdfUFE+cZxptBmnvBeFbvfLlp2TGSxJ/9SrBLiPw
E+h91AHlqN4Co1hcC+xVbztlZGOuYCHCN9+1TQCcgV8YczQXcQSGIIS0fDMPseRp
zCJLAIV4BJ3db8I3u2GArnihtvNtRGHkpq1Kvgn+EygLWoX3Ucl9SYI1UiNfGArw
GxejQZGA6/BpMADTnXYGip0rei+rTb2kiljIJAjSpztW1lr5D4kH973xYrZN4Lmt
kq4N139GybFrgBPp8YHzMLBkJllilnXekjU8y0QuJIlEx7eezTDBMyHF7L/RwTvX
cd+L13as6JEqsjun9NO/kKC3MTc195xIDQ0UMLQA87pJ7MZBxXofX1NtVYng3gTM
nQ3p8V2VARCOUNaxi2so
=H4/b
-----END PGP SIGNATURE-----

--NKoe5XOeduwbEQHU--
