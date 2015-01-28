Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761368AbbA1CXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:23:25 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:20331 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760245AbbA1CXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 21:23:21 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: iamjoonsoo.kim@lge.com, m.szyprowski@samsung.com,
        akpm@linux-foundation.org, lauraa@codeaurora.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH v3 0/3] mm: cma: debugfs access to CMA
Date: Tue, 27 Jan 2015 21:22:54 -0500
Message-Id: <1422411777-22332-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 2.1.0
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've noticed that there is no interfaces exposed by CMA which would let me
fuzz what's going on in there.

This small patch set exposes some information out to userspace, plus adds
the ability to trigger allocation and freeing from userspace.

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

