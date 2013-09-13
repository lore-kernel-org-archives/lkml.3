Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503Ab3IMPlm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 11:41:42 -0400
Received: from briaree.onecert.fr ([134.212.190.4]:37392 "EHLO
	briaree.onecert.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032Ab3IMPlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 11:41:40 -0400
From: Paul Chavent <Paul.Chavent@onera.fr>
To: linux-usb@vger.kernel.org, gregkh@linuxfoundation.org, jhovold@gmail.com,
        fschaefer.oss@googlemail.com, jslaby@suse.cz, max@suse.de,
        giometti@enneenne.com
Cc: linux-kernel@vger.kernel.org, Paul Chavent <Paul.Chavent@onera.fr>
Subject: [PATCH 0/3] Enable PPS reporting for USB serial devices V2
Date: Fri, 13 Sep 2013 17:35:10 +0200
Message-Id: <1379086513-2434-1-git-send-email-paul.chavent@onera.fr>
X-Mailer: git-send-email 1.7.12.1
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (briaree.onecert.fr [134.212.190.4]); Fri, 13 Sep 2013 17:41:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

This series enable the PPS reporting for USB serial devices (second
submission).

As opposed to the previous one this patch doesn't change the
usb_serial_handle_dcd_change interface, and only add the minimum of
code in order to enable the PPS over USB serial devices. It also add
some comments in the PPS documentation to warn about the unprecision
of this solution.

Patch 01 : call dcd_change handler in the ftdi driver.

Patch 02 : add the callback to the line discipline dcd_change handler.

Patch 03 : this patch is optional. While reading the code i've found
that wake_up_interruptible was often called after status processing
(ch341, 8250, ...). So i suggest to move this one.

Thank for your comments.

Regards.

Paul.

Paul Chavent (3):
  USB : serial : call handle_dcd_change in ftdi driver.
  USB : serial : invoke dcd_change ldisc's handler.
  USB : serial : pl2303 wake up after dcd status check.

 Documentation/pps/pps.txt     | 15 +++++++++++++++
 drivers/usb/serial/ftdi_sio.c |  8 +++++++-
 drivers/usb/serial/generic.c  |  9 +++++++++
 drivers/usb/serial/pl2303.c   | 17 +++++++++--------
 4 files changed, 40 insertions(+), 9 deletions(-)

-- 
1.7.12.1

