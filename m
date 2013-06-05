Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227Ab3FEOjh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 10:39:37 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:63444 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756020Ab3FEOjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 10:39:35 -0400
Message-ID: <51AF4D9D.6070808@monstr.eu>
Date: Wed, 05 Jun 2013 16:39:25 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Peter Crosthwaite <pcrost@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH 2/3] spi: spi-xilinx: Clear dma_mask for xilinx spi controller
References: <041d7ca272ef9499fab630294e3395110b3e31ac.1370354549.git.michal.simek@xilinx.com> <c5f546072e530c42e7ca15745ffa16729d72a5ac.1370354549.git.michal.simek@xilinx.com> <20130604173632.GM31367@sirena.org.uk>
In-Reply-To: <20130604173632.GM31367@sirena.org.uk>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2FJUXOAVGOWQCQWOJOUDC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2FJUXOAVGOWQCQWOJOUDC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 06/04/2013 07:36 PM, Mark Brown wrote:
> On Tue, Jun 04, 2013 at 04:02:35PM +0200, Michal Simek wrote:
>> From: Michal Simek <monstr@monstr.eu>
>>
>> mmc_spi driver tests if dma is available
>> through spi->master->dev.parent->dma_mask.
>> Microblaze supports DMA but xilinx_spi IP doesn't.
>> That's why clear dma_mask in the driver.
>=20
>> +	/* clear the dma_mask, to try to disable use of dma */
>> +	master->dev.dma_mask =3D 0;
>> +
>=20
> This looks like a bodge in the wrong place.  Either the device
> registration is incorrect in that it advertises DMA when none is
> available or the SPI driver ought to be offering the MMC driver a more
> sensible way of advertising this limitation.  My first thought is the
> former but I didn't check where dma_mask is getting set.

I have looked at history of this change and we have done it 3 years ago
based on one custom configuration.

It is shame that I don't have hw to test this but there was
something wrong in connection to mmc_spi.c.
I will try to find out hw for this to test but probably
won't be available. :-( And I will just revert this change in my tree.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2FJUXOAVGOWQCQWOJOUDC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlGvTaMACgkQykllyylKDCFMoQCggbK+i2sJoQYcGZ6tq5AThklh
dxMAnAq2G6HAjx29MdksrH6Rlrx14uxF
=FsxK
-----END PGP SIGNATURE-----

------enig2FJUXOAVGOWQCQWOJOUDC--
