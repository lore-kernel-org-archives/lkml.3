Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab3K0Diw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 22:38:52 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:42297 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574Ab3K0Dis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 22:38:48 -0500
Message-ID: <529569CA.4070708@gmail.com>
Date: Wed, 27 Nov 2013 11:40:58 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: marek.belisko@gmail.com, katjacollier@gmail.com,
        linux@rainbow-software.org, Al Viro <viro@zeniv.linux.org.uk>
CC: rkuo <rkuo@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: [PATCH] drivers: staging: ft1000: ft1000-usb: ft1000_debug.c: check
 return value of get_user() in ft1000_ioctl()
References: <528AEFB7.4060301@gmail.com> <20131125011938.GB18921@codeaurora.org> <5292B845.3010404@gmail.com> <5292B8A0.7020409@gmail.com> <5294255E.7040105@gmail.com>
In-Reply-To: <5294255E.7040105@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_user() may fail and cause 'msgsz' uninitialized, so need give a
check. The related warning (with allmodconfig under hexagon):

    CC [M]  drivers/staging/ft1000/ft1000-usb/ft1000_debug.o
  drivers/staging/ft1000/ft1000-usb/ft1000_debug.c: In function 'ft1000_ioctl':
  include/uapi/linux/swab.h:53:9: warning: 'msgsz' may be used uninitialized in this function [-Wuninitialized]
  drivers/staging/ft1000/ft1000-usb/ft1000_debug.c:533:17: note: 'msgsz' was declared here
 

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_debug.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
index 68a55ce..ffdc7f5 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
@@ -560,6 +560,8 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
 
                 /* Get the length field to see how many bytes to copy */
                 result = get_user(msgsz, (__u16 __user *)argp);
+		if (result)
+			break;
                 msgsz = ntohs(msgsz);
                 /* DEBUG("FT1000:ft1000_ioctl: length of message = %d\n", msgsz); */
 
-- 
1.7.7.6
