Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbaKKM5z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 07:57:55 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:58011 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493AbaKKM5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 07:57:52 -0500
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-mm@kvack.org
Cc: nefelim4ag@gmail.com, marco.antonio.780@gmail.com,
        linux-kernel@vger.kernel.org, tonyb@cybernetics.com,
        killertofu@gmail.com
Subject: [PATCH V3 0/4] KSM: Mark new vma for deduplication
Date: Tue, 11 Nov 2014 15:57:32 +0300
Message-Id: <1415710656-29296-1-git-send-email-nefelim4ag@gmail.com>
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

Can be pulled from:
https://github.com/Nefelim4ag/linux.git ksm_improvements

For tests:
I have tested it and it working very good. For testing apply it and enable ksm:
echo 1 | sudo tee /sys/kernel/mm/ksm/run
This show how much memory saved:
echo $[$(cat /sys/kernel/mm/ksm/pages_shared)*$(getconf PAGE_SIZE)/1024 ]KB

On my system i save ~1% of memory 26 Mb/2100 Mb (deduped)/(used)

v2:
	Added Kconfig for control default value of mark_new_vma
	Added sysfs interface for control mark_new_vma
	Splitted in several patches

v3:
	Documentation for ksm changed for clarify new cha

Timofey Titovets (4):
  KSM: Add auto flag new VMA as VM_MERGEABLE
  KSM: Add to sysfs - mark_new_vma
  KSM: Add config to control mark_new_vma
  KSM: mark_new_vma added to Documentation.

 Documentation/vm/ksm.txt |  7 +++++++
 include/linux/ksm.h      | 39 +++++++++++++++++++++++++++++++++++++++
 mm/Kconfig               |  7 +++++++
 mm/ksm.c                 | 39 ++++++++++++++++++++++++++++++++++++++-
 mm/mmap.c                | 17 +++++++++++++++++
 5 files changed, 108 insertions(+), 1 deletion(-)

-- 
2.1.3

