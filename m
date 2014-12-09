Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369AbaLIDs0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 22:48:26 -0500
Received: from ozlabs.org ([103.22.144.67]:54389 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520AbaLIDsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 22:48:25 -0500
Date: Tue, 9 Dec 2014 14:48:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: linux-next: build failure after merge of the slave-dma tree
Message-ID: <20141209144817.2df2eb7c@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/5CE8LYlROMBvLPE1_kyByK8"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/5CE8LYlROMBvLPE1_kyByK8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Vinod,

After merging the slave-dma tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/spi/spi-atmel.c: In function 'atmel_spi_stop_dma':
drivers/spi/spi-atmel.c:485:26: error: 'struct dma_device' has no member na=
med 'device_control'
   as->dma.chan_rx->device->device_control(as->dma.chan_rx,
                          ^
drivers/spi/spi-atmel.c:486:8: error: 'DMA_TERMINATE_ALL' undeclared (first=
 use in this function)
        DMA_TERMINATE_ALL, 0);
        ^
drivers/spi/spi-atmel.c:486:8: note: each undeclared identifier is reported=
 only once for each function it appears in
drivers/spi/spi-atmel.c:488:26: error: 'struct dma_device' has no member na=
med 'device_control'
   as->dma.chan_tx->device->device_control(as->dma.chan_tx,
                          ^
drivers/usb/musb/ux500_dma.c: In function 'ux500_configure_channel':
drivers/usb/musb/ux500_dma.c:124:18: error: 'struct dma_device' has no memb=
er named 'device_control'
  dma_chan->device->device_control(dma_chan, DMA_SLAVE_CONFIG,
                  ^
drivers/usb/musb/ux500_dma.c:124:45: error: 'DMA_SLAVE_CONFIG' undeclared (=
first use in this function)
  dma_chan->device->device_control(dma_chan, DMA_SLAVE_CONFIG,
                                             ^
drivers/usb/musb/ux500_dma.c:124:45: note: each undeclared identifier is re=
ported only once for each function it appears in
drivers/usb/musb/ux500_dma.c: In function 'ux500_dma_channel_abort':
drivers/usb/musb/ux500_dma.c:249:34: error: 'struct dma_device' has no memb=
er named 'device_control'
   ux500_channel->dma_chan->device->
                                  ^
drivers/usb/musb/ux500_dma.c:251:6: error: 'DMA_TERMINATE_ALL' undeclared (=
first use in this function)
      DMA_TERMINATE_ALL, 0);
      ^

Caused by commit f86999789afe ("dmaengine: Remove device_control and
device_slave_caps").

I have used the slave-dma tree from next-20141208 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/5CE8LYlROMBvLPE1_kyByK8
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUhnEGAAoJEMDTa8Ir7ZwVkeIQAIMFsCq89Q9bPqGGe96baJ1M
K4YWY+wad3FmCmbgDd8MvK2UExEVgXpTQlt4fBtulJcQ0D6nFtDBur4upuib7dkj
WsV3a66kXhIYOxWc8VHeAJ7fwUWdlDYF4dHsTZXdGJNtpo+NjfQwphv/spr61ler
uPucDGNsHnxDi7qZqKJDIqSwGETm69Cc6FHWQ59QejOOFeJ9DnwbvUgcTeMzjyAC
Go6Ui2MmmVyD2qdiHcKOyA1dm2x2RHd6wr7zrw+6SzEebOWJgI8/FuXlMGKFTfe/
wrm13tfPPaJtBC9o8bL9FUrwMX+bfRqseTiFjGbRpjEDSUVBrHb1duMzti299wUC
k3v88oLd436L2k427sRPJ5XUkWBIGfQvbHvpNebJ2nU5arpwvUiCoV1o+npTEsh1
a8othC+ok2vp8zk1v/USaSznRZt3SzS2noS4zhmdWhjw9oRaxumlSWFNx57DFpcw
ztN0qYeHmFYwdESJb9IsC4wgLdv8tMXbczF4viCMR972mVqIla+o1Cold+eZJNHZ
mu6ShWa/qtDh3hQkeL9zl+jshwOS2ChN8zgi1yy4Wngym65Bj8e3yrXlkRMQcZy5
Kvi/kqetLZP5dPGUmn/dBgAEqAsaKAbjEFWJwsv8cuM+b/b0z7FhqnmbQ5X+xI7U
KEsFrYPDQRZSYfDbPR3i
=dAE4
-----END PGP SIGNATURE-----

--Sig_/5CE8LYlROMBvLPE1_kyByK8--
