Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbaCAAUu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 19:20:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265AbaCAAUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 19:20:45 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, David Herrmann <dh.herrmann@gmail.com>,
        David Barksdale <dbarksdale@uplogix.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] HID: ll transport cleanup: final round
Date: Fri, 28 Feb 2014 19:20:33 -0500
Message-Id: <1393633237-26496-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

by shuffling around the hid files, I noticed that I introduced a regression
in commit 3a75b24949a8 (HID: hidraw: replace hid_output_raw_report() calls...).
We removed the hid_output_raw_report() calls in hidraw, which means that
the special sixasis handling was broken from the hidraw callers (I don't know
if there are any however).

So I took some time to finish this work. I am not particularly proud of patches
2/4 and 3/4:

For the patch 2/4, we need to get some feedbacks from David Barksdale,
because the spec seems a little bit nebulous to me and I'd prefer having real
tests to confirm that it is the right choice. I hope that David B. will send
his feedbacks soon. If not, I still would like to see this in 3.15 with the
rest of the cleanup to avoid having new drivers which use the old API.

Regarding 3/4, well, I added 2 quirks which are not so trivials, but I am not
sure I could do something else.

Anyway, happy reviewing.

Cheers,
Benjamin

Benjamin Tissoires (4):
  HID: cp2112: remove various hid_out_raw_report calls
  HID: cp2112: remove the last hid_output_raw_report() call
  HID: sony: do not rely on hid_out_raw_report
  HID: remove hid_output_raw_report transport implementations

 drivers/hid/hid-cp2112.c      | 28 +++++++++++++++-----
 drivers/hid/hid-sony.c        | 59 ++++++++++---------------------------------
 drivers/hid/hidraw.c          |  3 ++-
 drivers/hid/i2c-hid/i2c-hid.c | 14 ----------
 drivers/hid/uhid.c            |  1 -
 drivers/hid/usbhid/hid-core.c | 19 +++++---------
 include/linux/hid.h           | 21 ++-------------
 net/bluetooth/hidp/core.c     | 14 ----------
 8 files changed, 45 insertions(+), 114 deletions(-)

-- 
1.8.5.3

