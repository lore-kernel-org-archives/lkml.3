Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab3BDGmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 01:42:35 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56541 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905Ab3BDGmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 01:42:32 -0500
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [RESEND PATCH 4/4] kdump,
 oldmem: compare with saved_max_pfn exclusively
To: ralf@linux-mips.org, michael@ellerman.id.au, benh@kernel.crashing.org,
        paulus@samba.org, holzheu@linux.vnet.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, vgoyal@redhat.com
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Mon, 04 Feb 2013 15:42:30 +0900
Message-ID: <20130204064230.13324.51086.stgit@localhost6.localdomain6>
In-Reply-To: <20130204064112.13324.89478.stgit@localhost6.localdomain6>
References: <20130204064112.13324.89478.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---

 drivers/char/mem.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index c6fa3bc..5da737c 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -369,7 +369,7 @@ static ssize_t read_oldmem(struct file *file, char __user *buf,
 
 	while (count) {
 		pfn = *ppos / PAGE_SIZE;
-		if (pfn > saved_max_pfn)
+		if (!(pfn < saved_max_pfn))
 			return read;
 
 		offset = (unsigned long)(*ppos % PAGE_SIZE);

