Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760494AbbA2CBL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:01:11 -0500
Received: from aserp1050.oracle.com ([141.146.126.70]:48049 "EHLO
	aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760462AbbA2CBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:01:08 -0500
X-Greylist: delayed 18104 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Jan 2015 21:01:08 EST
From: Sasha Levin <sasha.levin@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: iamjoonsoo.kim@lge.com, m.szyprowski@samsung.com,
        akpm@linux-foundation.org, lauraa@codeaurora.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH v4 0/3] mm: cma: debugfs access to CMA
Date: Wed, 28 Jan 2015 14:10:08 -0500
Message-Id: <1422472211-32387-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 2.1.0
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-Source-IP: aserp1040.oracle.com [141.146.126.69]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've noticed that there is no interfaces exposed by CMA which would let me
fuzz what's going on in there.

This small patch set exposes some information out to userspace, plus adds
the ability to trigger allocation and freeing from userspace.

Changes from v3:
 - Minor build fix, sent incorrect patch for v3

Changes from v2:
 - Keep allocated memory lists per-cma
 - Don't allow partial free with non-zero order_per_bit
 - Use 0 alignment

Changes from v1:
 - Make allocation and free hooks per-cma.
 - Remove additional debug prints.

Sasha Levin (3):
  mm: cma: debugfs interface
  mm: cma: allocation trigger
  mm: cma: release trigger

 mm/Kconfig     |    6 ++
 mm/Makefile    |    1 +
 mm/cma.c       |   19 ++----
 mm/cma.h       |   20 +++++++
 mm/cma_debug.c |  175 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 206 insertions(+), 15 deletions(-)
 create mode 100644 mm/cma.h
 create mode 100644 mm/cma_debug.c

-- 
1.7.10.4

