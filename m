Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab3G2Dmh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 23:42:37 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43111 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab3G2Dmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 23:42:33 -0400
Date: Mon, 29 Jul 2013 13:42:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the spi tree
Message-Id: <20130729134223.bbae9d9f2a9cd6ca1717c976@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__29_Jul_2013_13_42_23_+1000_t5zUmu3KWosF8q4j"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Jul_2013_13_42_23_+1000_t5zUmu3KWosF8q4j
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

After merging the spi tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/spi/spi-pxa2xx-pxadma.c: In function 'wait_dma_channel_stop':
drivers/spi/spi-pxa2xx-pxadma.c:136:2: error: implicit declaration of funct=
ion 'DCSR' [-Werror=3Dimplicit-function-declaration]
  while (!(DCSR(channel) & DCSR_STOPSTATE) && --limit)
  ^
drivers/spi/spi-pxa2xx-pxadma.c:136:27: error: 'DCSR_STOPSTATE' undeclared =
(first use in this function)
  while (!(DCSR(channel) & DCSR_STOPSTATE) && --limit)
                           ^
drivers/spi/spi-pxa2xx-pxadma.c:136:27: note: each undeclared identifier is=
 reported only once for each function it appears in
drivers/spi/spi-pxa2xx-pxadma.c: In function 'pxa2xx_spi_dma_error_stop':
drivers/spi/spi-pxa2xx-pxadma.c:32:28: error: 'DCSR_NODESC' undeclared (fir=
st use in this function)
 #define RESET_DMA_CHANNEL (DCSR_NODESC | DMA_INT_MASK)
                            ^
drivers/spi/spi-pxa2xx-pxadma.c:148:31: note: in expansion of macro 'RESET_=
DMA_CHANNEL'
  DCSR(drv_data->rx_channel) =3D RESET_DMA_CHANNEL;
                               ^
drivers/spi/spi-pxa2xx-pxadma.c:31:24: error: 'DCSR_ENDINTR' undeclared (fi=
rst use in this function)
 #define DMA_INT_MASK  (DCSR_ENDINTR | DCSR_STARTINTR | DCSR_BUSERR)
                        ^
drivers/spi/spi-pxa2xx-pxadma.c:32:42: note: in expansion of macro 'DMA_INT=
_MASK'
 #define RESET_DMA_CHANNEL (DCSR_NODESC | DMA_INT_MASK)
                                          ^
drivers/spi/spi-pxa2xx-pxadma.c:148:31: note: in expansion of macro 'RESET_=
DMA_CHANNEL'
  DCSR(drv_data->rx_channel) =3D RESET_DMA_CHANNEL;
                               ^
drivers/spi/spi-pxa2xx-pxadma.c:31:39: error: 'DCSR_STARTINTR' undeclared (=
first use in this function)
 #define DMA_INT_MASK  (DCSR_ENDINTR | DCSR_STARTINTR | DCSR_BUSERR)
                                       ^
drivers/spi/spi-pxa2xx-pxadma.c:32:42: note: in expansion of macro 'DMA_INT=
_MASK'
 #define RESET_DMA_CHANNEL (DCSR_NODESC | DMA_INT_MASK)
                                          ^
drivers/spi/spi-pxa2xx-pxadma.c:148:31: note: in expansion of macro 'RESET_=
DMA_CHANNEL'
  DCSR(drv_data->rx_channel) =3D RESET_DMA_CHANNEL;
                               ^
drivers/spi/spi-pxa2xx-pxadma.c:31:56: error: 'DCSR_BUSERR' undeclared (fir=
st use in this function)
 #define DMA_INT_MASK  (DCSR_ENDINTR | DCSR_STARTINTR | DCSR_BUSERR)
                                                        ^
drivers/spi/spi-pxa2xx-pxadma.c:32:42: note: in expansion of macro 'DMA_INT=
_MASK'
 #define RESET_DMA_CHANNEL (DCSR_NODESC | DMA_INT_MASK)
                                          ^
drivers/spi/spi-pxa2xx-pxadma.c:148:31: note: in expansion of macro 'RESET_=
DMA_CHANNEL'
  DCSR(drv_data->rx_channel) =3D RESET_DMA_CHANNEL;
                               ^
