Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758947AbbA0RtZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 12:49:25 -0500
Received: from smtp121.iad3a.emailsrvr.com ([173.203.187.121]:51494 "EHLO
	smtp121.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754074AbbA0RtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 12:49:23 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/9] staging: comedi: introduce comedi_usb.h header
Date: Tue, 27 Jan 2015 17:49:00 +0000
Message-Id: <1422380949-5994-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"comedidev.h" includes USB-specific stuff that gets included by all
comedi drivers including non-USB ones.  Separate it out into its own
header "comedi_usb.h".  Make the new header include <linux/usb.h> and
"comedidev.h" so that comedi USB drivers do not need to include them
explicitly.

1) staging: comedi: add comedi_usb.h
2) staging: comedi: comedi_usb.c: include new "comedi_usb.h" header
3) staging: comedi: dt9812: include new "comedi_usb.h" header
4) staging: comedi: ni_usb6501: include new "comedi_usb.h" header
5) staging: comedi: usbdux: include new "comedi_usb.h" header
6) staging: comedi: usbduxfast: include new "comedi_usb.h" header
7) staging: comedi: usbduxsigma: include new "comedi_usb.h" header
8) staging: comedi: vmk80xx: include new "comedi_usb.h" header
9) staging: comedi: comedi_usb.h: move USB stuff out of comedidev.h

 drivers/staging/comedi/comedi_usb.c          |  3 +-
 drivers/staging/comedi/comedi_usb.h          | 50 ++++++++++++++++++++++++++++
 drivers/staging/comedi/comedidev.h           | 29 ----------------
 drivers/staging/comedi/drivers/dt9812.c      |  3 +-
 drivers/staging/comedi/drivers/ni_usb6501.c  |  3 +-
 drivers/staging/comedi/drivers/usbdux.c      |  3 +-
 drivers/staging/comedi/drivers/usbduxfast.c  |  3 +-
 drivers/staging/comedi/drivers/usbduxsigma.c |  3 +-
 drivers/staging/comedi/drivers/vmk80xx.c     |  3 +-
 9 files changed, 57 insertions(+), 43 deletions(-)
