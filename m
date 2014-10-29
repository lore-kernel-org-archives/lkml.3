Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933867AbaJ2OJO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 10:09:14 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:38107 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933835AbaJ2OJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 10:09:04 -0400
From: Kever Yang <kever.yang@rock-chips.com>
To: Paul Zimmerman <paulz@synopsys.com>
Cc: Dinh Nguyen <dinguyen@opensource.altera.com>, Felipe Balbi <balbi@ti.com>,
        linux-usb@vger.kernel.org, cf@rock-chips.com, lyz@rock-chips.com,
        wulf@rock-chips.com, jwerner@chromium.org,
        Kever Yang <kever.yang@rock-chips.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 0/2] add power manage for dwc2 hcd
Date: Wed, 29 Oct 2014 22:08:45 +0800
Message-Id: <1414591728-10106-1-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset add clock manage and suspend/resume for dwc2.
Based on Dinh's patch "usb: dwc2: Add support for dual role".

Because the system suspend/resume on my platform still not
ready, and the 'suspend' can't be used in power/control node,
and the auto suspend seems not work, could anyone told me
how to test the usb suspend/resume API easily?

Changes in v2:
- remove the clock from hcd
- adjust the delay time when resume
- move all the clock operation into platform

Kever Yang (2):
  usb: dwc2: add bus suspend/resume for dwc2
  usb: dwc2: move the clock management from gadget to platform

 drivers/usb/dwc2/gadget.c   | 24 ++-------------
 drivers/usb/dwc2/hcd.c      | 75 ++++++++++++++++++++++++++++++++++++++-------
 drivers/usb/dwc2/platform.c | 32 +++++++++++--------
 3 files changed, 86 insertions(+), 45 deletions(-)

-- 
1.9.1

