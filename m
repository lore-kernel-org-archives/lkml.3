Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbbAERzn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 12:55:43 -0500
Received: from smtp97.iad3a.emailsrvr.com ([173.203.187.97]:41541 "EHLO
	smtp97.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753884AbbAERzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 12:55:42 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/45] staging: comedi: fix up some driver comments
Date: Mon,  5 Jan 2015 17:54:28 +0000
Message-Id: <1420480513-14765-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most comedi drivers have a special comedi driver comment block,
information from which can be extracted by some scripts for use in the
"Comedilib" manual and the list of supported devices on the comedi web
site.  (Currently, the information for those places comes from the
"out-of-tree" comedi drivers.)

The "Devices:" line (and continuation lines) are supposed to be a
comma-(and space)-separated list with the first item in this format:

  [Manufacturer] BOARD-NAME (comedi-board-name)

The "[Manufacturer]" and "(comedi-board-name)" parts can be omitted from
subsequent list items to decrease verbosity, in which case they are
assumed to be the same as the preceding item.

Several comedi drivers have the "Devices:" line formatted incorrectly,
often with the use of square brackets and parentheses reversed.  A few
comedi modules have driver comments, but are just support modules for
other drivers, so don't really need a driver comment.

01) staging: comedi: 8255_pci: rewrite comedi driver comment block
02) staging: comedi: adl_pci6208: rewrite "Devices:" line
03) staging: comedi: adl_pci7x3x: rewrite comedi driver comment block
04) staging: comedi: adl_pci8164: rewrite "Devices:" line
05) staging: comedi: adv_pci1723: rewrite "Devices:" line
06) staging: comedi: adv_pci1724: rewrite "Devices:" line
07) staging: comedi: c6xdigio: rewrite "Devices:" line
08) staging: comedi: cb_pcidda: rewrite "Devices:" line
09) staging: comedi: comedi_parport: rewrite "Devices:" line
10) staging: comedi: dac02: rewrite "Devices:" line
11) staging: comedi: das08: remove comedi driver comment block
12) staging: comedi: das08_isa: rewrite "Devices:" line
13) staging: comedi: das08_pci: rewrite "Devices:" line
14) staging: comedi: das16: rewrite "Devices:" line
15) staging: comedi: das6402: rewrite "Devices:" line
16) staging: comedi: dmm32at: rewrite "Devices:" line
17) staging: comedi: dt282x: rewrite "Devices:" line
18) staging: comedi: dyna_pci10xx: rewrite comedi driver comment block
19) staging: comedi: ii_pci20kc: rewrite "Devices:" line
20) staging: comedi: ke_counter: rewrite "Devices:" line
21) staging: comedi: me_daq: rewrite "Devices:" line
22) staging: comedi: mf6x4: rewrite "Devices:" line
23) staging: comedi: ni_6527: rewrite "Devices:" line
24) staging: comedi: ni_65xx: rewrite "Devices:" line
25) staging: comedi: ni_65xx: use board names on "Devices:" line
26) staging: comedi: ni_at_ao: rewrite "Devices:" line
27) staging: comedi: ni_labpc: rewrite "Devices:" line
28) staging: comedi: ni_labpc_pci: rewrite "Devices:" line
29) staging: comedi: ni_tio: change comedi "driver" comment to "module"
30) staging: comedi: ni_tiocmd: change comedi "driver" comment to
    "module"
