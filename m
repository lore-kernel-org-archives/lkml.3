Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934231AbaH0NHY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 09:07:24 -0400
Received: from relay.felk.cvut.cz ([147.32.80.7]:50413 "EHLO
	relay.felk.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933257AbaH0NHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 09:07:20 -0400
From: Michal Sojka <sojka@merica.cz>
To: linux-usb@vger.kernel.org
Cc: Michal Sojka <sojka@merica.cz>, Bryan Wu <cooloney@gmail.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        linux-kernel@vger.kernel.org, michal.vokac@comap.cz
Subject: [PATCH v3 0/2] LED triggers for USB host and device
Date: Wed, 27 Aug 2014 15:03:43 +0200
Message-Id: <1409144625-25274-1-git-send-email-sojka@merica.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <CAK5ve-Jz7=7uZ3_Qg2bAH9BiGRZ36k-Oj9TNZ-_nAvaq6LGbjA@mail.gmail.com>
References: <CAK5ve-Jz7=7uZ3_Qg2bAH9BiGRZ36k-Oj9TNZ-_nAvaq6LGbjA@mail.gmail.com>
X-FELK-MailScanner-Information: 
X-MailScanner-ID: s7RD6RJl068108
X-FELK-MailScanner: Found to be clean
X-FELK-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-0.498, required 6, autolearn=not spam, BAYES_00 -0.50,
	HEADER_FROM_DIFFERENT_DOMAINS 0.00, RP_MATCHES_RCVD 0.00)
X-FELK-MailScanner-From: sojkam1@fel.cvut.cz
X-FELK-MailScanner-Watermark: 1409749589.81673@lDFih+MseTDsbFRoVg8qTQ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds LED triggers for USB host and device. First patch refactors
UDC drivers as requested by Felipe Balbi, second patch adds the LED
triggers.

Changes from v2:
- host/gadget triggers merged to a single file in usb/common/
- udc drivers refactored so that LED trigger works for all of them

Changes from v1:
- Moved from drivers/leds/ to drivers/usb/
- Improved Kconfig help
- Linked with other modules rather than being standalone modules

Michal Sojka (2):
  usb: gadget: Refactor request completion
  usb: Add LED triggers for USB activity

 drivers/usb/Kconfig                     |  11 +++
 drivers/usb/chipidea/udc.c              |   6 +-
 drivers/usb/common/Makefile             |   5 +-
 drivers/usb/common/common.c             | 144 ++++++++++++++++++++++++++++++++
 drivers/usb/common/led.c                |  59 +++++++++++++
 drivers/usb/common/usb-common.c         | 144 --------------------------------
 drivers/usb/core/hcd.c                  |   2 +
 drivers/usb/dwc2/gadget.c               |   6 +-
 drivers/usb/dwc3/gadget.c               |   2 +-
 drivers/usb/gadget/udc/amd5536udc.c     |   2 +-
 drivers/usb/gadget/udc/at91_udc.c       |   2 +-
 drivers/usb/gadget/udc/atmel_usba_udc.c |   4 +-
 drivers/usb/gadget/udc/bcm63xx_udc.c    |   2 +-
 drivers/usb/gadget/udc/dummy_hcd.c      |  10 +--
 drivers/usb/gadget/udc/fotg210-udc.c    |   2 +-
 drivers/usb/gadget/udc/fsl_qe_udc.c     |   6 +-
 drivers/usb/gadget/udc/fsl_udc_core.c   |   6 +-
 drivers/usb/gadget/udc/fusb300_udc.c    |   2 +-
 drivers/usb/gadget/udc/goku_udc.c       |   2 +-
 drivers/usb/gadget/udc/gr_udc.c         |   2 +-
 drivers/usb/gadget/udc/lpc32xx_udc.c    |   2 +-
 drivers/usb/gadget/udc/m66592-udc.c     |   2 +-
 drivers/usb/gadget/udc/mv_u3d_core.c    |   8 +-
 drivers/usb/gadget/udc/mv_udc_core.c    |   8 +-
 drivers/usb/gadget/udc/net2272.c        |   2 +-
 drivers/usb/gadget/udc/net2280.c        |   2 +-
 drivers/usb/gadget/udc/omap_udc.c       |   2 +-
 drivers/usb/gadget/udc/pch_udc.c        |   2 +-
 drivers/usb/gadget/udc/pxa25x_udc.c     |   2 +-
 drivers/usb/gadget/udc/pxa27x_udc.c     |   2 +-
 drivers/usb/gadget/udc/r8a66597-udc.c   |   2 +-
 drivers/usb/gadget/udc/s3c-hsudc.c      |   3 +-
 drivers/usb/gadget/udc/s3c2410_udc.c    |   2 +-
 drivers/usb/gadget/udc/udc-core.c       |  13 +++
 drivers/usb/musb/musb_gadget.c          |   2 +-
 drivers/usb/renesas_usbhs/mod_gadget.c  |   2 +-
 include/linux/usb.h                     |  12 +++
 include/linux/usb/gadget.h              |   8 ++
 38 files changed, 294 insertions(+), 201 deletions(-)
 create mode 100644 drivers/usb/common/common.c
 create mode 100644 drivers/usb/common/led.c
 delete mode 100644 drivers/usb/common/usb-common.c

-- 
2.1.0

