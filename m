Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab3HWGs1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 02:48:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:29915 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754134Ab3HWGsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 02:48:25 -0400
X-IronPort-AV: E=Sophos;i="4.89,939,1367942400"; 
   d="scan'208";a="8280360"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: mingo@redhat.com, hpa@zytor.com, yinghai@kernel.org, penberg@kernel.org,
        jacob.shin@amd.com, tglx@linutronix.de, lenb@kernel.org, rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, x86@kernel.org
Subject: [PATCH 0/3] x86, ACPI, mm: Cleanup for {max|low|max_low}_pfn_mapped.
Date: Fri, 23 Aug 2013 14:31:17 +0800
Message-Id: <1377239480-32532-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/23 14:30:49,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/23 14:30:51,
	Serialize complete at 2013/08/23 14:30:51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set does the following:
1. Kill max_low_pfn_mapped as it is useless.
   This patch is from Yinghai.
2. Update min_pfn_mapped and max_pfn_mapped together in add_pfn_range_mapped().
3. Move definition of max_pfn_mapped tp init.c together with min_pfn_mapped.

Tang Chen (2):
  x86, mm: Update min_pfn_mapped in add_pfn_range_mapped().
  x86, mm: Move max_pfn_mapped definition to init.c.

Yinghai Lu (1):
  x86, ACPI, mm: Kill max_low_pfn_mapped.

 arch/x86/include/asm/page_types.h |    1 -
 arch/x86/kernel/setup.c           |   10 ----------
 arch/x86/mm/init.c                |   15 ++++++++++-----
 drivers/acpi/osl.c                |    6 +++---
 4 files changed, 13 insertions(+), 19 deletions(-)