31) staging: comedi: pcl711: rewrite "Devices:" line
32) staging: comedi: pcl724: rewrite "Devices:" line
33) staging: comedi: pcl726: rewrite "Devices:" line
34) staging: comedi: pcl730: rewrite "Devices:" line
35) staging: comedi: pcmad: rewrite "Devices:" line
36) staging: comedi: pcmda12: rewrite "Devices:" line
37) staging: comedi: pcmmio: rewrite "Devices:" line
38) staging: comedi: pcmuio: rewrite "Devices:" line
39) staging: comedi: rtd520: rewrite "Devices:" line
40) staging: comedi: rti800: rewrite "Devices:" line
41) staging: comedi: rti802: rewrite "Devices:" line
42) staging: comedi: usbdux: rewrite "Devices:" line
43) staging: comedi: usbduxfast: rewrite "Devices:" line
44) staging: comedi: usbduxsigma: rewrite "Devices:" line
45) staging: comedi: vm80xx: rewrite comedi driver comment block

 drivers/staging/comedi/drivers/8255_pci.c       | 65 +++++++++++++++----------
 drivers/staging/comedi/drivers/adl_pci6208.c    |  3 +-
 drivers/staging/comedi/drivers/adl_pci7x3x.c    | 62 +++++++++++------------
 drivers/staging/comedi/drivers/adl_pci8164.c    |  2 +-
 drivers/staging/comedi/drivers/adv_pci1723.c    |  2 +-
 drivers/staging/comedi/drivers/adv_pci1724.c    |  2 +-
 drivers/staging/comedi/drivers/c6xdigio.c       |  2 +-
 drivers/staging/comedi/drivers/cb_pcidda.c      | 10 ++--
 drivers/staging/comedi/drivers/comedi_parport.c |  2 +-
 drivers/staging/comedi/drivers/dac02.c          |  2 +-
 drivers/staging/comedi/drivers/das08.c          | 17 +------
 drivers/staging/comedi/drivers/das08_isa.c      | 18 +++----
 drivers/staging/comedi/drivers/das08_pci.c      |  2 +-
 drivers/staging/comedi/drivers/das16.c          | 33 +++++--------
 drivers/staging/comedi/drivers/das6402.c        |  4 +-
 drivers/staging/comedi/drivers/dmm32at.c        |  2 +-
 drivers/staging/comedi/drivers/dt282x.c         | 22 +++------
 drivers/staging/comedi/drivers/dyna_pci10xx.c   | 35 +++++++------
 drivers/staging/comedi/drivers/ii_pci20kc.c     |  2 +-
 drivers/staging/comedi/drivers/ke_counter.c     |  2 +-
 drivers/staging/comedi/drivers/me_daq.c         |  3 +-
 drivers/staging/comedi/drivers/mf6x4.c          |  2 +-
 drivers/staging/comedi/drivers/ni_6527.c        |  3 +-
 drivers/staging/comedi/drivers/ni_65xx.c        | 30 +++---------
 drivers/staging/comedi/drivers/ni_at_ao.c       |  3 +-
 drivers/staging/comedi/drivers/ni_labpc.c       |  5 +-
 drivers/staging/comedi/drivers/ni_labpc_pci.c   |  2 +-
 drivers/staging/comedi/drivers/ni_tio.c         | 43 ++++++++--------
 drivers/staging/comedi/drivers/ni_tiocmd.c      | 43 ++++++++--------
 drivers/staging/comedi/drivers/pcl711.c         |  6 +--
 drivers/staging/comedi/drivers/pcl724.c         | 12 ++---
 drivers/staging/comedi/drivers/pcl726.c         |  7 +--
 drivers/staging/comedi/drivers/pcl730.c         | 19 +++-----
 drivers/staging/comedi/drivers/pcmad.c          |  3 +-
 drivers/staging/comedi/drivers/pcmda12.c        |  2 +-
 drivers/staging/comedi/drivers/pcmmio.c         |  2 +-
 drivers/staging/comedi/drivers/pcmuio.c         |  3 +-
 drivers/staging/comedi/drivers/rtd520.c         |  6 +--
 drivers/staging/comedi/drivers/rti800.c         |  3 +-
 drivers/staging/comedi/drivers/rti802.c         |  2 +-
 drivers/staging/comedi/drivers/usbdux.c         |  3 +-
 drivers/staging/comedi/drivers/usbduxfast.c     |  2 +-
 drivers/staging/comedi/drivers/usbduxsigma.c    |  2 +-
 drivers/staging/comedi/drivers/vmk80xx.c        | 31 ++++++------
 44 files changed, 224 insertions(+), 302 deletions(-)
