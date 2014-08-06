Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbaHFIkx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 04:40:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753951AbaHFIkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 04:40:51 -0400
Date: Wed, 6 Aug 2014 16:39:27 +0800
From: Dave Young <dyoung@redhat.com>
To: a.zummo@towertech.it, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, msalter@redhat.com
Subject: [PATCH 2/2] efi_rtc: probe function error out in case no efi runtime
 enabled
Message-ID: <20140806083927.GA31721@dhcp-16-198.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


efi rtc depends on efi runtime services, so if efi runtime services are not
usable it should error out.

Without this patch rtc-efi will panic with 'noefi' boot

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 drivers/rtc/rtc-efi.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6/drivers/rtc/rtc-efi.c
===================================================================
--- linux-2.6.orig/drivers/rtc/rtc-efi.c
+++ linux-2.6/drivers/rtc/rtc-efi.c
@@ -191,6 +191,9 @@ static int __init efi_rtc_probe(struct p
 {
 	struct rtc_device *rtc;
 
+	if (!efi_enabled(EFI_RUNTIME_SERVICES))
+		return -ENODEV;
+
 	rtc = devm_rtc_device_register(&dev->dev, "rtc-efi", &efi_rtc_ops,
 					THIS_MODULE);
 	if (IS_ERR(rtc))
