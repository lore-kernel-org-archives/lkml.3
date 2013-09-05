Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763530Ab3IEIdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 04:33:19 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:57131 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757502Ab3IEIdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 04:33:15 -0400
Subject: [PATCH] scsi: Add printk to detect retry loop
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
From: Eiichi Tsukata <eiichi.tsukata.xh@hitachi.com>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 05 Sep 2013 17:33:11 +0900
Message-ID: <20130905083310.3079.7106.stgit@ltc223.sdl.hitachi.co.jp>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch is to avoid indefinite command retry loop.
The previous RFC patch is here:
http://marc.info/?t=137690537600002&r=1&w=3

In the previous discuss, James says that once retry loop is detected,
whether or not to panic(offline) should be decided by user, and not in
scsi subsystem. So we need a way to detect retry loop and report it to
user space.

This patch adds printk to detect command retry loop in user space. When
the command retry count exceeds the allowed count(scmd->allowed), the
kernel prints messages, which can be handled in user space application.
Here the allowed count(scmd->allowed) is currently used as finite retry
limit count. Once retry count exceeds the allowed count on a device,
the message is suppressed on the device to avoid too much messages
outputted in dmesg.


---

Eiichi Tsukata (1):
      scsi: Add printk to detect retry loop


 drivers/scsi/scsi_error.c  |    3 +--
 drivers/scsi/scsi_lib.c    |   14 ++++++++++++++
 include/scsi/scsi_device.h |    1 +
 3 files changed, 16 insertions(+), 2 deletions(-)

-- 
Eiichi Tsukata
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: eiichi.tsukata.xh@hitachi.com

