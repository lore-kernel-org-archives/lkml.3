Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbaKDSJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 13:09:20 -0500
Received: from smtp113.iad3a.emailsrvr.com ([173.203.187.113]:58501 "EHLO
	smtp113.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751848AbaKDSJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 13:09:19 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] staging: comedi: per-file read/write subdevice choice
Date: Tue,  4 Nov 2014 18:08:59 +0000
Message-Id: <1415124541-13648-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches adds a couple of ioctl codes to the Comedi core
to allow the current "read" and "write" subdevice to be changed after
opening the comedi device.  The current read and write subdevice
information is stored in file private data allocated for the lifetime of
the file object, so the notion of current "read" and "write" subdevice
is local to the file object and does not alter anything in the main
control structure for the comedi device.  An extra level of indirection
is now required to access the main control structure.

I've tested the multiple "read" subdevice case using a modified version
of the "comedi_test" module (modifying it to clone the existing AI
subdevice), and a modified version of the "comedi_test" application
(part of the "comedilib" installation) modified to use the new ioctls.
There isn't any support in comedilib itself yet.

1) staging: comedi: prepare support for per-file read and write
   subdevices
2) staging: comedi: add ioctls to set per-file read and write subdevice

 drivers/staging/comedi/comedi.h          |   2 +
 drivers/staging/comedi/comedi_compat32.c |   2 +
 drivers/staging/comedi/comedi_fops.c     | 217 +++++++++++++++++++++++++++----
 3 files changed, 196 insertions(+), 25 deletions(-)
