Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab3GXP3V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 11:29:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753665Ab3GXP3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 11:29:17 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] HID special drivers converted to devres API
Date: Wed, 24 Jul 2013 17:29:04 +0200
Message-Id: <1374679746-12566-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

It's been a long time since I told you that I was about to work on the devres API...
So here are the first patches.

My deductions are that it is safe to run devm_* functions within the hid subsystem.
With this, we can simplify a little the error path of some drivers. The gain
is more visible for hid-multitouch as the function mt_free_input_name() can
be entirely dropped.

Cheers,
Benjamin

Benjamin Tissoires (2):
  HID: trivial devm conversion for special hid drivers
  HID: multitouch: devm conversion

 drivers/hid/hid-a4tech.c     | 23 +++-----------
 drivers/hid/hid-apple.c      | 16 ++--------
 drivers/hid/hid-magicmouse.c | 17 ++---------
 drivers/hid/hid-multitouch.c | 71 ++++++++++++++------------------------------
 drivers/hid/hid-sony.c       |  9 ++----
 drivers/hid/hid-zydacron.c   | 19 ++----------
 6 files changed, 39 insertions(+), 116 deletions(-)

-- 
1.8.3.1

