Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbbAGRH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:07:27 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:41963 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713AbbAGRHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:07:24 -0500
From: Petr Cermak <petrcermak@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Primiano Tucci <primiano@chromium.org>,
        Petr Cermak <petrcermak@chromium.org>
Subject: [PATCH v2 0/2] task_mmu: Add user-space support for resetting mm->hiwater_rss (peak RSS)
Date: Wed,  7 Jan 2015 17:06:52 +0000
Message-Id: <cover.1420643264.git.petrcermak@chromium.org>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Being able to reset mm->hiwater_rss (resident set size high water mark) from
user space would enable fine grained iterative memory profiling. I propose a
very short patch for doing so.

The driving use-case for this would be getting the peak RSS value, which can be
retrieved from the VmHWM field in /proc/pid/status, per benchmark iteration or
test scenario.

Changelog:

v2:
- clarify behaviour in documentation as suggesed by Andrew Morton
<akpm@linux-foundation.org>
- fix a declaration-after-statement warning in fs/proc/task_mmu.c

v1: https://lkml.org/lkml/2014/12/10/312

Petr Cermak (2):
task_mmu: Reduce excessive indentation in clear_refs_write
task_mmu: Add user-space support for resetting mm->hiwater_rss (peak RSS)

 Documentation/filesystems/proc.txt |   3 +
 fs/proc/task_mmu.c                 | 115 +++++++++++++++++++++----------------
 include/linux/mm.h                 |   5 ++
 3 files changed, 74 insertions(+), 49 deletions(-)

-- 
2.2.0.rc0.207.ga3a616c

