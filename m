Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965200AbaE2OZe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:25:34 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43451 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965186AbaE2OZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 10:25:33 -0400
Date: Thu, 29 May 2014 15:25:12 +0100
From: Will Deacon <will.deacon@arm.com>
To: torvalds@linux-foundation.org
Cc: catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Late regression fix for arm64
Message-ID: <20140529142512.GA6168@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Catalin's currently on holiday [1], so I'm dealing with the arm64 tree
for a change. Unfortunately, it's not as quiet as I'd like and we've got
a fix for a horrible THP regression introduced during the merge window.
The symptom tends to be CoW failures for tasks that end up using
transparent hugepages, which ultimately means random userspace breakage
for anything that uses large anonymous mappings and forks.

Please can you pull this for 3.15?

Cheers,

Will

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-May/259319.html

--->8

The following changes since commit c7208164e66f63e3ec1759b98087849286410741:

  Linux 3.15-rc7 (2014-05-25 16:06:00 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git tags/arm64-fixes

for you to fetch changes up to ceb218359de22e70980801d4fa04fffbfc44adb8:

  arm64: mm: fix pmd_write CoW brokenness (2014-05-29 11:31:14 +0100)

----------------------------------------------------------------
- Fix CoW regression for transparent hugepages by routing set_pmd_at to
  set_pte_at, which correctly handles PTE_WRITE and will mark the
  resulting table entry as read-only where appropriate.

----------------------------------------------------------------
Will Deacon (1):
      arm64: mm: fix pmd_write CoW brokenness

 arch/arm64/include/asm/pgtable.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
