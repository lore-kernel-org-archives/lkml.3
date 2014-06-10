Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbaFJWqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 18:46:21 -0400
Received: from marmot.wormnet.eu ([188.246.204.87]:43355 "EHLO
	marmot.wormnet.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbaFJWqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 18:46:06 -0400
From: Jamie Lentin <jm@lentin.co.uk>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jamie Lentin <jm@lentin.co.uk>
Subject: [PATCH v2 0/2] Add support for Lenovo Compact Keyboard
Date: Tue, 10 Jun 2014 23:24:52 +0100
Message-Id: <1402439094-25464-1-git-send-email-jm@lentin.co.uk>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset follows on from my previous attempt[1] to add support for
these keyboards from Lenovo.

Changes since v1:
* Merge driver into hid-lenovo-tpkbd.c instead of creating our own
  driver for the hardware [Jiri Kosina]
* Remove key mappings which are now supported by standard
* Use KEY_FILE for Fn-F12 (opens My Computer on Windows)
* Support the USB variant as well as Bluetooth
* Expose the Fn Lock setting as a sysfs attribute instead of trying to
  build a mechanism to toggle into the kernel

I got rid of the Fn-lock toggle code since it didn't play nicely with
the USB keyboard; from what I could ascertain, hid_output_raw_report
wants to sleep when sending a report to a USB keyboard, which isn't
allowed. The same was true when using an input handler.

A sysfs attribute is more flexible anyway, and one could trivially
script a user-space toggling mechanism around it. I suspect in
reality so long as Fn-Lock is left on nobody will really care what the
Fn-Lock key does :)

Applies and tested against 3.14.5.

Cheers,

[1] https://lkml.org/lkml/2014/3/25/535

Jamie Lentin (2):
  Loosen seams to allow support of other keyboards
  Add support for Compact (Bluetooth|USB) keyboard with Trackpoint

 drivers/hid/hid-core.c         |   2 +
 drivers/hid/hid-ids.h          |   2 +
 drivers/hid/hid-lenovo-tpkbd.c | 236 +++++++++++++++++++++++++++++++++++++++--
 include/linux/hid.h            |   1 +
 4 files changed, 232 insertions(+), 9 deletions(-)

-- 
2.0.0.rc2