drivers/spi/spi-pxa2xx-pxadma.c: In function 'pxa2xx_spi_dma_transfer_compl=
ete':
drivers/spi/spi-pxa2xx-pxadma.c:32:28: error: 'DCSR_NODESC' undeclared (fir=
st use in this function)
 #define RESET_DMA_CHANNEL (DCSR_NODESC | DMA_INT_MASK)
                            ^
drivers/spi/spi-pxa2xx-pxadma.c:173:31: note: in expansion of macro 'RESET_=
DMA_CHANNEL'
  DCSR(drv_data->tx_channel) =3D RESET_DMA_CHANNEL;
                               ^
drivers/spi/spi-pxa2xx-pxadma.c:31:24: error: 'DCSR_ENDINTR' undeclared (fi=
rst use in this function)
 #define DMA_INT_MASK  (DCSR_ENDINTR | DCSR_STARTINTR | DCSR_BUSERR)
                        ^
drivers/spi/spi-pxa2xx-pxadma.c:32:42: note: in expansion of macro 'DMA_INT=
_MASK'
 #define RESET_DMA_CHANNEL (DCSR_NODESC | DMA_INT_MASK)
                                          ^
drivers/spi/spi-pxa2xx-pxadma.c:173:31: note: in expansion of macro 'RESET_=
DMA_CHANNEL'
  DCSR(drv_data->tx_channel) =3D RESET_DMA_CHANNEL;
                               ^
drivers/spi/spi-pxa2xx-pxadma.c:31:39: error: 'DCSR_STARTINTR' undeclared (=
first use in this function)
 #define DMA_INT_MASK  (DCSR_ENDINTR | DCSR_STARTINTR | DCSR_BUSERR)
                                       ^
drivers/spi/spi-pxa2xx-pxadma.c:32:42: note: in expansion of macro 'DMA_INT=
_MASK'
 #define RESET_DMA_CHANNEL (DCSR_NODESC | DMA_INT_MASK)
                                          ^
drivers/spi/spi-pxa2xx-pxadma.c:173:31: note: in expansion of macro 'RESET_=
DMA_CHANNEL'
  DCSR(drv_data->tx_channel) =3D RESET_DMA_CHANNEL;
                               ^
drivers/spi/spi-pxa2xx-pxadma.c:31:56: error: 'DCSR_BUSERR' undeclared (fir=
st use in this function)
 #define DMA_INT_MASK  (DCSR_ENDINTR | DCSR_STARTINTR | DCSR_BUSERR)
                                                        ^
drivers/spi/spi-pxa2xx-pxadma.c:32:42: note: in expansion of macro 'DMA_INT=
_MASK'
 #define RESET_DMA_CHANNEL (DCSR_NODESC | DMA_INT_MASK)
                                          ^
drivers/spi/spi-pxa2xx-pxadma.c:173:31: note: in expansion of macro 'RESET_=
DMA_CHANNEL'
  DCSR(drv_data->tx_channel) =3D RESET_DMA_CHANNEL;
                               ^
drivers/spi/spi-pxa2xx-pxadma.c:188:4: error: implicit declaration of funct=
ion 'DCMD' [-Werror=3Dimplicit-function-declaration]
    (DCMD(drv_data->rx_channel) & DCMD_LENGTH);
    ^
drivers/spi/spi-pxa2xx-pxadma.c:188:34: error: 'DCMD_LENGTH' undeclared (fi=
rst use in this function)
    (DCMD(drv_data->rx_channel) & DCMD_LENGTH);
                                  ^
drivers/spi/spi-pxa2xx-pxadma.c: In function 'pxa2xx_spi_dma_handler':
drivers/spi/spi-pxa2xx-pxadma.c:31:24: error: 'DCSR_ENDINTR' undeclared (fi=
rst use in this function)
 #define DMA_INT_MASK  (DCSR_ENDINTR | DCSR_STARTINTR | DCSR_BUSERR)
                        ^
drivers/spi/spi-pxa2xx-pxadma.c:213:35: note: in expansion of macro 'DMA_IN=
T_MASK'
  u32 irq_status =3D DCSR(channel) & DMA_INT_MASK;
                                   ^
drivers/spi/spi-pxa2xx-pxadma.c:31:39: error: 'DCSR_STARTINTR' undeclared (=
first use in this function)
 #define DMA_INT_MASK  (DCSR_ENDINTR | DCSR_STARTINTR | DCSR_BUSERR)
                                       ^
drivers/spi/spi-pxa2xx-pxadma.c:213:35: note: in expansion of macro 'DMA_IN=
T_MASK'
  u32 irq_status =3D DCSR(channel) & DMA_INT_MASK;
                                   ^
