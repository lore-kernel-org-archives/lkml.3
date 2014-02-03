Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbaBCCXV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 21:23:21 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:47351 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbaBCCXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 21:23:19 -0500
From: Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
Subject: [RFC PATCH 1/3] epoll: reserve small ioctl() space
Date: Sun,  2 Feb 2014 18:17:10 -0800
Message-Id: <1391393832-8754-2-git-send-email-n1ght.4nd.d4y@gmail.com>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1391393832-8754-1-git-send-email-n1ght.4nd.d4y@gmail.com>
References: <1391393832-8754-1-git-send-email-n1ght.4nd.d4y@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reserve a small ioctl() command space for eventpolls, of which only two
are currently utilized.

Signed-off-by: Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
---
diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index d7e43fa..3c6f8ac 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -81,6 +81,7 @@ Code  Seq#(hex)	Include File		Comments
 0x22	all	scsi/sg.h
 '#'	00-3F	IEEE 1394 Subsystem	Block for the entire subsystem
 '$'	00-0F	linux/perf_counter.h, linux/perf_event.h
+'$'	10-1F	include/uapi/linux/eventpoll.h
 '&'	00-07	drivers/firewire/nosy-user.h
 '1'	00-1F	<linux/timepps.h>	PPS kit from Ulrich Windl
 					<ftp://ftp.de.kernel.org/pub/linux/daemons/ntp/PPS/>
