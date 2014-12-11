Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965658AbaLKXbX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 18:31:23 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:62703 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758330AbaLKXbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 18:31:21 -0500
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Johan Hovold <johan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeremiah Mahler <jmmahler@gmail.com>
Subject: [PATCH 0/2] usb: serial: handle -ENODEV and -EPROTO quietly
Date: Thu, 11 Dec 2014 15:29:52 -0800
Message-Id: <1418340594-30469-1-git-send-email-jmmahler@gmail.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a USB serial device (e.g. /dev/ttyUSB0) with an active program is
unplugged, a bunch of -ENODEV and -EPROTO errors will be produced in the
logs.  This patch set quiets these messages without changing the
original behavior.

This change is beneficial when using daemons such as slcand, which is
similar to pppd or slip, that cannot determine whether they should exit
until after the USB serial device is unplugged.  Producing these error
messages for a normal use case is not helpful.

Jeremiah Mahler (2):
  usb: serial: handle -EPROTO quietly in generic_read_bulk
  usb: serial: handle -ENODEV quietly in generic_submit_read_urb

 drivers/usb/serial/generic.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

-- 
2.1.3

