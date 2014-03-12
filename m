Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbaCLLvf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 07:51:35 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:61385 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbaCLLve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 07:51:34 -0400
Message-ID: <53204A40.4090805@monstr.eu>
Date: Wed, 12 Mar 2014 12:51:28 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Michal Simek <michal.simek@xilinx.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Josh Cartwright <josh.cartwright@ni.com>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/7] ARM: zynq: Hang iomapped slcr address on device_node
References: <cover.1389018985.git.michal.simek@xilinx.com> <ae4583176ee5c9d8a8a2d53c000b86711eb66287.1389018985.git.michal.simek@xilinx.com> <CAOesGMjzNWXs26T2ZxGi=ASk2ETk0P5re-QdfwGT6O8M=5tDkA@mail.gmail.com>
In-Reply-To: <CAOesGMjzNWXs26T2ZxGi=ASk2ETk0P5re-QdfwGT6O8M=5tDkA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="ja8r37XIo8KxRTjDfudA3iRpo4a0Iuw1J"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ja8r37XIo8KxRTjDfudA3iRpo4a0Iuw1J
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 03/11/2014 10:26 PM, Olof Johansson wrote:
> On Mon, Jan 6, 2014 at 6:36 AM, Michal Simek <michal.simek@xilinx.com> =
wrote:
>> From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
>>
>> For later usage by zynq clk driver.
>>
>> Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
>> ---
>>  arch/arm/mach-zynq/slcr.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/arch/arm/mach-zynq/slcr.c b/arch/arm/mach-zynq/slcr.c
>> index 9746de7..2891dcf 100644
>> --- a/arch/arm/mach-zynq/slcr.c
>> +++ b/arch/arm/mach-zynq/slcr.c
>> @@ -121,6 +121,8 @@ int __init zynq_early_slcr_init(void)
>>                 BUG();
>>         }
>>
>> +       np->data =3D (__force void *)zynq_slcr_base;
>=20
>=20
> This is quite unusual, we normally remap again if needed. Is there a
> reason you can't just have the driver request the resource and map it
> like most other ones do?

I took this patch from Steffen because remapping slcr again in clock
driver is another mapping for the same IP. Use one ioremap region
seems to me better if there is a way. Of course if this is strictly
prohibited we can do another mapping in clock driver.

Here is the RFC I have sent after my discussion with Arnd
that we should use early syscon initialization and regmap.
This is just RFC to show slcr cleaning up.
http://permalink.gmane.org/gmane.linux.kernel/1651213
(Here is broken CLK part because clk subsystem uses clk_readl/clk_writel
- changing this is discussed in other threads)

=46rom v1 - regmap device separation was applied by Mark
git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/nod=
ev

=46rom v2 - "mfd: syscon: Support early initialization"
I expected to get any comment from Arnd but I will respin this
based on Lee's comments

To summarize this for future I would like to use access with regmap
with one ioremap.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--ja8r37XIo8KxRTjDfudA3iRpo4a0Iuw1J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlMgSkAACgkQykllyylKDCF8KwCeIj8OIGmqnQh9cqOYxOvPTLHH
ej4AoIpsk5kRmIrtRxbcUsJiSpe26Eu2
=GrAW
-----END PGP SIGNATURE-----

--ja8r37XIo8KxRTjDfudA3iRpo4a0Iuw1J--
