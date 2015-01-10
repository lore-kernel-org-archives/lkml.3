Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751332AbbAJFg1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 00:36:27 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:54850 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbbAJFgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 00:36:25 -0500
From: Chris Rorvick <chris@rorvick.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Chris Rorvick <chris@rorvick.com>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Davide Berardi <berardi.dav@gmail.com>, devel@driverdev.osuosl.org,
        Fabian Mewes <architekt@coding4coffee.org>,
        Gulsah Kose <gulsah.1004@gmail.com>,
        Himangi Saraogi <himangi774@gmail.com>,
        Jerry Snitselaar <dev@snitselaar.org>,
        =?UTF-8?q?L=2E=20Alberto=20Gim=C3=A9nez?= <agimenez@sysvalve.es>,
        linux-kernel@vger.kernel.org, Mikhail Boiko <mm.boiko@yandex.ru>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Stefan Hajnoczi <stefanha@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 00/25] line6usb cleanup
Date: Fri,  9 Jan 2015 23:35:46 -0600
Message-Id: <1420868171-2031-1-git-send-email-chris@rorvick.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The line6usb driver references the device's idProduct and, in some
cases, the interface number in a number of places to determine device-
specific configuration values and to call device-specific functionality.
Rework code to leverage the device table matching more effectively.
Consolidate configuration settings into the properties entries and use
function pointers setup at initialization to remove much of the
conditional logic.

I have a TonePort UX2 that I've used for testing, meaning that some of
this is really only compile-tested.

Regards,

Chris

Chris Rorvick (25):
  staging: line6: Remove `device_bit' from properties
  staging: line6: Remove line6_pod_transmit_paramter()
  staging: line6: Remove unsupported X3 devices
  staging: line6: Cleanup device table
  staging: line6: Define a device type enum
  staging: line6: Index properties array with device type
  staging: line6: Key off of device type
  staging: line6: Remove idVendor and idProduct macros
  staging: line6: Remove useless comments
  staging: line6: Rename capability macros
  staging: line6: Use explicit indexes when defining properties
  staging: line6: List out capabilities individually
  staging: line6: Split out PODxt Live interfaces
  staging: line6: Split out POD HD500 interfaces
  staging: line6: Filter on Pocket POD interface
  staging: line6: Filter on UX2 interfaces
  staging: line6: Move altsetting to properties
  staging: line6: Move control endpoints to properties
  staging: line6: Remove stale Pocket POD PCM endpoints
  staging: line6: Move audio endpoints to properties
  staging: line6: Pass *_init() `usb_line6' pointers
  staging: line6: Pass *_process_message() `usb_line6' pointers
  staging: line6: Call *_process_message() via pointer
  staging: line6: Call *_disconnect() via pointer
  staging: line6: Make *_disconnect() functions static

 drivers/staging/line6/capture.c  |   9 +-
 drivers/staging/line6/driver.c   | 698 ++++++++++++++++++---------------------
 drivers/staging/line6/driver.h   |  57 ++--
 drivers/staging/line6/midi.c     |   4 +-
 drivers/staging/line6/pcm.c      |  55 +--
 drivers/staging/line6/pcm.h      |  12 +-
 drivers/staging/line6/playback.c |  11 +-
 drivers/staging/line6/pod.c      |  83 +++--
 drivers/staging/line6/pod.h      |  12 +-
 drivers/staging/line6/podhd.c    |  48 +--
 drivers/staging/line6/podhd.h    |   3 +-
 drivers/staging/line6/toneport.c | 113 ++++---
 drivers/staging/line6/toneport.h |   3 +-
 drivers/staging/line6/usbdefs.h  |  95 +-----
 drivers/staging/line6/variax.c   |  36 +-
 drivers/staging/line6/variax.h   |   4 +-
 16 files changed, 528 insertions(+), 715 deletions(-)

-- 
2.1.0

