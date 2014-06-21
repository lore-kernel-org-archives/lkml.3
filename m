Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163AbaFUWYa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 18:24:30 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:38643 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbaFUWY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 18:24:29 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH v3 0/5] staging: comedi: addi_apci_1564: fix Change-of-State interrupt functionality
Date: Sat, 21 Jun 2014 17:23:49 -0500
Message-Id: <1403389429-19793-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset introduces a new private data struct for this driver, adds
all of the code required to support Change-of-State interrupts for the
digital input subdevice, and finally fixes
apci1564_interrupt() to service this type of interrupt correctly.

CHANGES FROM v1:
*leave the send_sig() calls in for now, until the proper replacement can
be implemented.
*removed unused static globals, removed the remaining one into the private
data struct.
*private data struct moved into addi_apci_1564.c.
*patches 4/6 and 5/6 from v1 have been merged into patch 4/5 here.
*(*cancel) for the interrupt subdevice has been reduced to just disable DI
interrupts rather than using the board's reset function.
*support for all interrupts issued by the board has been kept in
apci1564_interrupt(), rather than stripping everything out except for DI
interrupt support.  However, DI interrupt support has still been fixed.

CHANGES FROM v2:
*Just refreshed set against staging-next.  Otherwise everything is
exactly the same, and should apply now.

Chase Southwood (5):
  staging: comedi: addi_apci_1564: remove use of
    devpriv->b_OutputMemoryStatus
  staging: comedi: addi_apci_1564: remove unused static variables
  staging: comedi: addi_apci_1564: introduce apci1564_private struct
  staging: comedi: addi_apci_1564: add Change-of-State interrupt
    subdevice and required functions
  staging: comedi: addi_apci_1564: move apci1564_interrupt() into
    addi_apci_1564.c

 .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 304 +++------------
 drivers/staging/comedi/drivers/addi_apci_1564.c    | 433 +++++++++++++++++++--
 2 files changed, 454 insertions(+), 283 deletions(-)

-- 
1.9.3

