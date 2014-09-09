Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133AbaIIKnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:43:46 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:36133 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756324AbaIIK1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:27:10 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 00/48] staging: comedi: avoid using comedi_board()
Date: Tue,  9 Sep 2014 11:26:09 +0100
Message-Id: <1410258417-28230-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The `comedi_board` inline function takes a single parameter of type
`struct comedi_device *` and merely returns the value of the `board_ptr`
member therein.  This is somewhat superfluous as the member can be
accessed directly.

Replace all uses of `comedi_board(dev)` with `dev->board_ptr`.

Note, if there are any conflicts when applying this series, they can
just be skipped for now and corrected later.

A subsequent patch will remove the `comedi_board` function, once there
is nothing using it.

01) staging: comedi: addi_common: replace comedi_board() calls
02) staging: comedi: addi_eeprom: replace comedi_board() calls
03) staging: comedi: addi_apci_1516: replace comedi_board() calls
04) staging: comedi: addi_apci_3120: replace comedi_board() calls
05) staging: comedi: addi_apci_3xxx: replace comedi_board() calls
06) staging: comedi: adl_pci9118: replace comedi_board() calls
07) staging: comedi: adv_pci1710: replace comedi_board() calls
08) staging: comedi: adv_pci_dio: replace comedi_board() calls
09) staging: comedi: aio_aio12_8: replace comedi_board() calls
10) staging: comedi: amplc_dio200_common: replace comedi_board() calls
11) staging: comedi: amplc_pc236_common: replace comedi_board() calls
12) staging: comedi: amplc_pci224: replace comedi_board() calls
13) staging: comedi: amplc_pci230: replace comedi_board() calls
14) staging: comedi: cb_pcidas64: replace comedi_board() calls
15) staging: comedi: cb_pcidas: replace comedi_board() calls
16) staging: comedi: das08: replace comedi_board() calls
17) staging: comedi: das08_isa: replace comedi_board() calls
18) staging: comedi: das16: replace comedi_board() calls
19) staging: comedi: das1800: replace comedi_board() calls
20) staging: comedi: das6402: replace comedi_board() calls
21) staging: comedi: das800: replace comedi_board() calls
22) staging: comedi: dt2801: replace comedi_board() calls
23) staging: comedi: dt2811: replace comedi_board() calls
24) staging: comedi: dt282x: replace comedi_board() calls
25) staging: comedi: dt3000: replace comedi_board() calls
26) staging: comedi: me4000: replace comedi_board() calls
27) staging: comedi: ni_65xx: replace comedi_board() calls
28) staging: comedi: ni_660x: replace comedi_board() calls
29) staging: comedi: ni_at_a2150: replace comedi_board() calls
30) staging: comedi: ni_at_ao: replace comedi_board() calls
31) staging: comedi: ni_atmio16d: replace comedi_board() calls
32) staging: comedi: ni_atmio: replace comedi_board() calls
33) staging: comedi: ni_labpc_common: replace comedi_board() calls
34) staging: comedi: ni_labpc_isadma: replace comedi_board() calls
35) staging: comedi: ni_mio_common: replace comedi_board() calls
36) staging: comedi: ni_pcimio: replace comedi_board() calls
37) staging: comedi: pcl711: replace comedi_board() calls
38) staging: comedi: pcl724: replace comedi_board() calls
39) staging: comedi: pcl726: replace comedi_board() calls
40) staging: comedi: pcl730: replace comedi_board() calls
41) staging: comedi: pcl812: replace comedi_board() calls
42) staging: comedi: pcl816: replace comedi_board() calls
43) staging: comedi: pcl818: replace comedi_board() calls
44) staging: comedi: pcmad: replace comedi_board() calls
45) staging: comedi: pcmuio: replace comedi_board() calls
46) staging: comedi: rtd520: replace comedi_board() calls
47) staging: comedi: rti800: replace comedi_board() calls
48) staging: comedi: vmk80xx: replace comedi_board() calls

 .../staging/comedi/drivers/addi-data/addi_common.c |  8 +--
 .../staging/comedi/drivers/addi-data/addi_eeprom.c | 12 ++--
 .../comedi/drivers/addi-data/hwdrv_apci3120.c      | 10 ++--
 drivers/staging/comedi/drivers/addi_apci_1516.c    |  2 +-
 drivers/staging/comedi/drivers/addi_apci_3120.c    |  2 +-
 drivers/staging/comedi/drivers/addi_apci_3xxx.c    |  4 +-
 drivers/staging/comedi/drivers/adl_pci9118.c       |  2 +-
 drivers/staging/comedi/drivers/adv_pci1710.c       | 14 ++---
 drivers/staging/comedi/drivers/adv_pci_dio.c       |  6 +-
 drivers/staging/comedi/drivers/aio_aio12_8.c       |  2 +-
 .../staging/comedi/drivers/amplc_dio200_common.c   | 30 +++++-----
 .../staging/comedi/drivers/amplc_pc236_common.c    |  4 +-
 drivers/staging/comedi/drivers/amplc_pci224.c      |  8 +--
 drivers/staging/comedi/drivers/amplc_pci230.c      | 10 ++--
 drivers/staging/comedi/drivers/cb_pcidas.c         | 14 ++---
 drivers/staging/comedi/drivers/cb_pcidas64.c       | 66 +++++++++++-----------
 drivers/staging/comedi/drivers/das08.c             | 14 ++---
 drivers/staging/comedi/drivers/das08_isa.c         |  2 +-
 drivers/staging/comedi/drivers/das16.c             | 12 ++--
 drivers/staging/comedi/drivers/das1800.c           | 12 ++--
 drivers/staging/comedi/drivers/das6402.c           |  2 +-
 drivers/staging/comedi/drivers/das800.c            | 10 ++--
 drivers/staging/comedi/drivers/dt2801.c            |  2 +-
 drivers/staging/comedi/drivers/dt2811.c            |  2 +-
 drivers/staging/comedi/drivers/dt282x.c            |  4 +-
 drivers/staging/comedi/drivers/dt3000.c            |  2 +-
 drivers/staging/comedi/drivers/me4000.c            |  4 +-
 drivers/staging/comedi/drivers/ni_65xx.c           |  2 +-
 drivers/staging/comedi/drivers/ni_660x.c           |  8 +--
 drivers/staging/comedi/drivers/ni_at_a2150.c       |  6 +-
 drivers/staging/comedi/drivers/ni_at_ao.c          |  2 +-
 drivers/staging/comedi/drivers/ni_atmio.c          |  2 +-
 drivers/staging/comedi/drivers/ni_atmio16d.c       |  2 +-
 drivers/staging/comedi/drivers/ni_labpc_common.c   | 14 ++---
 drivers/staging/comedi/drivers/ni_labpc_isadma.c   |  2 +-
 drivers/staging/comedi/drivers/ni_mio_common.c     | 26 ++++-----
 drivers/staging/comedi/drivers/ni_pcimio.c         |  2 +-
 drivers/staging/comedi/drivers/pcl711.c            |  2 +-
 drivers/staging/comedi/drivers/pcl724.c            |  2 +-
 drivers/staging/comedi/drivers/pcl726.c            |  6 +-
 drivers/staging/comedi/drivers/pcl730.c            |  2 +-
 drivers/staging/comedi/drivers/pcl812.c            |  8 +--
 drivers/staging/comedi/drivers/pcl816.c            |  2 +-
 drivers/staging/comedi/drivers/pcl818.c            |  8 +--
 drivers/staging/comedi/drivers/pcmad.c             |  2 +-
 drivers/staging/comedi/drivers/pcmuio.c            |  4 +-
 drivers/staging/comedi/drivers/rtd520.c            |  2 +-
 drivers/staging/comedi/drivers/rti800.c            |  2 +-
 drivers/staging/comedi/drivers/vmk80xx.c           |  2 +-
 49 files changed, 184 insertions(+), 184 deletions(-)
