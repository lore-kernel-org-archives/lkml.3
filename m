Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab3BRQSv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 11:18:51 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:55088 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754265Ab3BRQSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 11:18:48 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org
Subject: [PATCH 0/2] Arch-specific user pgtables ceiling
Date: Mon, 18 Feb 2013 16:18:29 +0000
Message-Id: <1361204311-14127-1-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.12.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following feedback on the previous patch to limit the free_pgtables()
ceiling, this series introduces a USER_PGTABLES_CEILING macro defaulting
to 0 and an ARM-specific definition to TASK_SIZE.

Catalin Marinas (1):
  arm: Set the page table freeing ceiling to TASK_SIZE

Hugh Dickins (1):
  mm: Allow arch code to control the user page table ceiling

 arch/arm/include/asm/pgtable.h |  7 +++++++
 fs/exec.c                      |  4 ++--
 include/asm-generic/pgtable.h  | 10 ++++++++++
 mm/mmap.c                      |  4 ++--
 4 files changed, 21 insertions(+), 4 deletions(-)

