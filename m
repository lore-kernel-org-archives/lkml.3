Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420AbaGaNsJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 09:48:09 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:57834 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbaGaNsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:48:07 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 00/18] staging: comedi: amplc_pci224: remove legacy stuff
Date: Thu, 31 Jul 2014 14:47:37 +0100
Message-Id: <1406814475-5923-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "amplc_pci224" driver retains a "legacy" attach mechanism via the
`COMEDI_DEVCONFIG` ioctl and the comedi driver "attach" hook, but
usually attaches PCI devices automatically via the comedi driver's
"auto_attach" hook.  The legacy mechanism is only retained so that
options can be passed via the ioctl to indicate how some hardware
jumpers are set on the boards, which is used to set up the range tables.
That's no use if the PCI device is attached automatically as the range
tables will be set up according to the factory default jumper positions.

Change the range tables to include all possible ranges, regardless of
jumper positions.  Then there is no need to have options to control
setting up the range tables and the "legacy" attach mechanism can be
removed.

Also, tidy the code up a bit.

01) staging: comedi: amplc_pci224: reformat some comments
02) staging: comedi: amplc_pci224: fix checkpatch line over 80
    characters
03) staging: comedi: amplc_pci224: blank lines aren't necessary before a
    close brace '}'
04) staging: comedi: amplc_pci224: multiple assignments should be
    avoided
05) staging: comedi: amplc_pci224: fix spinlock_t definition without
    comment
06) staging: comedi: amplc_pci224: add whitespace to pci224_boards[]
07) staging: comedi: amplc_pci224: set a more descriptive
    MODULE_DESCRIPTION()
08) staging: comedi: amplc_pci224: omit '!= 0' from logical expressions
09) staging: comedi: amplc_pci224: remove some unnecessary parentheses
10) staging: comedi: amplc_pci224: reduce leading whitespace in a few
    places
11) staging: comedi: amplc_pci224: no need for '&function'
12) staging: comedi: amplc_pci224: remove options to select output
    ranges
13) staging: comedi: amplc_pci224: remove "legacy" attach mechanism
14) staging: comedi: amplc_pci224: no need to manipulate PCI ref count
15) staging: comedi: amplc_pci224: put board indices in PCI driver_data
16) staging: comedi: amplc_pci224: remove PCI_DEVICE_ID_... macros
17) staging: comedi: amplc_pci224: absorb pci224_attach_common()
18) staging: comedi: amplc_pci224: no need to comedi_set_hw_dev() here

 drivers/staging/comedi/drivers/amplc_pci224.c | 661 ++++++++++----------------
 1 file changed, 254 insertions(+), 407 deletions(-)
