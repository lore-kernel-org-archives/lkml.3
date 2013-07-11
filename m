Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410Ab3GKNlp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 09:41:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755889Ab3GKNlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 09:41:42 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        David Herrmann <dh.herrmann@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-bluetooth@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Bluetooth:  hidp: cleanup HID init and re-enable hidinput_input_event callback
Date: Thu, 11 Jul 2013 15:41:28 +0200
Message-Id: <1373550090-30379-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

These two patches enhance a little bit the HIDp driver:
- the first one re-implement in a safer way the callback hidinput_input_event,
  allowing keyboards leds to be set over bluetooth
- the second one disable the send_report commands called during init, which
  are not part of the spec and may fail with some devices (the Wiimote is in
  this case, but David guarded it against this problem).

Cheers,
Benjamin

Benjamin Tissoires (2):
  Bluetooth: hidp: implement hidinput_input_event callback
  Bluetooth: hidp: remove wrong send_report at init

 net/bluetooth/hidp/core.c | 40 ++++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 14 deletions(-)

-- 
1.8.3.1

