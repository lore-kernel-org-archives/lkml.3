Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132AbaFCFbi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 01:31:38 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:43843 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299AbaFCFbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 01:31:18 -0400
From: Real Name <enjoymindful@gmail.com>
To: user-mode-linux-devel@lists.sourceforge.net
Cc: richard@nod.at, linux-kernel@vger.kernel.org,
        Honggang Li <enjoymindful@gmail.com>
Subject: [PATCH v2] delete unnecessary bootmem struct page array
Date: Tue,  3 Jun 2014 13:30:44 +0800
Message-Id: <1401773445-25256-1-git-send-email-enjoymindful@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Honggang Li <enjoymindful@gmail.com>

The patch based on linux-next-2014-06-02.

The old init_maps function does two things:
1) allocates and initializes one struct page array for bootmem
2) count the number of total pages

After removed the source code related to the unnecessary array, the name 
'init_maps' is some kind of improper named, as it just count the number of
total page numbers. So, I renamed the function as 'mem_total_pages'.

I tested the patch through repeat reboot the uml kernel many times.
[real@name linux-next]$ make ARCH=um defconfig
[real@name linux-next]$ make ARCH=um linux
[real@name linux-next]$ file linux
linux: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.32, not stripped
[real@name linux-next]$ ./linux ubda=/home/real/linux-next/Fedora20-AMD64-root_fs mem=256m && sync && echo 1
[real@name linux-next]$ ./linux ubda=/home/real/linux-next/Fedora20-AMD64-root_fs mem=256m && sync && echo 2
(repeat reboot the uml kernel many times..)

Honggang Li (1):
  delete unnecessary bootmem struct page array

 arch/um/include/shared/mem_user.h |  2 +-
 arch/um/kernel/physmem.c          | 32 ++++++--------------------------
 arch/um/kernel/um_arch.c          |  7 +------
 3 files changed, 8 insertions(+), 33 deletions(-)

-- 
1.8.3.1

