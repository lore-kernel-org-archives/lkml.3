Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492AbaKQPrt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 10:47:49 -0500
Received: from vs-m.tc.umn.edu ([134.84.135.97]:50894 "EHLO vs-m.tc.umn.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbaKQPrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 10:47:47 -0500
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Nov 2014 10:47:47 EST
X-Umn-Remote-Mta: [N] mail-ob0-f170.google.com [209.85.214.170] #+LO+TS+TR
X-Umn-Classification: local
MIME-Version: 1.0
Date: Mon, 17 Nov 2014 09:32:42 -0600
Message-ID: <CAEcPAJ4PjAxqjVsU+M2t+eLjjxTREx4yjbnSd+dau5GZgh+D3g@mail.gmail.com>
Subject: Add quirks for another ELAN Touchscreen
From: Bryan Poling <poli0048@umn.edu>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi. This is my first attempt at this, but I would like to suggest
adding 2 quirks for an ELAN touchscreen. Without these quirks, the
touchscreen holds up the boot process with tons of errors reading a
descriptor (error -71). With these quirks added the system boots fine
and the touchscreen still works fine. The following lines need to be
added:

To "/drivers/hid/hid-ids.h":
#define USB_DEVICE_ID_ELAN_TOUCHSCREEN_010c 0x010c

To "/drivers/hid/usbhid/hid-quirks.h":
{ USB_VENDOR_ID_ELAN, USB_DEVICE_ID_ELAN_TOUCHSCREEN_010c,
HID_QUIRK_ALWAYS_POLL },

To "/drivers/usb/core/quirks.c":
{ USB_DEVICE(0x04f3, 0x010c), .driver_info =
USB_QUIRK_DEVICE_QUALIFIER },

I tried making patch files but was not successful (I may try again). I
hope somebody can add this though. Thanks, and best regards.
