Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699Ab3G3TRh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 15:17:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46038 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab3G3TRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 15:17:36 -0400
Date: Tue, 30 Jul 2013 12:17:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 3.11-rc4
Message-ID: <20130730191735.GA26504@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 2c7b871b9102c497ba8f972aa5d38532f05b654d:

  usb: Clear both buffers when clearing a control transfer TT buffer. (2013-07-25 11:37:13 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.11-rc4

for you to fetch changes up to fed1f1ed90bce42ea010e2904cbc04e7b8304940:

  USB: serial: ftdi_sio: add more RT Systems ftdi devices (2013-07-29 13:38:38 -0700)

----------------------------------------------------------------
USB fixes for 3.11-rc4

Here are some tiny USB fixes for 3.11-rc4

Nothing major, some gadget fixes, some new device ids, a new tiny driver
for the ANT+ USB device, and a number of fixes for the mos7840 driver
that were much needed.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Andrzej Pietrasiewicz (4):
      usb: gadget: ether: put_usb_function on unbind
      usb: gadget: free opts struct on error recovery
      usb: gadget: multi: fix error return code in cdc_do_config()
      usb: gadget: f_phonet: remove unused preprocessor conditional

Fabio Estevam (1):
      usb: chipidea: cast PORTSC_PTS and DEVLC_PTS macros

Greg Kroah-Hartman (2):
      USB: serial: add driver for Suunto ANT+ USB device
      Merge tag 'fixes-for-v3.11-rc3' of git://git.kernel.org/.../balbi/usb into usb-linus

Johan Hovold (4):
      USB: mos7840: fix race in register handling
      USB: mos7840: fix device-type detection
      USB: mos7840: fix race in led handling
      USB: mos7840: fix pointer casts

Kishon Vijay Abraham I (1):
      usb: musb: fix resource passed from glue layer to musb

Peter Chen (1):
      usb: chipidea: fix the build error with randconfig

Rick Farina (Zero_Chaos) (1):
      USB: serial: ftdi_sio: add more RT Systems ftdi devices

Rong Wang (1):
      usb: gadget: udc-core: fix the typo of udc state attribute

 drivers/usb/chipidea/Kconfig      |   4 +-
 drivers/usb/chipidea/bits.h       |   4 +-
 drivers/usb/gadget/ether.c        |  14 +++-
 drivers/usb/gadget/f_phonet.c     |   2 -
 drivers/usb/gadget/multi.c        |  10 +--
 drivers/usb/gadget/udc-core.c     |   2 +-
 drivers/usb/musb/omap2430.c       |   7 +-
 drivers/usb/musb/tusb6010.c       |   7 +-
 drivers/usb/serial/Kconfig        |   7 ++
 drivers/usb/serial/Makefile       |   1 +
 drivers/usb/serial/ftdi_sio.c     |  31 +++++++-
 drivers/usb/serial/ftdi_sio_ids.h |  34 +++++++--
 drivers/usb/serial/mos7840.c      | 150 ++++++++++++++++++++++----------------
 drivers/usb/serial/suunto.c       |  41 +++++++++++
 14 files changed, 223 insertions(+), 91 deletions(-)
 create mode 100644 drivers/usb/serial/suunto.c
