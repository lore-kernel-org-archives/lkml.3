Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbaATLdN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 06:33:13 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:42781 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbaATLdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 06:33:07 -0500
From: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
To: akpm@linux-foundation.org
Cc: hannes@cmpxchg.org, liuj97@gmail.com, santosh.shilimkar@ti.com,
        grygorii.strashko@ti.com, iamjoonsoo.kim@lge.com,
        robin.m.holt@gmail.com, tangchen@cn.fujitsu.com, yinghai@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Philipp Hachtmann <phacht@linux.vnet.ibm.com>
Subject: [PATCH V5 0/3] mm/memblock: Excluded memory
Date: Mon, 20 Jan 2014 12:32:36 +0100
Message-Id: <1390217559-14691-1-git-send-email-phacht@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.4.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012011-8372-0000-0000-000008610311
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This all fits linux-next.

The first patch is a fix (not a replacement) to a patch that has already 
been put into linux-next. The original patch generates a warning for an
unused variable in case that CONFIG_ARCH_DISCARD_MEMBLOCK is not set.
It's now made the way Andrew suggested. 

The second patch adds support for exluded memory region handling in
memblock. This is needed by the current s390 development in conjunction
with kdump.
The patch is straightforward and adds some redundancy. This has been 
done to clarify that this patch does not intend to change any of
the current memblock API's behaviour.

The third patch does some cleanup and refactoring to memblock. It removes
the redundancies introduced by the patch before. It also is not intended
to change or break any behaviour or API of memblock.


Philipp Hachtmann (3):
  mm/nobootmem: Fix unused variable
  mm/memblock: Add support for excluded memory areas
  mm/memblock: Cleanup and refactoring after addition of nomap

 include/linux/memblock.h |  57 +++++++++---
 mm/Kconfig               |   3 +
 mm/memblock.c            | 233 +++++++++++++++++++++++++++++++++++------------
 mm/nobootmem.c           |  30 ++++--
 4 files changed, 243 insertions(+), 80 deletions(-)

-- 
1.8.4.5

