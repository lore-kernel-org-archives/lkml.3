Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934108AbaEGNfd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:35:33 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:61741 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933403AbaEGNf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:35:27 -0400
From: Liu Hua <sdu.liu@huawei.com>
To: <linux@arm.linux.org.uk>, <kumagai-atsushi@mxc.nes.nec.co.jp>
CC: <will.deacon@arm.com>, <kexec@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <wangnan0@huawei.com>,
        <peifeiyue@huawei.com>, <sdu.liu@huawei.com>, <liusdu@126.com>
Subject: [RFC PATCH 0/2] transfer sparse memory related values
Date: Wed, 7 May 2014 21:27:12 +0800
Message-ID: <1399469234-54925-1-git-send-email-sdu.liu@huawei.com>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now different platforms may have different SECTION_SIZE_BITS and
MAX_PHYSMEM_BITS. But linux passes nothing related to the 
vmcore.

User space tools such as makedumpfile needs these to deal with 
the vmcore. So we must define these when compiling. So if we 
deal with aother vmcore. We may need to recompile the tools.

These patch series make kernel pass related infomation to
the user space tools, via vmcore. And makedumpfile can
get these when parsing vmcore. So the makdumpfile becomes
more compatible to vmcore with different section size.


Liu Hua (1):
  kdump: add sparse memory related values to vmcore
  makedumpfile: get additional information from vmcore

 kernel/kexec.c | 3 +++
 makedumpfile.c | 17 +++++++++++++++++
 makedumpfile.h |  2 ++
 3 files changed, 22 insertions(+)

-- 
1.9.0

