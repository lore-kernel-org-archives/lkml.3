Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbaGCIl5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 04:41:57 -0400
Received: from sauhun.de ([89.238.76.85]:48337 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbaGCIld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 04:41:33 -0400
Date: Thu, 3 Jul 2014 10:41:09 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Rickard Strandqvist'" <rickard_strandqvist@spectrumdigital.se>,
        "'Grant Likely'" <grant.likely@linaro.org>,
        "'Rob Herring'" <robh+dt@kernel.org>,
        "'Leilei Shang'" <shangll@marvell.com>,
        "'Peter Korsgaard'" <peter@korsgaard.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v2] i2c: busses: i2c-pxa.c: Fix for possible null pointer
 dereferenc
Message-ID: <20140703084108.GA3012@katana>
References: <1404084516-901-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <1404084516-901-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <009301cf93f6$f938a270$eba9e750$%han@samsung.com>
 <CAFo99gY2qEEqwJgu-NQryAe2=o5AsDjL+SFaau6BA7CBMH8Xkg@mail.gmail.com>
 <003601cf9660$83368990$89a39cb0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Content-Disposition: inline
In-Reply-To: <003601cf9660$83368990$89a39cb0$%han@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rickard, hi Jingoo,

> I also trust Wolfram. He is one of the most important and active
> person for Linux kernel.

Oh, thanks. I'm flattered :)

> Wolfram may mean devm_ioremap_resource(), not devm_ioremap().

Yes, you are right. Sorry for missing this detail when suggesting an
example to convert to devm_*. devm_ioremap_resource should be favoured
over devm_ioremap.

> 1. devm_ioremap_resource(): IS_ERR() can be used.
>=20
> 	dev->virtbase =3D devm_ioremap_resource(&adev->dev, res));
> 	if (IS_ERR(dev->virtbase)) {

This is correct and preferred.

BTW I don't care much about splitting up the patch as long as the commit
message says that the original bug is a motivation to swicth to devm_*.

Thanks Rickard for picking up the task, and thanks Jingoo for reviewing.

Kind regards,

   Wolfram


--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTtRckAAoJEBQN5MwUoCm2XjkQAK8POEB0KElgjpP8k9x0j09h
69ESNBt+P6f5NFWXfC2Ibw+iOc0/jvlkjGexAqVmCZy4W4O2r98/IVmZFzmJw/kp
KPJz/N086s3VBx3vXJWk48pqwKfpGVdn7VT3+J9y0n/NZKZeqPlO2LK9K/4+WkKv
uMoLggosM0fXOPqZDzYMO1JYBnjx/sdsVfAMQ00AWsUgeptEaNeUUjUWXbvNXtTB
YziIrvJ9EYDNxF9yIC7rpko2zFge3V9vFqpH/6PAH6HLmpq7jftfLRANxpGeKCEo
10J5C/eaKcWP6eICZUNDBCVLrnCsCY3s1vzbyVZGjnLWkE/zqBRFiC5GlOLnAy/2
kjthNo0B0REOpUHqwsV5uTY2+roxyQnViXapV7o6724ceSbxRV88Wp3QAmLjG69b
dqEeFSyTQcRLn1OQ0rxngYH34DPclcU5/q68vKsFPpzel0xjPOqvIUI62CHNdvXA
SOkJ+deIX69TNkxuXAeM/FJjkaQloQfKdNC7e1+LMC6z3JdvQuanp+r5mz9wWdiM
53Pma9Q+8v+nROBIe5FlkILTyKnebTza+FZoXMm/st/2Vb//e2rHP2vIcF1ZWBVa
4A2tEjxbYsrng2vxPpH07DmCLM3/pIGnpq4ITQs5PHzp6uEN4P8cuK/NRC5weR0A
81fTBxpFBRvPfOWJb7hB
=GM6g
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
