Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264AbbAZO0k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 09:26:40 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:49231 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224AbbAZO0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 09:26:33 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: iamjoonsoo.kim@lge.com, m.szyprowski@samsung.com,
        akpm@linux-foundation.org, lauraa@codeaurora.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH v2 0/3] mm: cma: debugfs access to CMA
Date: Mon, 26 Jan 2015 09:26:02 -0500
Message-Id: <1422282365-20015-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 2.1.0
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've noticed that there is no interfaces exposed by CMA which would let me
fuzz what's going on in there.

This small patch set exposes some information out to userspace, plus adds
the ability to trigger allocation and freeing from userspace.

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

