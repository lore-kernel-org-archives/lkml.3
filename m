Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914AbaLTJMJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 04:12:09 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:37652 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbaLTJME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 04:12:04 -0500
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Johan Hovold <johan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Jeremiah Mahler <jmmahler@gmail.com>
Subject: [PATCH v2 0/2] usb: serial: handle -ENODEV and -EPROTO quietly
Date: Sat, 20 Dec 2014 01:11:36 -0800
Message-Id: <1419066698-2684-1-git-send-email-jmmahler@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418340594-30469-1-git-send-email-jmmahler@gmail.com>
References: <1418340594-30469-1-git-send-email-jmmahler@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NOTE: These patches can wait until after the merge window.  I just
wanted this slightly improved version to be available when the window
does close.

If a USB serial device (e.g. /dev/ttyUSB0) with an active program is
unplugged, a bunch of -ENODEV and -EPROTO errors will be produced in the
logs.  This patch set quiets these messages without changing the
original behavior.

This change is beneficial when using daemons such as slcand, which is
similar to pppd or slip, that cannot determine whether they should exit
until after the USB serial device is unplugged.  Producing these error
messages for a normal use case is not helpful.

Changes in v2:
  - Instead of handling -EPROTO specially, use dev_dbg instead of
    dev_err like other drivers do.

Jeremiah Mahler (2):
  usb: serial: handle -EPROTO quietly in generic_read_bulk
  usb: serial: handle -ENODEV quietly in generic_submit_read_urb

 drivers/usb/serial/generic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
2.1.3

