Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294Ab3FAQWW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 12:22:22 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:34253 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab3FAQWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 12:22:14 -0400
From: Marcus Overhagen <marcus.overhagen@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/1] rts5139 Fix SD card detection and use correct transfer interval
Date: Sat,  1 Jun 2013 18:22:10 +0200
Message-Id: <1370103731-5667-1-git-send-email-marcus.overhagen@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SD card reader slot on my Samsung Series 7 ultrabook 
never worked and still wasn't working with 3.10-rc3, also
the syslog was spammed. The following patch fixes both.

The timeout detection implemented in this driver isn't very
robust, although the USB interrupt transfer is successful,
the polling thread often reported timeouts because the 50ms
had expired before it got scheduled, and the SD card wasn't
detected. Increasing it to 100ms at least makes it work.

Using the correct interval as reported by the endpoint also
stops the syslog spam printed by xhci.

Marcus Overhagen (1):
  Fix SD card detection and use correct transfer interval.

 drivers/staging/rts5139/rts51x_transport.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

-- 
1.8.1.2

