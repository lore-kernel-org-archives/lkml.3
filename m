Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbaB1Qlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 11:41:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362AbaB1Qlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 11:41:35 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] HID: multitouch cleanups and support for fancy devices
Date: Fri, 28 Feb 2014 11:41:22 -0500
Message-Id: <1393605685-17025-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

Ok, this patch series is not very consistent and could have been split in two...
Anyway, here is some work for hid-multitouch:

- the first patch is mainly a way for us to reduce the work load regarding hid-mt
  when device makers ask for an inclusion in the kernel.
  Also, I have been notified that a Quanta 3008 was not working, and it occurs
  that this particular device has a special handling in hid-mt. Of course, the
  hardware maker reused the same VID/PID, but changed the protocol.
  So yes, I am in favour of killing all unneeded special cases.

  I checked all the devices I was able to test, and this leaves us a bunch of
  devices which, I am sure, could be removed too (all the ones following
  MT_CLS_NSMU should be in this case). So, if anyone else wants to join me in
  this crusade, I'd be glad to receive patches.

- the second and third patch are the v2 of the series I sent back in December
  2013 ([PATCH 0/3] Change in handling different input device in hid-multitouch).
  Henrik made valuable comments, and I did not had the time to look at it and to
  figure out how to address them. Now I got a different look at this work, and
  I think I addressed the issues (no more function pointers, yeah!)

Happy reviewing.

Cheers,
Benjamin

PS: it might be Spring coming, but I am definitively trying to reduce the total
lines of code in the HID subsystem...

Benjamin Tissoires (3):
  HID: multitouch: remove default behaviors
  HID: multitouch: remove pen special handling
  HID: multitouch: add support of other generic collections in hid-mt

 drivers/hid/hid-ids.h        |   3 +
 drivers/hid/hid-multitouch.c | 270 +++++++++++++++----------------------------
 include/linux/hid.h          |   3 +
 3 files changed, 101 insertions(+), 175 deletions(-)

-- 
1.8.5.3

