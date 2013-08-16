Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab3HPHIk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 03:08:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:9610 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752624Ab3HPHIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 03:08:18 -0400
X-IronPort-AV: E=Sophos;i="4.89,892,1367942400"; 
   d="scan'208";a="8217641"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, lenb@kernel.org,
        rjw@sisk.pl, liwanp@linux.vnet.ibm.com, tj@kernel.org,
        akpm@linux-foundation.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [PATCH 0/6] acpi: Fix and cleanup in acpi.
Date: Fri, 16 Aug 2013 15:06:43 +0800
Message-Id: <1376636809-10159-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/16 15:06:32,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/16 15:06:36,
	Serialize complete at 2013/08/16 15:06:36
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set fix the following problems:

1. Kill useless function save_add_info() which will block us from using
   numa when MEMORY_HOTPLUG is not configured.
2. acpi_table_parse() didn't check if @id is NULL.
3. Fix incorrect comment in acpi_table_parse(), and return -ENOENT if a
   table is not found.

And also did some cleanup.

Tang Chen (6):
  acpi, numa, mem_hotplug: Kill save_add_info().
  acpi, numa, mem_hotplug: Print Hot-Pluggable Field in SRAT.
  acpi cleanup: Use pr_info() instead of printk() in arch/x86/mm/srat.c
  acpi cleanup: Use pr_err() instead of printk() in arch/x86/mm/srat.c
  acpi: Check if @id is NULL in acpi_table_parse()
  acpi: Return -ENOENT in acpi_table_parse() and fix wrong comment.

 arch/x86/mm/srat.c    |   38 +++++++++++++++++---------------------
 drivers/acpi/tables.c |    9 +++++----
 2 files changed, 22 insertions(+), 25 deletions(-)

