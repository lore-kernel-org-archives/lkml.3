Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760251Ab3B0PjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 10:39:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63037 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759946Ab3B0PjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 10:39:15 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>,
        David Herrmann <dh.herrmann@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 0/2] HID: Introduce .idle() to remove last usb dependence from hid-multitouch
Date: Wed, 27 Feb 2013 16:38:16 +0100
Message-Id: <1361979498-24446-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

Well, this series of two patches aims at removing the dependence between usb
and hid-multitouch.
I put a RFC and not a patch as I'm not satisfied with the result:
- adding this callback for one use may not be accurate
- the parameters may not be good either (HID_REQ_SET_IDLE is the only valid
  value for now as noone seems to be using HID_REQ_GET_IDLE)
- the return value is clearly not very interesting.
- maybe we should just add HID_REQ_SET_IDLE to .request, but this will require
  a few changes in the parameters.

The main purpose of this RFC was to share it with David this new ll callback, so
that we can have a global view of what is needed.

Thanks for the inputs.

Cheers,
Benjamin

Benjamin Tissoires (2):
  HID: Extend the interface with idle requests
  HID: multitouch: remove last usb dependency

 drivers/hid/hid-multitouch.c  | 17 +----------------
 drivers/hid/usbhid/hid-core.c | 15 +++++++++++++++
 include/linux/hid.h           | 19 +++++++++++++++++++
 3 files changed, 35 insertions(+), 16 deletions(-)

-- 
1.8.1.2

