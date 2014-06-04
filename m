Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407AbaFDCcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 22:32:19 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:39922 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbaFDCcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 22:32:18 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH v2 0/5] staging: comedi: addi_apci_1564: fix Change-of-State interrupt functionality
Date: Tue,  3 Jun 2014 21:32:04 -0500
Message-Id: <1401849124-21347-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 1.9.3
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

