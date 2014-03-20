Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041AbaCTMeJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 08:34:09 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:41384 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbaCTMeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 08:34:07 -0400
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: akpm@linux-foundation.org, tangchen@cn.fujitsu.com,
        zhangyanfei@cn.fujitsu.com, phacht@linux.vnet.ibm.com,
        yinghai@kernel.org, grygorii.strashko@ti.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 0/3] memblock: add physmem list and convert s390 to memblock
Date: Thu, 20 Mar 2014 13:33:47 +0100
Message-Id: <1395318830-7435-1-git-send-email-schwidefsky@de.ibm.com>
X-Mailer: git-send-email 1.7.9.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032012-5024-0000-0000-00000937735A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

this is our current patch series to convert s390 to memblock.

The list of excluded memory that has been proposed by Philipp in
his patch from January is gone, it has been replaced by the list
of physically available memory. The available memory is initially
added to both the 'memory' and the 'physmem' list, but memory is
only removed from the 'memory' list. A typical use case is the
'mem=' parameter to limit the kdump kernel to a small part of the
memory while the physmem list still contains all physically
available memory.

To avoid code duplication for the physmem list the first of the
three patches refactors the memblock code a bit, with no functional
change for the existing memblock API.

The second patch adds support for the physmem list to memblock,
to enable it the option HAVE_MEMBLOCK_PHYS_MAP needs to be
selected by the architecture Kconfig file.

The third patch is the s390 conversion to memblock.

>From my point of view this code is now nice and clean and I would
like to add it to the s390 features branch in the near future.
As 3.14 is close I would suggest doing this after the next merge
window has closed.

blue skies,
  Martin.

Philipp Hachtmann (3):
  mm/memblock: Do some refactoring, enhance API
  mm/memblock: add physical memory list
  s390/mm: Convert bootmem to memblock

 arch/s390/Kconfig             |    3 +-
 arch/s390/include/asm/setup.h |   16 +-
 arch/s390/kernel/crash_dump.c |   83 ++++----
 arch/s390/kernel/early.c      |    6 +
 arch/s390/kernel/head31.S     |    1 -
 arch/s390/kernel/setup.c      |  451 +++++++++++++++--------------------------
 arch/s390/kernel/topology.c   |    4 +-
 arch/s390/mm/mem_detect.c     |  138 ++++---------
 arch/s390/mm/vmem.c           |   30 ++-
 drivers/s390/char/zcore.c     |   44 ++--
 include/linux/memblock.h      |   79 ++++++--
 mm/Kconfig                    |    3 +
 mm/memblock.c                 |  205 ++++++++++++-------
 13 files changed, 476 insertions(+), 587 deletions(-)

-- 
1.7.9.5

