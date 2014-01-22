Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbaAVL2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 06:28:39 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:44517 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613AbaAVL2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 06:28:36 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <kexec@lists.infradead.org>
CC: Eric Biederman <ebiederm@xmission.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geng Hui <hui.geng@huawei.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Wang Nan <wangnan0@huawei.com>
Subject: [PATCH 0/3] Bugfix for kdump on arm
Date: Wed, 22 Jan 2014 19:25:13 +0800
Message-ID: <1390389916-8711-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series introduce 3 bugfix for kdump (and kexec) on arm platform.

kdump for arm in fact is corrupted (at least for omap4460). With one-month hard
work and with the help of a jtag debugger, we finally make kdump works
reliablly.


Following is the patches. The first 2 patches forms a group, it allow
ioremap_nocache to be taken on reserved pages on arm platform (which is
prohibited by 309caa9cc) and then use ioremap_nocache to copy kexec required
code. The last 1 is for crash dump kernel. It allow kernel to be loaded in the
middle of kernel awared physical memory. Without it, crashdump kernel must be
carefully configured to boot.

Wang Nan (3):
  ARM: Premit ioremap() to map reserved pages
  ARM: kexec: copying code to ioremapped area
  ARM: allow kernel to be loaded in middle of phymem

 arch/arm/kernel/machine_kexec.c | 18 ++++++++++++++++--
 arch/arm/mm/init.c              | 21 ++++++++++++++++++++-
 arch/arm/mm/ioremap.c           |  2 +-
 arch/arm/mm/mmu.c               | 13 +++++++++++++
 kernel/kexec.c                  | 40 +++++++++++++++++++++++++++++++++++-----
 mm/page_alloc.c                 |  7 +++++--
 6 files changed, 90 insertions(+), 11 deletions(-)


Signed-off-by: Wang Nan <wangnan0@huawei.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Geng Hui <hui.geng@huawei.com>

-- 
1.8.4

