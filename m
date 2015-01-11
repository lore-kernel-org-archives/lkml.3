Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbbAKNnJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 08:43:09 -0500
Received: from mail-yh0-f51.google.com ([209.85.213.51]:60218 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbbAKNnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 08:43:06 -0500
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Johan Hovold <johan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Jeremiah Mahler <jmmahler@gmail.com>
Subject: [PATCH v3 0/2] usb: serial: silence non-critical unplug read errors
Date: Sun, 11 Jan 2015 05:42:05 -0800
Message-Id: <1420983727-5167-1-git-send-email-jmmahler@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1419066698-2684-1-git-send-email-jmmahler@gmail.com>
References: <1419066698-2684-1-git-send-email-jmmahler@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a USB serial device (e.g. /dev/ttyUSB0) with an active program is
unplugged, a bunch of -ENODEV and -EPROTO errors may be produced in the
logs.  This patch set quiets these messages without changing the
original behavior.

This change is beneficial when using daemons such as slcand, which is
similar to pppd or slip, that cannot determine whether they should exit
until after the USB serial device is unplugged.  Producing these error
messages for a normal use case is not helpful.

Changes in v3:

  - change "will spam" to "might spam" since it is dependent
	upon what host controller and devices are used.

  - fix subject: it is silencing all errors, not just one as in
    previous versions.

Changes in v2:

  - Instead of handling -EPROTO specially, use dev_dbg instead of
    dev_err like other drivers do.

Jeremiah Mahler (2):
  usb: serial: silence all non-critical read errors
  usb: serial: handle -ENODEV quietly in generic_submit_read_urb

 drivers/usb/serial/generic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
2.1.4

