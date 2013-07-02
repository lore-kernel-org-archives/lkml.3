Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423Ab3GBSdI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 14:33:08 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:35719 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061Ab3GBSdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 14:33:06 -0400
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: <linux-kernel@vger.kernel.org>
Cc: <dri-devel@lists.freedesktop.org>
Subject: 3.10 kernel: [drm:evergreen_startup] *ERROR* radeon: error initializing UVD (-1).
Date: Tue, 2 Jul 2013 14:33:06 -0400
Message-ID: <004101ce7752$989eca50$c9dc5ef0$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: Ac53T9lkwqRxzA/ZSkKSBFIUPfBTrw==
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I use an ATI graphics card (PCI-e x1) for a server:
Card: [AMD/ATI] Park [Mobility Radeon HD 5430]

I upgraded my kernel from 3.9.x to 3.10, after rebooting I found the driver
now wants a new firmware:
radeon 0000:05:00.0: radeon_uvd: Can't load firmware
"radeon/CYPRESS_uvd.bin"

I pulled the latest firmware down (and also updated the others) and
rebooted:
CONFIG_EXTRA_FIRMWARE="radeon/CEDAR_me.bin radeon/CEDAR_pfp.bin
radeon/CEDAR_rlc.bin radeon/CYPRESS_uvd.bin"

Then have this issue:
[drm] radeon: irq initialized.
[drm:evergreen_startup] *ERROR* radeon: error initializing UVD (-1).

The screen goes black for ~5 seconds and then come back on.
Not sure if this has been reported or not (w/CEDAR chipset) but FYI.

Kernel config:
http://home.comcast.net/~jpiszcz/20130702/config-3.10-4.txt

Full dmesg:
http://home.comcast.net/~jpiszcz/20130702/full-dmesg.txt

Possibly related:
http://lists.opensuse.org/opensuse-bugs/2013-06/msg00053.html
https://bugzilla.novell.com/show_bug.cgi?id=822777
https://bugzilla.novell.com/show_bug.cgi?id=822777#c0
http://www.mail-archive.com/dri-devel@lists.freedesktop.org/msg38066.html
https://bugs.freedesktop.org/show_bug.cgi?id=63935

Snippet:
[    2.033535] [drm:r600_uvd_init] *ERROR* UVD not responding, trying to
reset the VCPU!!!
[    3.053742] [drm:r600_uvd_init] *ERROR* UVD not responding, trying to
reset the VCPU!!!
[    4.073985] [drm:r600_uvd_init] *ERROR* UVD not responding, trying to
reset the VCPU!!!
[    5.094192] [drm:r600_uvd_init] *ERROR* UVD not responding, trying to
reset the VCPU!!!
[    6.114405] [drm:r600_uvd_init] *ERROR* UVD not responding, trying to
reset the VCPU!!!
[    7.134611] [drm:r600_uvd_init] *ERROR* UVD not responding, trying to
reset the VCPU!!!
[    8.154824] [drm:r600_uvd_init] *ERROR* UVD not responding, trying to
reset the VCPU!!!
[    9.175044] [drm:r600_uvd_init] *ERROR* UVD not responding, trying to
reset the VCPU!!!
[   10.195251] [drm:r600_uvd_init] *ERROR* UVD not responding, trying to
reset the VCPU!!!
[   11.215464] [drm:r600_uvd_init] *ERROR* UVD not responding, trying to
reset the VCPU!!!
[   11.235537] [drm:r600_uvd_init] *ERROR* UVD not responding, giving up!!!
[   11.235607] [drm:evergreen_startup] *ERROR* radeon: error initializing
UVD (-1).

Justin.

