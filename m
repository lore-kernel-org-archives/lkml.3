Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079AbaHWWMh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 18:12:37 -0400
Received: from mail-ig0-f202.google.com ([209.85.213.202]:44847 "EHLO
	mail-ig0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaHWWMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 18:12:34 -0400
From: Peter Feiner <pfeiner@google.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Peter Feiner <pfeiner@google.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>, Jamie Liu <jamieliu@google.com>,
        Hugh Dickins <hughd@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 0/3] softdirty fix and write notification cleanup
Date: Sat, 23 Aug 2014 18:11:58 -0400
Message-Id: <1408831921-10168-1-git-send-email-pfeiner@google.com>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1408571182-28750-1-git-send-email-pfeiner@google.com>
References: <1408571182-28750-1-git-send-email-pfeiner@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the new patch that uses Kirill's approach of setting write
notifications on the VMA. I also included write notification cleanups and
fixes per our discussion.

Peter Feiner (3):
  mm: softdirty: enable write notifications on VMAs after VM_SOFTDIRTY
    cleared
  mm: mprotect: preserve special page protection bits
  mm: mmap: cleanup code that preserves special vm_page_prot bits

 fs/proc/task_mmu.c | 17 ++++++++++++++++-
 include/linux/mm.h | 15 +++++++++++++++
 mm/mmap.c          | 26 +++++++++++---------------
 mm/mprotect.c      |  2 +-
 4 files changed, 43 insertions(+), 17 deletions(-)

-- 
2.1.0.rc2.206.gedb03e5

