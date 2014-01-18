Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbaARHCD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 02:02:03 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:50825 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbaARHCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 02:02:00 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: "Marc Kleine-Budde" <mkl@pengutronix.de>
Subject: Re: blackfin + dmaengine: conflicting define/enum "DMA_COMPLETE"
Date: Sat, 18 Jan 2014 02:02:04 -0500
User-Agent: KMail/1.13.7 (Linux/3.12.1; KDE/4.6.5; x86_64; ; )
Cc: Randy Dunlap <rdunlap@infradead.org>,
        uclinux-dist-devel@blackfin.uclinux.org,
        LKML <linux-kernel@vger.kernel.org>, dmaengine@vger.kernel.org
References: <52D188DA.6020904@pengutronix.de> <52D18DE4.2020008@infradead.org> <52D19393.8090608@pengutronix.de>
In-Reply-To: <52D19393.8090608@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1446358.bA7LiXDtym";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201401180202.06161.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1446358.bA7LiXDtym
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Saturday 11 January 2014 13:55:15 Marc Kleine-Budde wrote:
> On 01/11/2014 07:31 PM, Randy Dunlap wrote:
> > On 01/11/2014 10:09 AM, Marc Kleine-Budde wrote:
> >> Hello,
> >>=20
> >> in current linux-next (and net-next) the compilation of the CAN
> >>=20
> >> drivers[1] with ARCH=3Dblackfin fails with:
> >>>   CC [M]  drivers/net/can/c_can/c_can.o
> >>>=20
> >>> In file included from linux/include/linux/netdevice.h:38:0,
> >>>=20
> >>>                  from linux/drivers/net/can/c_can/c_can.c:32:
> >>> linux/include/linux/dmaengine.h:55:2: error: expected identifier befo=
re
> >>> numeric constant linux/include/linux/dmaengine.h: In function
> >>> 'dma_async_is_complete': linux/include/linux/dmaengine.h:1023:9:
> >>> error: 'DMA_IN_PROGRESS' undeclared (first use in this function)
> >>> linux/include/linux/dmaengine.h:1023:9: note: each undeclared
> >>> identifier is reported only once for each function it appears in
> >>=20
> >> There are two locations where DMA_COMPLETE is defined:
> >>> arch/blackfin/mach-bf548/include/mach/defBF547.h:602:#define         =
 =20
> >>>   DMA_COMPLETE  0x8        /* DMA Complete */
> >>> arch/blackfin/mach-bf548/include/mach/defBF544.h:622:#define         =
=20
> >>>    DMA_COMPLETE  0x8        /* DMA Complete */
> >>=20
> >> and
> >>=20
> >>> include/linux/dmaengine.h-enum dma_status {
> >>> include/linux/dmaengine.h:      DMA_COMPLETE,
> >>> include/linux/dmaengine.h-      DMA_IN_PROGRESS,
> >>> include/linux/dmaengine.h-      DMA_PAUSED,
> >>> include/linux/dmaengine.h-      DMA_ERROR,
> >>> include/linux/dmaengine.h-};
> >>=20
> >> What's the appropriate fix for the problem?
> >=20
> > arch/blackfin/mach-bf548/ needs a less generic name for its macro.
>=20
> Mike, is there a in tree user of blacksfin's DMA_COMPLETE? I cannot find
> anyone.

looks like those are defines for the host port peripheral on the BF54x. =20
typically for peripherals we didn't have proper drivers for (like CAN and U=
ART=20
and SPI and such), we left the defines in the headers.  those in turn match=
ed=20
the manual so people coming from other Blackfin environments (and reading t=
he=20
manuals) didn't have to figure out what name the Linux headers used.

unfortunately, it leads to cases like this where the names are pretty bad. =
=20
considering the host peripheral most likely never saw any serious use, it=20
should be fine to delete all the bit defines in those headers related to th=
ose=20
registers (i see HOST_{STATUS,CONTROL,TIMEOUT}.
=2Dmike

--nextPart1446358.bA7LiXDtym
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJS2ibuAAoJEEFjO5/oN/WB/XYP/ifHMprICKKOdXUySmFwSjm0
BmvnvL9PKANd6/9Ve0ii0WI0RpQT0GQisTHulBe4ATamXMLvyxQC05gpEehEvb6B
RBp/EXMwO5abIK63MMIwy33MS9yyXKXKIj21h0HDM1XcGlNpe3aYSavUWXu945ew
Sjk5ZLuBNxzOK80yGlni7NxTCR5/+D9jYWNMBmEgczjRaPu5An+yiMCG9zjRp0GZ
IpFsKWLk9cSlsRx2bA/ow51CYrmRhb6duB/NXsM1R8jIKzajsiN0w5SAp1FZlmLm
U68eEVsU1jRhxhGiyIZxVi5bZm9snMeUTLtVW70RLqMW8oUaE//ID4Jq3AusoAAI
tNqM5ARvSkse8C0nmZzBHpXv8j5BqB4MaPdAqYP3CJfJQ8hgd+BNZLn5VZabs67J
fZBNhuGxwg0XbwlfYqsffk6dTg0tGsfdUrVrsIGhK+zSm7l5VsERuoR+Om4mNcHo
b4qhvxgTbU0JnDCxuSaaEH9amAD107+dcz/wpbVtCn7lo+ZXKQAfipnH9JPzCl/+
0mPXr9STbSXYhsTnFEbsA+wcJddOP/2ePkx3pkvtROQp0P6deqNqOqhH0Nyzii/K
Whs+81icmwDrvPCn1qtnYwdoNlPxZdQRY/1c+5D+yyhs1Z2f20xuilnijl9NBbqj
WBhAFfg8k4hQ7kIvGK3J
=ZsG/
-----END PGP SIGNATURE-----

--nextPart1446358.bA7LiXDtym--
