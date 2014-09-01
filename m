Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbaIALER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:04:17 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:38972 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241AbaIALEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:04:15 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 00/28] staging: comedi: more clean-up and remove legacy attach
Date: Mon,  1 Sep 2014 12:03:32 +0100
Message-Id: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Continue to clean up the amplc_pci230 driver code and remove the legacy
attach mechanism, since it isn't very useful for this driver (see PATCH
05/28).

01) staging: comedi: amplc_pci230: update MODULE_DESCRIPTION()
02) staging: comedi: amplc_pci230: don't use multiple blank lines
03) staging: comedi: amplc_pci230: remove some unnecessary parentheses
04) staging: comedi: amplc_pci230: collapse some 'else { if' chains
05) staging: comedi: amplc_pci230: remove "legacy" attach mechanism
06) staging: comedi: amplc_pci230: no need to manipulate PCI ref count
07) staging: comedi: amplc_pci230: set detach handler to
    comedi_pci_detach()
08) staging: comedi: amplc_pci230: absorb pci230_attach_common()
09) staging: comedi: amplc_pci230: no need to comedi_set_hw_dev() here
10) staging: comedi: amplc_pci230: absorb pci230_alloc_private()
11) staging: comedi: amplc_pci230: remove ai_chans member
12) staging: comedi: amplc_pci230: remove ao_chans member
13) staging: comedi: amplc_pci230: shrink struct pci230_board
14) staging: comedi: amplc_pci230: simplify pci230_ao_mangle_datum()
15) staging: comedi: amplc_pci230: simplify pci230_ai_read()
16) staging: comedi: amplc_pci230: remove 'inline'
17) staging: comedi: amplc_pci230: rename pci230_ai_rinsn()
18) staging: comedi: amplc_pci230: add `pci230_` prefix to functions
19) staging: comedi: amplc_pci230: use comedi_range_is_bipolar()
20) staging: comedi: amplc_pci230: make `intr_running` a bitfield
21) staging: comedi: amplc_pci230: replace `state` member with bitfields
22) staging: comedi: amplc_pci230: rewrite shared resource handling
23) staging: comedi: amplc_pci230: reduce indentation in
    pci230_ao_inttrig_scan_begin()
24) staging: comedi: amplc_pci230: reduce indentation in
    pci230_ao_start()
25) staging: comedi: amplc_pci230: reduce indentation in
    pci230_ai_inttrig_convert()
26) staging: comedi: amplc_pci230: reduce indentation in
    pci230_ai_start()
27) staging: comedi: amplc_pci230: change pci230_handle_ao_fifo() return
    type
28) staging: comedi: amplc_pci230: simplify interrupt enable handling

 drivers/staging/comedi/drivers/amplc_pci230.c | 977 ++++++++++----------------
 1 file changed, 384 insertions(+), 593 deletions(-)
