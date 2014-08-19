Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbaHSPGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 11:06:53 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:58336 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbaHSPGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 11:06:52 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] staging: comedi: ni_labpc: split module in two
Date: Tue, 19 Aug 2014 16:06:27 +0100
Message-Id: <1408460793-29793-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "ni_labpc" module is a Comedi driver for the National Instruments
Lab-PC series of ISA data acquistion boards, and also provides common
code for the "ni_labpc_pci" and "ni_labpci_cs" modules (for PCI boards
and PCMCIA cards).

Split out the common code into a new module "ni_labpc_common", leaving
the driver for the ISA boards in the existing "ni_labpc" module.  This
removes the C preprocessor conditional directives from the resulting
".c" files.

The split is done in patch 6.  The preceding patches are just to tidy up
the source a bit before the split.

Please ignore the checkpatch warning from patch 6:

WARNING: added, moved or deleted file(s), does MAINTAINERS need
updating?

1) staging: comedi: ni_labpc: remove unnecessary braces in
   labpc_common_attach()
2) staging: comedi: ni_labpc: use braces on all arms of `if` statement
3) staging: comedi: ni_labpc: Alignment should match open parenthesis
4) staging: comedi: ni_labpc: Logical continuations should be on the
   previous line
5) staging: comedi: ni_labpc: break lines after operators
6) staging: comedi: ni_labpc: split common code to ni_labpc_common

 drivers/staging/comedi/drivers/Makefile          |    3 +-
 drivers/staging/comedi/drivers/ni_labpc.c        | 1364 +--------------------
 drivers/staging/comedi/drivers/ni_labpc_common.c | 1387 ++++++++++++++++++++++
 3 files changed, 1390 insertions(+), 1364 deletions(-)
