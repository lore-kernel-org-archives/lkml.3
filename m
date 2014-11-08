Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbaKHXBv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 18:01:51 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:60760 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaKHXBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 18:01:50 -0500
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: nefelim4ag@gmail.com, marco.antonio.780@gmail.com
Subject: [PATCH v2 0/3] KSM: Mark new vma for deduplication
Date: Sun,  9 Nov 2014 02:01:40 +0300
Message-Id: <1415487703-1824-1-git-send-email-nefelim4ag@gmail.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good time of day List,
this tiny series of patches implement feature for auto deduping all anonymous memory.
mark_new_vma - new ksm sysfs interface
Every time then new vma created and mark_new_vma set to 1, then will be vma marked as VM_MERGEABLE and added to ksm queue.
This can produce small overheads
(I have not catch any problems or slowdown)

This is useful for:
Android (CM) devs which implement ksm support with patching system.
Users of tiny pc.
Servers what not use KVM but use something very releated, like containers.

For tests:
I have tested it and it working very good. For testing apply it and enable ksm:
echo 1 | sudo tee /sys/kernel/mm/ksm/run
This show how much memory saved:
echo $[$(cat /sys/kernel/mm/ksm/pages_shared)*$(getconf PAGE_SIZE)/1024 ]KB

On my system i save ~1% of memory 26 Mb/2100 Mb (deduped)/(used)

Timofey Titovets (3):
  KSM: Add auto flag new VMA as VM_MERGEABLE
  KSM: Add to sysfs - mark_new_vma
  KSM: Add config to control mark_new_vma

 include/linux/ksm.h | 39 +++++++++++++++++++++++++++++++++++++++
 mm/Kconfig          |  7 +++++++
 mm/ksm.c            | 39 ++++++++++++++++++++++++++++++++++++++-
 mm/mmap.c           | 17 +++++++++++++++++
 4 files changed, 101 insertions(+), 1 deletion(-)

--
2.1.3

