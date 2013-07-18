Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759492Ab3GRXPd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 19:15:33 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:35058 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759242Ab3GRXPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 19:15:32 -0400
X-AuditID: 85900ec0-d56cbb900000151e-6a-51e8771189ff
Subject: [PATCH 0/2] [BUGFIX] virtio/console: Fix two bugs of splice_write
To: Amit Shah <amit.shah@redhat.com>, linux-kernel@vger.kernel.org
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnd Bergmann <arnd@arndb.de>, yrl.pp-manager.tt@hitachi.com
Date: Fri, 19 Jul 2013 08:19:27 +0900
Message-ID: <20130718231927.3664.50418.stgit@yunodevel>
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

Thanks!

---

Yoshihiro YUNOMAE (2):
      [BUGFIX] virtio/console: Quit from splice_write if pipe->nrbufs is 0
      [BUGFIX] virtio/console: Add pipe_lock/unlock for splice_write


 drivers/char/virtio_console.c |    9 +++++++++
 1 file changed, 9 insertions(+)

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com
