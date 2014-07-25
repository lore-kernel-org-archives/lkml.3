Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760079AbaGYJFT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 05:05:19 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:41124 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759796AbaGYJFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 05:05:16 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 00/12] staging: comedi: amplc_pc236: remove legacy PCI attach and tidy up
Date: Fri, 25 Jul 2014 10:04:46 +0100
Message-Id: <1406279098-8498-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "amplc_pc236" driver supports both ISA cards (Amplicon PC36AT) and PCI
cards (PCI236).  I plan to split it into separate drivers with a module for
common code, but let's reorganise it a bit first.

The driver still supports manual attachment of PCI devices via the
`COMEDI_DEVCONFIG` ioctl and the comedi driver `attach` hook.  That can go,
though the attach hook is still needed for ISA devices.

01) staging: comedi: amplc_pc236: reformat header comments
02) staging: comedi: amplc_pc236: remove some boilerplate comments
03) staging: comedi: amplc_pc236: remove manual configuration of PCI boards
04) staging: comedi: amplc_pc236: no need to manipulate PCI ref count
05) staging: comedi: amplc_pc236: no need to set hw_dev
06) staging: comedi: amplc_pc236: absorb pc236_pci_common_attach()
07) staging: comedi: amplc_pc236: remove 'model' member
08) staging: comedi: amplc_pc236: split pc236_boards[] into ISA & PCI
09) staging: comedi: amplc_pc236: don't check bus type in attach
10) staging: comedi: amplc_pc236: Simplify PCI board look-up
11) staging: comedi: amplc_pc236: remove PCI device ID macros
12) staging: comedi: amplc_pc236: set board_name before common attach

 drivers/staging/comedi/drivers/amplc_pc236.c | 282 +++++++--------------------
 1 file changed, 74 insertions(+), 208 deletions(-)
