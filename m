Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533AbaJaRsB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 13:48:01 -0400
Received: from smtp113.iad3a.emailsrvr.com ([173.203.187.113]:40864 "EHLO
	smtp113.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757301AbaJaRr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 13:47:59 -0400
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] staging: comedi: split bus support into separate modules
Date: Fri, 31 Oct 2014 17:47:34 +0000
Message-Id: <1414777659-25578-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Comedi core module doesn't need support for PCI, USB or PCMCIA.
Only the low-level Comedi drivers need it.  Split the support for these
bus types out of the core "comedi" module and into new modules,
"comedi_pci", "comedi_usb", and "comedi_pcmcia".

1) staging: comedi: comedidev.h: remove dummy PCI support functions
2) staging: comedi: comedidev.h: remove some #ifdefs
3) staging: comedi: split out PCMCIA support into new module
4) staging: comedi: split out USB support into new module
5) staging: comedi: split out PCI support into new module

 drivers/staging/comedi/Kconfig         | 15 +++++++++++---
 drivers/staging/comedi/Makefile        |  7 ++++---
 drivers/staging/comedi/comedi_pci.c    | 16 ++++++++++++++
 drivers/staging/comedi/comedi_pcmcia.c | 16 ++++++++++++++
 drivers/staging/comedi/comedi_usb.c    | 16 ++++++++++++++
 drivers/staging/comedi/comedidev.h     | 38 ----------------------------------
 6 files changed, 64 insertions(+), 44 deletions(-)
