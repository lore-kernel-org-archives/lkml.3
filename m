Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476AbaICMqO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:46:14 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:44653 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932288AbaICMqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:46:13 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 00/37] staging: comedi: rename command flags for consistency
Date: Wed,  3 Sep 2014 13:45:23 +0100
Message-Id: <1409748360-17063-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The various macros in "comedi.h" used to construct values for the
`flags` member of `struct comedi_cmd` are named inconsistently.  Some of
the macros with the `TRIG_` prefix are from a long defunct Comedi
trigger interface that was replaced with the current Comedi asynchronous
command interface many years ago, co-opting most of the `TRIG_` macros
in the process.  Some of them are still used with various other members
of `struct comedi_cmd` to select trigger sources.  Others are used with
the `flags` member.  There are other macros for use with the command
`flags` member using the prefix `CMDF_`, and some of the old `TRIG_`
macros have been renamed already, keeping the old names around as
synonyms for backwards compatibility.

For consistency, rename the `TRIG_` prefixed macros used with the
command `flags` member to use the prefix `CMDF_` and redefine the
renamed macros as synonyms for backwards compatibilty.

There are still some left-over `TRIG_` macros unused by the Comedi
kernel code, but the user-space Comedilib library may still be trying to
use them, so hang onto them for now.

01) staging: comedi: comedi_test: use CMDF_PRIORITY
02) staging: comedi: das16: use CMDF_PRIORITY
03) staging: comedi: das1800: use CMDF_PRIORITY
04) staging: comedi: ni_at_a2150: use CMDF_PRIORITY
05) staging: comedi: ni_labpc_common: use CMDF_PRIORITY
06) staging: comedi: add CMDF_WAKE_EOS as synonym for TRIG_WAKE_EOS
07) staging: comedi: use CMDF_WAKE_EOS in do_cmd_ioctl()
08) staging: comedi: addi_apci_3120: use CMDF_WAKE_EOS
09) staging: comedi: adl_pci9118: use CMDF_WAKE_EOS
10) staging: comedi: adv_pci1710: use CMDF_WAKE_EOS
11) staging: comedi: amplc_pci230: use CMDF_WAKE_EOS
12) staging: comedi: cb_pcidas: use CMDF_WAKE_EOS
13) staging: comedi: cb_pcidas64: use CMDF_WAKE_EOS
14) staging: comedi: das1800: use CMDF_WAKE_EOS
15) staging: comedi: ni_labpc_common: use CMDF_WAKE_EOS
16) staging: comedi: ni_mio_common: use CMDF_WAKE_EOS
17) staging: comedi: ni_tiocmd: use CMDF_WAKE_EOS
18) staging: comedi: pcl812: use CMDF_WAKE_EOS
19) staging: comedi: rtd520: use CMDF_WAKE_EOS
20) staging: comedi: add CMDF_BOGUS as synonym for TRIG_BOGUS
21) staging: comedi: use CMDF_BOGUS in do_cmd_ioctl()
22) staging: comedi: add CMDF_ROUND_... as synonyms for TRIG_ROUND_...
23) staging: comedi: 8253.h: use CMDF_ROUND_...
24) staging: comedi: addi_apci_3xxx: use CMDF_ROUND_...
25) staging: comedi: adl_pci9118: use CMDF_ROUND_...
26) staging: comedi: amplc_pci230: use CMDF_ROUND_...
27) staging: comedi: cb_pcidas64: use CMDF_ROUND_...
28) staging: comedi: das1800: use CMDF_ROUND_...
29) staging: comedi: dt282x: use CMDF_ROUND_...
30) staging: comedi: dt3000: use CMDF_ROUND_...
31) staging: comedi: me4000: use CMDF_ROUND_...
32) staging: comedi: ni_at_a2150: use CMDF_ROUND_...
33) staging: comedi: ni_labpc_common: use CMDF_ROUND_...
34) staging: comedi: ni_mio_common: use CMDF_ROUND_...
35) staging: comedi: ni_pcidio: use CMDF_ROUND_...
36) staging: comedi: rtd520: use CMDF_ROUND_...
37) staging: comedi: s626: use CMDF_ROUND_...

 drivers/staging/comedi/comedi.h                    | 32 +++++++++++------
 drivers/staging/comedi/comedi_fops.c               |  4 +--
 drivers/staging/comedi/drivers/8253.h              |  8 ++---
 .../comedi/drivers/addi-data/hwdrv_apci3120.c      |  4 +--
 drivers/staging/comedi/drivers/addi_apci_3xxx.c    |  8 ++---
 drivers/staging/comedi/drivers/adl_pci9118.c       | 26 +++++++-------
 drivers/staging/comedi/drivers/adv_pci1710.c       |  4 +--
 drivers/staging/comedi/drivers/amplc_pci230.c      | 14 ++++----
 drivers/staging/comedi/drivers/cb_pcidas.c         |  2 +-
 drivers/staging/comedi/drivers/cb_pcidas64.c       | 18 +++++-----
 drivers/staging/comedi/drivers/comedi_test.c       |  2 +-
 drivers/staging/comedi/drivers/das16.c             |  4 +--
 drivers/staging/comedi/drivers/das1800.c           | 16 ++++-----
 drivers/staging/comedi/drivers/dt282x.c            |  8 ++---
 drivers/staging/comedi/drivers/dt3000.c            |  8 ++---
 drivers/staging/comedi/drivers/me4000.c            | 14 ++++----
 drivers/staging/comedi/drivers/ni_at_a2150.c       | 12 +++----
 drivers/staging/comedi/drivers/ni_labpc_common.c   | 14 ++++----
 drivers/staging/comedi/drivers/ni_mio_common.c     | 40 +++++++++++-----------
 drivers/staging/comedi/drivers/ni_pcidio.c         | 10 +++---
 drivers/staging/comedi/drivers/ni_tiocmd.c         |  2 +-
 drivers/staging/comedi/drivers/pcl812.c            |  2 +-
 drivers/staging/comedi/drivers/rtd520.c            | 30 ++++++++--------
 drivers/staging/comedi/drivers/s626.c              |  8 ++---
 24 files changed, 150 insertions(+), 140 deletions(-)
