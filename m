Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761231Ab3BLES0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 23:18:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45749 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757767Ab3BLESY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 23:18:24 -0500
Date: Mon, 11 Feb 2013 20:18:09 -0800
From: tip-bot for Mike Travis <travis@sgi.com>
Message-ID: <tip-526018bc5eccfe3177780f03d2aaba0efee40720@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, travis@sgi.com, sivanich@sgi.com,
        gregkh@linuxfoundation.org, rja@sgi.com, bhelgaas@google.com,
        tglx@linutronix.de, liuj97@gmail.com, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, travis@sgi.com, sivanich@sgi.com,
        gregkh@linuxfoundation.org, rja@sgi.com, bhelgaas@google.com,
        liuj97@gmail.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20130211194508.457937455@gulag1.americas.sgi.com>
References: <20130211194508.457937455@gulag1.americas.sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86, uv, uv3: Update ACPI Check to include SGI UV3
Git-Commit-ID: 526018bc5eccfe3177780f03d2aaba0efee40720
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 11 Feb 2013 20:18:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  526018bc5eccfe3177780f03d2aaba0efee40720
Gitweb:     http://git.kernel.org/tip/526018bc5eccfe3177780f03d2aaba0efee40720
Author:     Mike Travis <travis@sgi.com>
AuthorDate: Mon, 11 Feb 2013 13:45:10 -0600
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 11 Feb 2013 17:17:44 -0800

x86, uv, uv3: Update ACPI Check to include SGI UV3

Add UV3 to exclusion list.  Instead of adding every new series of
SGI UV systems, just check oem_id to have a prefix of "SGI".

Signed-off-by: Mike Travis <travis@sgi.com>
Link: http://lkml.kernel.org/r/20130211194508.457937455@gulag1.americas.sgi.com
Acked-by: Russ Anderson <rja@sgi.com>
Reviewed-by: Dimitri Sivanich <sivanich@sgi.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/pci/mmconfig-shared.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index fb29968..082e881 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -548,8 +548,7 @@ static int __init acpi_mcfg_check_entry(struct acpi_table_mcfg *mcfg,
 	if (cfg->address < 0xFFFFFFFF)
 		return 0;
 
-	if (!strcmp(mcfg->header.oem_id, "SGI") ||
-			!strcmp(mcfg->header.oem_id, "SGI2"))
+	if (!strncmp(mcfg->header.oem_id, "SGI", 3))
 		return 0;
 
 	if (mcfg->header.revision >= 1) {
