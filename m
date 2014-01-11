Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbaAKSza (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 13:55:30 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40981 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606AbaAKSz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 13:55:26 -0500
Message-ID: <52D19393.8090608@pengutronix.de>
Date: Sat, 11 Jan 2014 19:55:15 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>
CC: Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org,
        LKML <linux-kernel@vger.kernel.org>, dmaengine@vger.kernel.org
Subject: Re: blackfin + dmaengine: conflicting define/enum "DMA_COMPLETE"
References: <52D188DA.6020904@pengutronix.de> <52D18DE4.2020008@infradead.org>
In-Reply-To: <52D18DE4.2020008@infradead.org>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="ORebaSGVAh1HEmmmrgn8lXloux04CjSxc"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ORebaSGVAh1HEmmmrgn8lXloux04CjSxc
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 01/11/2014 07:31 PM, Randy Dunlap wrote:
> On 01/11/2014 10:09 AM, Marc Kleine-Budde wrote:
>> Hello,
>>
>> in current linux-next (and net-next) the compilation of the CAN
>> drivers[1] with ARCH=3Dblackfin fails with:
>>
>>>   CC [M]  drivers/net/can/c_can/c_can.o
>>> In file included from linux/include/linux/netdevice.h:38:0,
>>>                  from linux/drivers/net/can/c_can/c_can.c:32:
>>> linux/include/linux/dmaengine.h:55:2: error: expected identifier befo=
re numeric constant
>>> linux/include/linux/dmaengine.h: In function 'dma_async_is_complete':=

>>> linux/include/linux/dmaengine.h:1023:9: error: 'DMA_IN_PROGRESS' unde=
clared (first use in this function)
>>> linux/include/linux/dmaengine.h:1023:9: note: each undeclared identif=
ier is reported only once for each function it appears in
>>
>> There are two locations where DMA_COMPLETE is defined:
>>
>>> arch/blackfin/mach-bf548/include/mach/defBF547.h:602:#define         =
     DMA_COMPLETE  0x8        /* DMA Complete */
>>> arch/blackfin/mach-bf548/include/mach/defBF544.h:622:#define         =
     DMA_COMPLETE  0x8        /* DMA Complete */
>>
>> and
>>
>>> include/linux/dmaengine.h-enum dma_status {
>>> include/linux/dmaengine.h:      DMA_COMPLETE,
>>> include/linux/dmaengine.h-      DMA_IN_PROGRESS,
>>> include/linux/dmaengine.h-      DMA_PAUSED,
>>> include/linux/dmaengine.h-      DMA_ERROR,
>>> include/linux/dmaengine.h-};
>>
>> What's the appropriate fix for the problem?
>=20
> arch/blackfin/mach-bf548/ needs a less generic name for its macro.

Mike, is there a in tree user of blacksfin's DMA_COMPLETE? I cannot find
anyone.

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--ORebaSGVAh1HEmmmrgn8lXloux04CjSxc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlLRk5MACgkQjTAFq1RaXHMgegCeJbEDs03pkvmDvruLskSpQTxA
LdgAnRrbdF5sdd9kh3wZpXZXvyQ+gg6t
=Ru0F
-----END PGP SIGNATURE-----

--ORebaSGVAh1HEmmmrgn8lXloux04CjSxc--
