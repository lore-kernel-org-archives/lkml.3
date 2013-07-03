Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279Ab3GCNCL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 09:02:11 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:41397 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab3GCNCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 09:02:08 -0400
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [RFC][PATCH 0/2] s390/kvm: add kvm support for guest page hinting
Date: Wed,  3 Jul 2013 15:01:50 +0200
Message-Id: <1372856512-25710-1-git-send-email-schwidefsky@de.ibm.com>
X-Mailer: git-send-email 1.7.9.5
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070312-2966-0000-0000-0000080A81E8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux on s390 as a guest under z/VM has been using the guest page
hinting interface (alias collaborative memory management) for a long
time. The full version with volatile states has been deemed to be too
complicated (see the old discussion about guest page hinting e.g. on
http://marc.info/?l=linux-mm&m=123816662017742&w=2).
What is currently implemented for the guest is the unused and stable
states to mark unallocated pages as freely available to the host.
This works just fine with z/VM as the host.

The two patches in this series implement the guest page hinting
interface for the unused and stable states in the KVM host.
Most of the code specific to s390 but there is a common memory
management part as well, see patch #1.

The circus is back ;-)

Konstantin Weitz (2):
  mm: add support for discard of unused ptes
  s390/kvm: support collaborative memory management

 arch/s390/include/asm/kvm_host.h |    8 +++-
 arch/s390/include/asm/pgtable.h  |   24 ++++++++++++
 arch/s390/kvm/kvm-s390.c         |   24 ++++++++++++
 arch/s390/kvm/kvm-s390.h         |    2 +
 arch/s390/kvm/priv.c             |   37 ++++++++++++++++++
 arch/s390/mm/pgtable.c           |   77 ++++++++++++++++++++++++++++++++++++++
 include/asm-generic/pgtable.h    |   13 +++++++
 include/linux/rmap.h             |    1 +
 mm/rmap.c                        |   28 +++++++++++++-
 mm/vmscan.c                      |    3 ++
 10 files changed, 214 insertions(+), 3 deletions(-)

-- 
1.7.9.5

