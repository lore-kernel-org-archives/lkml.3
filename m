Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbaE3ElQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 00:41:16 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:60849 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbaE3ElP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 00:41:15 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 0/6] staging: comedi: addi_apci_1564: fix Change-of-State interrupt functionality.
Date: Thu, 29 May 2014 23:40:53 -0500
Message-Id: <1401424853-21683-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset introduces a new private data struct for this driver, adds
all of the code required to support Change-of-State interrupts for the
digital input subsystem, and finally focuses and fixes
apci1564_interrupt() to service this type of interrupt correctly.

Chase Southwood (6):
  staging: comedi: addi_apci_1564: remove send_sig() use
  staging: comedi: addi_apci_1564: remove use of
    devpriv->b_OutputMemoryStatus
  staging: comedi: addi_apci_1564: introduce apci1564_private struct
  staging: comedi: addi_apci_1564: add a subdevice for Change-of-State
    interrupt support
  staging: comedi: addi_apci_1564: hook-up the interrupt subdevice
  staging: comedi: addi_apci_1564: cleanup v_ADDI_Interrupt()

 .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 295 ++++-----------------
 drivers/staging/comedi/drivers/addi_apci_1564.c    | 294 +++++++++++++++++---
 2 files changed, 316 insertions(+), 273 deletions(-)

-- 
1.9.3

