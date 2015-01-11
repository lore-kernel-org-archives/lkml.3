Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089AbbAKApO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 19:45:14 -0500
Received: from mail-yh0-f45.google.com ([209.85.213.45]:47283 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbbAKApM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 19:45:12 -0500
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Johan Hovold <johan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Jeremiah Mahler <jmmahler@gmail.com>
Subject: [RESEND PATCH v2 0/2] usb: serial: handle -ENODEV and -EPROTO quietly
Date: Sat, 10 Jan 2015 16:44:31 -0800
Message-Id: <1420937073-20835-1-git-send-email-jmmahler@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1419066698-2684-1-git-send-email-jmmahler@gmail.com>
References: <1419066698-2684-1-git-send-email-jmmahler@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Jan 15) Just a resend of v2 [1].

  [1]: https://lkml.org/lkml/2014/12/20/16

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

 drivers/usb/serial/generic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
2.1.4

