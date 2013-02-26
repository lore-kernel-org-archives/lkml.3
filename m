Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759833Ab3BZQ0f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 11:26:35 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:43350 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759575Ab3BZQ0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 11:26:32 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH v2 0/2] Arch-specific user pgtables ceiling
Date: Tue, 26 Feb 2013 16:26:06 +0000
Message-Id: <1361895968-17066-1-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.12.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That's the second version of the series introducing
USER_PGTABLES_CEILING and defining it to TASK_SIZE on ARM.

Russell, do you ack these patches (or let me know if you have further
comments)? I think it's better if they go upstream together rather than
one via akpm and the other via the arm tree.

Thanks.


Changes from v1:
- Only defining USER_PGTABLES_CEILING to TASK_SIZE when CONFIG_ARM_LPAE
  is enabled. The classic ARM MMU uses the default ceiling 0.
- Improved commit log stating that the shared page table freeing is
  already handled by pgd_free() for the ARM LPAE case.
- Cc'ed stable (starting with 3.3 when ARM LPAE was merged).


Catalin Marinas (1):
  arm: Set the page table freeing ceiling to TASK_SIZE

Hugh Dickins (1):
  mm: Allow arch code to control the user page table ceiling

 arch/arm/include/asm/pgtable.h |  9 +++++++++
 fs/exec.c                      |  4 ++--
 include/asm-generic/pgtable.h  | 10 ++++++++++
 mm/mmap.c                      |  4 ++--
 4 files changed, 23 insertions(+), 4 deletions(-)

