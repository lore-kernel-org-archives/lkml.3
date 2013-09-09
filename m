Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab3IIQIo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:08:44 -0400
Received: from briaree.onecert.fr ([134.212.190.4]:50644 "EHLO
	briaree.onecert.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab3IIQIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:08:42 -0400
From: Paul Chavent <Paul.Chavent@onera.fr>
To: linux-usb@vger.kernel.org, gregkh@linuxfoundation.org, jhovold@gmail.com,
        fschaefer.oss@googlemail.com, jslaby@suse.cz, max@suse.de,
        giometti@enneenne.com
Cc: linux-kernel@vger.kernel.org, Paul Chavent <Paul.Chavent@onera.fr>
Subject: [PATCH 0/5] Enable PPS reporting for USB serial devices
Date: Mon,  9 Sep 2013 18:01:15 +0200
Message-Id: <1378742480-2146-1-git-send-email-paul.chavent@onera.fr>
X-Mailer: git-send-email 1.7.12.1
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (briaree.onecert.fr [134.212.190.4]); Mon, 09 Sep 2013 18:08:23 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

This series enable the PPS reporting for USB serial devices.

Patch 01 : change the interface of handle_dcd_change for usb serial in
order to avoid duplicating code when calling this function and to be
closer of the uart handle_dcd_change interface.

Patch 02 : this patch depends on the previous one. It is optional. It
restores the way the tty is retreived : the serial drivers used to
call tty_port_tty_get as opposed to the uart handle_dcd_change
implementation that simply get port->tty. As i don't know wich way you
prefer...

Patch 03 : this patch add the handling of dcd_change in the ftdi
driver.

Patch 04 : this patch add the callback to the line discipline
dcd_change handler.

Patch 05 : this patch is optional. While reading the code i've found
that wake_up_interruptible was often called after status processing
(ch341, 8250, ...). So i suggest to move this one.


This patchset have been tested with a pl2303 device and ftdi
device. These devices coupled to the usb serial stack introduce
latencies. I think that the jitter may depend on devices, and I'm not
even sure it is constant. But the PPS reporting works and allows to
play with it.

Thank for your comments.

Cheers.

Paul.

Paul Chavent (5):
  USB : serial : remove tty arg of handle_dcd_change.
  USB : serial : get protected tty in handle_dcd_change.
  USB : serial : call handle_dcd_change in ftdi driver.
  USB : serial : invoke dcd_change ldisc's handler.
  USB : serial : pl2303 wake up after dcd status check.

 drivers/usb/serial/ch341.c    |  7 ++-----
 drivers/usb/serial/ftdi_sio.c |  5 ++++-
 drivers/usb/serial/generic.c  | 13 +++++++++++--
 drivers/usb/serial/pl2303.c   | 11 +++--------
 include/linux/usb/serial.h    |  1 -
 5 files changed, 20 insertions(+), 17 deletions(-)

-- 
1.7.12.1

