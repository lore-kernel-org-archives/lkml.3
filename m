Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbaH3TEg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 15:04:36 -0400
Received: from cthulhu.worldbroken.com ([173.230.133.178]:34508 "EHLO
	cthulhu.worldbroken.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbaH3TEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 15:04:31 -0400
From: wfp5p@worldbroken.com
To: gregkh@linuxfoundation.org
Cc: cascardo@linux.vnet.ibm.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        lidza.louina@gmail.com, devel@driverdev.osuosl.org
Subject: [PATCH 0/2] Move Digi Neo card support from dgnc to jsm
Date: Sat, 30 Aug 2014 14:54:35 -0400
Message-Id: <1409424877-2304-1-git-send-email-wfp5p@worldbroken.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bill Pemberton <wfp5p@worldbroken.com>

The jsm driver (drivers/tty/serial/jsm) already supports the Digi Neo
cards that dgnc (staging) supports.  In fact, it appears that jsm was
based on dgnc.  The dgnc driver has PCI ids for more cards than jsm,
this patch moves support for all the Neo cards to jsm.

The result of this will be that dgnc will only support the Classic
cards since the jsm driver doesn't support those cards yet.


Bill Pemberton (2):
  jsm: add support for additional Neo cards
  staging: dgnc: remove Neo card ids from device table

 drivers/staging/dgnc/dgnc_driver.c  | 13 -------------
 drivers/tty/serial/jsm/jsm_driver.c | 38 +++++++++++++++++++++++++++++++++----
 include/linux/pci_ids.h             |  8 ++++++++
 3 files changed, 42 insertions(+), 17 deletions(-)

-- 
1.9.3

