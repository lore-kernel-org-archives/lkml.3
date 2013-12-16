Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab3LPG0G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 01:26:06 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:65398 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336Ab3LPG0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 01:26:04 -0500
MIME-Version: 1.0
From: Sankha Narayan Guria <sankha93@gmail.com>
Date: Mon, 16 Dec 2013 11:55:43 +0530
Message-ID: <CALnup8CU6dSmJJiRzxmH35aQdjVPzsYrfKPqGmZhjLreKSxrTg@mail.gmail.com>
Subject: [PATCH] Remove double initialization of msg_namelen variable
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the double initialization of the msg_namelen variable.

Signed-off-by: Sankha Narayan Guria <sankha93@gmail.com>

--- linux/drivers/staging/usbip/usbip_common.c.orig 2013-12-16
11:24:32.930512781 +0530
+++ linux/drivers/staging/usbip/usbip_common.c 2013-12-16
11:25:03.190513334 +0530
@@ -366,7 +366,6 @@ int usbip_recv(struct socket *sock, void
  msg.msg_namelen = 0;
  msg.msg_control = NULL;
  msg.msg_controllen = 0;
- msg.msg_namelen    = 0;
  msg.msg_flags      = MSG_NOSIGNAL;

  result = kernel_recvmsg(sock, &msg, &iov, 1, size, MSG_WAITALL);