drivers/spi/spi-pxa2xx-pxadma.c:31:56: error: 'DCSR_BUSERR' undeclared (fir=
st use in this function)
 #define DMA_INT_MASK  (DCSR_ENDINTR | DCSR_STARTINTR | DCSR_BUSERR)
                                                        ^
drivers/spi/spi-pxa2xx-pxadma.c:213:35: note: in expansion of macro 'DMA_IN=
T_MASK'
  u32 irq_status =3D DCSR(channel) & DMA_INT_MASK;
                                   ^
drivers/spi/spi-pxa2xx-pxadma.c: In function 'pxa2xx_spi_dma_transfer':
drivers/spi/spi-pxa2xx-pxadma.c:255:36: error: 'DCSR_RUN' undeclared (first=
 use in this function)
   && (DCSR(drv_data->tx_channel) & DCSR_RUN)) {
                                    ^
drivers/spi/spi-pxa2xx-pxadma.c: In function 'pxa2xx_spi_dma_prepare':
drivers/spi/spi-pxa2xx-pxadma.c:283:15: error: 'DCMD_WIDTH1' undeclared (fi=
rst use in this function)
   dma_width =3D DCMD_WIDTH1;
               ^
drivers/spi/spi-pxa2xx-pxadma.c:286:15: error: 'DCMD_WIDTH2' undeclared (fi=
rst use in this function)
   dma_width =3D DCMD_WIDTH2;
               ^
drivers/spi/spi-pxa2xx-pxadma.c:289:15: error: 'DCMD_WIDTH4' undeclared (fi=
rst use in this function)
   dma_width =3D DCMD_WIDTH4;
               ^
drivers/spi/spi-pxa2xx-pxadma.c:32:28: error: 'DCSR_NODESC' undeclared (fir=
st use in this function)
 #define RESET_DMA_CHANNEL (DCSR_NODESC | DMA_INT_MASK)
                            ^
drivers/spi/spi-pxa2xx-pxadma.c:294:31: note: in expansion of macro 'RESET_=
DMA_CHANNEL'
  DCSR(drv_data->rx_channel) =3D RESET_DMA_CHANNEL;
                               ^
drivers/spi/spi-pxa2xx-pxadma.c:31:24: error: 'DCSR_ENDINTR' undeclared (fi=
rst use in this function)
 #define DMA_INT_MASK  (DCSR_ENDINTR | DCSR_STARTINTR | DCSR_BUSERR)
                        ^
drivers/spi/spi-pxa2xx-pxadma.c:32:42: note: in expansion of macro 'DMA_INT=
_MASK'
 #define RESET_DMA_CHANNEL (DCSR_NODESC | DMA_INT_MASK)
                                          ^
drivers/spi/spi-pxa2xx-pxadma.c:294:31: note: in expansion of macro 'RESET_=
DMA_CHANNEL'
  DCSR(drv_data->rx_channel) =3D RESET_DMA_CHANNEL;
                               ^
drivers/spi/spi-pxa2xx-pxadma.c:31:39: error: 'DCSR_STARTINTR' undeclared (=
first use in this function)
 #define DMA_INT_MASK  (DCSR_ENDINTR | DCSR_STARTINTR | DCSR_BUSERR)
                                       ^
drivers/spi/spi-pxa2xx-pxadma.c:32:42: note: in expansion of macro 'DMA_INT=
_MASK'
 #define RESET_DMA_CHANNEL (DCSR_NODESC | DMA_INT_MASK)
                                          ^
drivers/spi/spi-pxa2xx-pxadma.c:294:31: note: in expansion of macro 'RESET_=
DMA_CHANNEL'
  DCSR(drv_data->rx_channel) =3D RESET_DMA_CHANNEL;
                               ^
drivers/spi/spi-pxa2xx-pxadma.c:31:56: error: 'DCSR_BUSERR' undeclared (fir=
st use in this function)
 #define DMA_INT_MASK  (DCSR_ENDINTR | DCSR_STARTINTR | DCSR_BUSERR)
                                                        ^
drivers/spi/spi-pxa2xx-pxadma.c:32:42: note: in expansion of macro 'DMA_INT=
_MASK'
 #define RESET_DMA_CHANNEL (DCSR_NODESC | DMA_INT_MASK)
                                          ^
drivers/spi/spi-pxa2xx-pxadma.c:294:31: note: in expansion of macro 'RESET_=
DMA_CHANNEL'
  DCSR(drv_data->rx_channel) =3D RESET_DMA_CHANNEL;
                               ^
drivers/spi/spi-pxa2xx-pxadma.c:295:2: error: implicit declaration of funct=
ion 'DSADR' [-Werror=3Dimplicit-function-declaration]
  DSADR(drv_data->rx_channel) =3D drv_data->ssdr_physical;
  ^
drivers/spi/spi-pxa2xx-pxadma.c:295:30: error: lvalue required as left oper=
and of assignment
  DSADR(drv_data->rx_channel) =3D drv_data->ssdr_physical;
                              ^
drivers/spi/spi-pxa2xx-pxadma.c:296:2: error: implicit declaration of funct=
ion 'DTADR' [-Werror=3Dimplicit-function-declaration]
  DTADR(drv_data->rx_channel) =3D drv_data->rx_dma;
  ^
drivers/spi/spi-pxa2xx-pxadma.c:296:30: error: lvalue required as left oper=
and of assignment
  DTADR(drv_data->rx_channel) =3D drv_data->rx_dma;
                              ^
drivers/spi/spi-pxa2xx-pxadma.c:299:32: error: 'DCMD_FLOWSRC' undeclared (f=
irst use in this function)
   DCMD(drv_data->rx_channel) =3D DCMD_FLOWSRC
                                ^
drivers/spi/spi-pxa2xx-pxadma.c:304:32: error: 'DCMD_INCTRGADDR' undeclared=
 (first use in this function)
   DCMD(drv_data->rx_channel) =3D DCMD_INCTRGADDR
                                ^
drivers/spi/spi-pxa2xx-pxadma.c:312:30: error: lvalue required as left oper=
and of assignment
  DSADR(drv_data->tx_channel) =3D drv_data->tx_dma;
                              ^
drivers/spi/spi-pxa2xx-pxadma.c:313:30: error: lvalue required as left oper=
and of assignment
  DTADR(drv_data->tx_channel) =3D drv_data->ssdr_physical;
                              ^
drivers/spi/spi-pxa2xx-pxadma.c:316:32: error: 'DCMD_FLOWTRG' undeclared (f=
irst use in this function)
   DCMD(drv_data->tx_channel) =3D DCMD_FLOWTRG
                                ^
drivers/spi/spi-pxa2xx-pxadma.c:321:32: error: 'DCMD_INCSRCADDR' undeclared=
 (first use in this function)
   DCMD(drv_data->tx_channel) =3D DCMD_INCSRCADDR
                                ^
drivers/spi/spi-pxa2xx-pxadma.c:329:33: error: 'DCMD_ENDIRQEN' undeclared (=
first use in this function)
   DCMD(drv_data->tx_channel) |=3D DCMD_ENDIRQEN;
                                 ^
drivers/spi/spi-pxa2xx-pxadma.c: In function 'pxa2xx_spi_dma_start':
drivers/spi/spi-pxa2xx-pxadma.c:336:32: error: 'DCSR_RUN' undeclared (first=
 use in this function)
  DCSR(drv_data->rx_channel) |=3D DCSR_RUN;
                                ^
drivers/spi/spi-pxa2xx-pxadma.c: In function 'pxa2xx_spi_dma_setup':
drivers/spi/spi-pxa2xx-pxadma.c:346:2: error: implicit declaration of funct=
ion 'pxa_request_dma' [-Werror=3Dimplicit-function-declaration]
  drv_data->rx_channel =3D pxa_request_dma("pxa2xx_spi_ssp_rx",
  ^
drivers/spi/spi-pxa2xx-pxadma.c:347:7: error: 'DMA_PRIO_HIGH' undeclared (f=
irst use in this function)
       DMA_PRIO_HIGH,
       ^
drivers/spi/spi-pxa2xx-pxadma.c:356:7: error: 'DMA_PRIO_MEDIUM' undeclared =
(first use in this function)
       DMA_PRIO_MEDIUM,
       ^
drivers/spi/spi-pxa2xx-pxadma.c:362:3: error: implicit declaration of funct=
ion 'pxa_free_dma' [-Werror=3Dimplicit-function-declaration]
   pxa_free_dma(drv_data->rx_channel);
   ^
drivers/spi/spi-pxa2xx-pxadma.c:366:2: error: implicit declaration of funct=
ion 'DRCMR' [-Werror=3Dimplicit-function-declaration]
  DRCMR(ssp->drcmr_rx) =3D DRCMR_MAPVLD | drv_data->rx_channel;
  ^
drivers/spi/spi-pxa2xx-pxadma.c:366:25: error: 'DRCMR_MAPVLD' undeclared (f=
irst use in this function)
  DRCMR(ssp->drcmr_rx) =3D DRCMR_MAPVLD | drv_data->rx_channel;
                         ^
drivers/spi/spi-pxa2xx-pxadma.c: In function 'pxa2xx_spi_dma_release':
drivers/spi/spi-pxa2xx-pxadma.c:376:23: error: lvalue required as left oper=
and of assignment
  DRCMR(ssp->drcmr_rx) =3D 0;
                       ^
drivers/spi/spi-pxa2xx-pxadma.c:377:23: error: lvalue required as left oper=
and of assignment
  DRCMR(ssp->drcmr_tx) =3D 0;
                       ^
drivers/spi/spi-pxa2xx-pxadma.c: In function 'pxa2xx_spi_dma_resume':
drivers/spi/spi-pxa2xx-pxadma.c:389:4: error: 'DRCMR_MAPVLD' undeclared (fi=
rst use in this function)
    DRCMR_MAPVLD | drv_data->rx_channel;
    ^
drivers/spi/spi-pxa2xx-pxadma.c: In function 'pxa2xx_spi_set_dma_burst_and_=
threshold':
drivers/spi/spi-pxa2xx-pxadma.c:441:27: error: 'DCMD_BURST8' undeclared (fi=
rst use in this function)
    chip->dma_burst_size =3D DCMD_BURST8;
                           ^
drivers/spi/spi-pxa2xx-pxadma.c:445:8: error: 'DCMD_BURST16' undeclared (fi=
rst use in this function)
   case DCMD_BURST16:
        ^
drivers/spi/spi-pxa2xx-pxadma.c:448:8: error: 'DCMD_BURST32' undeclared (fi=
rst use in this function)
   case DCMD_BURST32:
        ^

Presumably caused by commit 854b3b284ec9 ("spi/drivers: Enable build of
drivers with COMPILE_TEST").

Frankly, Mark, if you are unable or unwilling to do some basic cross
build testing, please do not do any more of these patches that add
CONFIG_COMPILE_TEST.  Leave them to someone who can.

I have used the spi tree from next-20130726 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__29_Jul_2013_13_42_23_+1000_t5zUmu3KWosF8q4j
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR9eSjAAoJEECxmPOUX5FEMGMQAIX5r8etrZC/t8pmR1NaeIIW
CbaiYe/3LxeQYxNNfeSar74T8Jgl6rN/bh5aGGkcQAByFF3xeu9/X9vUiGYteDGX
qxodpYozdq7eVrp0Brax08hZ1+h2h8JHBPnV8wEjAgKcBiekLVoXqSCUAFJ+m2G9
wdba6d+gL5+UtOMdd8XENZpVwdzScHvzisPa8Pv/2Srh9jkG+qV6BKFgGoUvMwuB
Q8ekdDINmdEGqcrh6XfBYlzXejsQBgSkL0OazYp1Y/7W7XBvJVO6lGz5+21+6fxI
JCzrcN+Ov7tQ6Y7TZobjyVrQZ/xwtj27rMnKblWXTdVHZrdK22e6NA5kD5SH6/hl
18VoqTQBdznCy1nV+9K/gsDqv7Mb2EZtwxhgC3dE7ueqq+8LGkX3dlqglSM/sOOQ
PtFq9iMGoo1DpLqO8hYFAbpEKv0nuFtiojnCvQjVaFRkTTupW/OkIO9lPdM5Ylqf
e47AxK7x6NRSWK4wQ28lvapH6dcunSRH0lAp/ilqyJatm+sFji8JLP15zVoP1xtU
S74IBxDxNapLAXCmWxfT3KoyIYBaVGtY9WaQEtbJhpzBffXTy9Kuy5QztyI2qcKP
zq55NpClhhZZV4ryy5kujzscggi/u0xU+wx09imN0l3qdjOWTxSpwb/8UB3Ox1J1
H8qLfx1iJbey7AR/n7QX
=8lVr
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Jul_2013_13_42_23_+1000_t5zUmu3KWosF8q4j--
