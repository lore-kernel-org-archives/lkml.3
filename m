Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab3GVD4y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 23:56:54 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:44246 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143Ab3GVD4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 23:56:52 -0400
X-AuditID: 85900ec0-d38c8b900000151e-0d-51ecad82c579
Subject: [PATCH V3 0/2] [BUGFIX] virtio/console: Fix two bugs of splice_write
To: Amit Shah <amit.shah@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Mon, 22 Jul 2013 13:00:43 +0900
Message-ID: <20130722040043.7531.78801.stgit@yunodevel>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch set fixes two bugs of splice_write in the virtio-console driver.

[BUG1] Although pipe->nrbufs is empty, the driver tries to do splice_write.
       => This induces oops in sg_init_table().

[BUG2] No lock for competition of splice_write.
       => This induces oops in splice_from_pipe_feed() by bug of any user
          application.

These reports are written in each patch.

Changes in V2:
- Fix a locking problem for error

Changes in V3:
- Add Reviewed-by lines and stable@ line in sign-off area

Thanks!

---

Yoshihiro YUNOMAE (2):
      [BUGFIX] virtio/console: Quit from splice_write if pipe->nrbufs is 0
      [BUGFIX] virtio/console: Add pipe_lock/unlock for splice_write


 drivers/char/virtio_console.c |   23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com
