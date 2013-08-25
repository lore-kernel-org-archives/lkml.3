Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab3HYHF5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 03:05:57 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:41262 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab3HYHFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 03:05:55 -0400
X-SENDER-IP: [85.230.171.181]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkBDAHusGVJV5qu1PGdsb2JhbABZgweDRIUjuDGBGRcDAQEBATg1giQBAQQBOhwjBQsIAw4TJQ8FJQoaiA4KtlgWkGIHgxx9A5dthj6ORDo
X-IronPort-AV: E=Sophos;i="4.89,950,1367964000"; 
   d="scan'208";a="384663263"
Date: Sun, 25 Aug 2013 09:11:22 +0200
From: Henrik Rydberg <rydberg@euromail.se>
To: Ian Munsie <darkstarsword@gmail.com>
Cc: Brad Ford <plymouthffl@gmail.com>, Linus G Thiel <linus@hanssonlarsson.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] HID: apple: Add another device ID for the mid-2013
 Macbook Air
Message-ID: <20130825071122.GA12567@polaris.bitmath.org>
References: <1377353873-17000-1-git-send-email-darkstarsword@gmail.com>
 <1377353873-17000-2-git-send-email-darkstarsword@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377353873-17000-2-git-send-email-darkstarsword@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ian,

> This patch adds a device ID found for mid-2013 Macbook Air 6,1 from
> lsusb:
> 
> Bus 001 Device 003: ID 05ac:0290 Apple, Inc.
> 
> Since IDs already exist for this generation Macbook air as WELLSPRING8,
> name this one WELLSPRING8A. This only adds an ANSI version since it's
> device ID is only one less than the existing WELLSPRING8 IDs.

This seems to indicate that we got the ANSI/ISO numbers wrong in a
recent patch. IIRC, there was doubt already when the patch was
applied (Linus T CC'd). Most likely the right patch is this:

diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index 4ef4d5e..a73f961 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -89,9 +89,9 @@
 #define USB_DEVICE_ID_APPLE_WELLSPRING7A_ISO   0x025a
 #define USB_DEVICE_ID_APPLE_WELLSPRING7A_JIS   0x025b
 /* MacbookAir6,2 (unibody, June 2013) */
-#define USB_DEVICE_ID_APPLE_WELLSPRING8_ANSI   0x0291
-#define USB_DEVICE_ID_APPLE_WELLSPRING8_ISO    0x0292
-#define USB_DEVICE_ID_APPLE_WELLSPRING8_JIS    0x0293
+#define USB_DEVICE_ID_APPLE_WELLSPRING8_ANSI   0x0290
+#define USB_DEVICE_ID_APPLE_WELLSPRING8_ISO    0x0291
+#define USB_DEVICE_ID_APPLE_WELLSPRING8_JIS    0x0292
 
 #define BCM5974_DEVICE(prod) {                                 \
        .match_flags = (USB_DEVICE_ID_MATCH_DEVICE |            \

Brad, Linus, does the above patch work for you as well as for Ian?

Thanks,
Henrik
