Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932830Ab3GRP6P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 11:58:15 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:46710 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758217Ab3GRP6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 11:58:13 -0400
From: enselic@gmail.com
To: matthew.garrett@nebula.com, bleung@chromium.org, olof@lixom.net
Cc: miletus@chromium.org, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin Nordholts <enselic@gmail.com>
Subject: [PATCH 0/1] Platform: x86: chromeos_laptop - convert to i2c_driver to handle i915 race
Date: Thu, 18 Jul 2013 17:58:10 +0200
Message-Id: <1374163091-4750-1-git-send-email-enselic@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Nordholts <enselic@gmail.com>

Hello,

I have looked into solving the "touchpad/touchscreen not working on
boot"-problem on Chromebook Pixel, see for example Brock Tice's last
comment on https://plus.google.com/+LinusTorvalds/posts/1iFsBWBqoYY

I have seen Olof's attempt at a fix:

  [PATCH] Platform: x86: chromeos_laptop: defer probing if no i2c busses found
  https://lkml.org/lkml/2013/4/18/556

At first, I tried Olofs suggestion at the end of the thread, namely to
do bus_register_notifier() on i2c_bus_type, but it is a bit awkward:
How do you know that the i2c_adapter you are notified about is ready
to be interacted with? While investigating this, I noticed that the
i2c_driver has a .detect() mechanism, which is exactly what we need: A
callback when a newly added i2c_adapter is initialized and ready to be
used.

Since all chromeos_laptop does is to instantiate i2c devices, I
figured it would be nice to simply convert chromeos_laptop into a
i2c_driver. The result is the patch in the next mail (based on
v3.11-rc1).

I have gone through the SubmitChecklist and done everything that
applied. I have however only tested this patch on the Chromebook
Pixel, as that is what I have. I will need help with verifying the
patch on other Chromebooks.

But first, what do you think about my patch?

/ Martin

Martin Nordholts (1):
  Platform: x86: chromeos_laptop - convert to i2c_driver to handle i915
    race

 drivers/platform/x86/chromeos_laptop.c |  426 +++++++++++++++-----------------
 1 file changed, 194 insertions(+), 232 deletions(-)

-- 
1.7.10.4

