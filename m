Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbaLPAug (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 19:50:36 -0500
Received: from lekensteyn.nl ([178.21.112.251]:39762 "EHLO lekensteyn.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876AbaLPAud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 19:50:33 -0500
From: Peter Wu <peter@lekensteyn.nl>
To: Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] HID: logitech-{dj,hidpp}: more reliability fixes
Date: Tue, 16 Dec 2014 01:50:13 +0100
Message-Id: <1418691016-30681-1-git-send-email-peter@lekensteyn.nl>
X-Mailer: git-send-email 2.1.3
X-Spam-Score: -0.0 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

Here are more fixes intended for the 3.19 tree after a review. Two bugfixes.
one which was mentioned in a mail with Benjamin ("avoid unintended
fall-through") and a fix to avoid a possible 5 second delay for HID++ 2.0
errors. I haven't encountered a case where the hidpp module generates a HID++
2.0 error though, so maybe that change can go to 3.20 too if you want to keep
the changeset small.

The third (second) patch adds a check to avoid passing a short report. A similar
fix should probably be written for stable kernels (the code was changed in 3.19,
but the length check was already missing in older kernels).

Kind regards,
Peter

Peter Wu (3):
  HID: logitech-hidpp: detect HID++ 2.0 errors too
  HID: logitech-{dj,hidpp}: check report length
  HID: logitech-hidpp: avoid unintended fall-through

 drivers/hid/hid-logitech-dj.c    | 16 +++++++++++++++-
 drivers/hid/hid-logitech-hidpp.c | 30 ++++++++++++++++++++++++------
 2 files changed, 39 insertions(+), 7 deletions(-)

-- 
2.1.3

