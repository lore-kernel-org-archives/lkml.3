Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200AbaDXW2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 18:28:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39546 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228AbaDXVqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:46:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Brian Norris <computersforpeace@gmail.com>
Subject: [PATCH 3.14 31/33] jffs2: remove from wait queue after schedule()
Date: Thu, 24 Apr 2014 14:48:44 -0700
Message-Id: <20140424214454.098786745@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140424214449.423169713@linuxfoundation.org>
References: <20140424214449.423169713@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zefan <lizefan@huawei.com>

commit 3ead9578443b66ddb3d50ed4f53af8a0c0298ec5 upstream.

@wait is a local variable, so if we don't remove it from the wait queue
list, later wake_up() may end up accessing invalid memory.

This was spotted by eyes.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/jffs2/nodemgmt.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/jffs2/nodemgmt.c
+++ b/fs/jffs2/nodemgmt.c
@@ -179,6 +179,7 @@ int jffs2_reserve_space(struct jffs2_sb_
 					spin_unlock(&c->erase_completion_lock);
 
 					schedule();
+					remove_wait_queue(&c->erase_wait, &wait);
 				} else
 					spin_unlock(&c->erase_completion_lock);
 			} else if (ret)


