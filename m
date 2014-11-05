Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbaKEBTZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 20:19:25 -0500
Received: from mail-ig0-f179.google.com ([209.85.213.179]:55604 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbaKEBTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 20:19:24 -0500
From: Chris Rorvick <chris@rorvick.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Chris Rorvick <chris@rorvick.com>, Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.de>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH 00/10] Create separate header for ehci-dbgp driver
Date: Tue,  4 Nov 2014 19:18:44 -0600
Message-Id: <1415150334-2402-1-git-send-email-chris@rorvick.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FUSBH200 and FOTG210 are not EHCI-compatible and require standalone
drivers.  See discussion at:

  http://comments.gmane.org/gmane.linux.usb.general/84169

But these controllers do implement an EHCI-compatible debug port and
therefore leverage the ehci-dbgp driver.  Rather than pulling in the
necessary declarations from <linux/usb/ehci_def.h>, each driver copies
this code into their own header.  The goal of this series is to pull the
ehci-dbgp related code into its own header to remove the need for this
redundancy.

Regards,

Chris Rorvick

Chris Rorvick (10):
  usb: Create separate header for ehci-dbgp
  fusbh200: Make Xen notification consistent with EHCI
  fusbh200: Remove superfluous macro definitions
  fusbh200: Remove duplicate ehci-dbgp declarations
  fusbh200: Use ehci_dbg_port struct
  fotg210: Make Xen notification consistent with EHCI
  fotg210: Remove superfluous macro definitions
  fotg210: Remove duplicate ehci-dbgp declarations
  fotg210: Use ehci_dbg_port struct
  usb: Remove __init from early_dbgp_init() prototype

 drivers/usb/host/fotg210.h    | 62 ++------------------------------
 drivers/usb/host/fusbh200.h   | 62 ++------------------------------
 include/linux/usb/ehci-dbgp.h | 83 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/usb/ehci_def.h  | 65 ++-------------------------------
 4 files changed, 91 insertions(+), 181 deletions(-)
 create mode 100644 include/linux/usb/ehci-dbgp.h

-- 
1.9.3

