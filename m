Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab3GHPs1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 11:48:27 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:60916 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab3GHPsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 11:48:25 -0400
Message-ID: <51DADF3E.1000802@monstr.eu>
Date: Mon, 08 Jul 2013 17:48:14 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-spi <linux-spi@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH v1 3/4] spi/xilinx: Simplify irq allocation
References: <ff70173bee5f9223ffea2b92b903b4e46ef8b323.1373290150.git.michal.simek@xilinx.com> <b4458c93742bd9dfe69e3553cf377a703c945f81.1373290150.git.michal.simek@xilinx.com> <20130708144930.GG27646@sirena.org.uk>
In-Reply-To: <20130708144930.GG27646@sirena.org.uk>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2TQIMIDSORAPMILXNPEAQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2TQIMIDSORAPMILXNPEAQ
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 07/08/2013 04:49 PM, Mark Brown wrote:
> On Mon, Jul 08, 2013 at 03:29:16PM +0200, Michal Simek wrote:
>> Use devm_request_irq() for irq allocation which
>> simplify driver code.
>=20
>> @@ -495,7 +493,6 @@ static int xilinx_spi_remove(struct platform_devic=
e *pdev)
>>  	struct xilinx_spi *xspi =3D platform_get_drvdata(pdev);
>>
>>  	spi_bitbang_stop(&xspi->bitbang);
>> -	free_irq(xspi->irq, xspi);
>>
>>  	spi_master_put(xspi->bitbang.master);
>=20
> Is it definitely safe to leave the IRQ hanging around after the master
> has been freed - there's no possibility of a late error interrupt or
> something?

I think it is more generic question if this race condition is fine
for all drivers which are using devres groups.

I have just looked at it and devres_release_all() is called where
driver is unload and irq are disabled there.

It means that all handlers should be unregistered and if IRQ happen
after it then it should be handled by Linux kernel if driver
doesn't disable it.

btw: What's the proper way for spi driver unregistration?

spi_unregistered_master() (which also free private structure)
and
spi_master_put()?

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2TQIMIDSORAPMILXNPEAQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlHa3z4ACgkQykllyylKDCF+pACcCPp6bPsiNWyqP7rrLR81vTzX
+oYAoI9Mk4V8eznOWuktCXR3NC4og/ec
=RMv3
-----END PGP SIGNATURE-----

------enig2TQIMIDSORAPMILXNPEAQ--
