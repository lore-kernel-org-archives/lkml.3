Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090Ab3CLE7j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 00:59:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:31804 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751557Ab3CLE7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 00:59:37 -0400
X-IronPort-AV: E=Sophos;i="4.84,827,1355068800"; 
   d="scan'208";a="6856238"
Message-ID: <513EB5DA.2010300@cn.fujitsu.com>
Date: Tue, 12 Mar 2013 12:58:02 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 04/18] x86: platform: mrst: remove cast for kmalloc return
 value
References: <513EB23D.7020303@cn.fujitsu.com>
In-Reply-To: <513EB23D.7020303@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/12 12:58:22,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/12 12:58:23,
	Serialize complete at 2013/03/12 12:58:23
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove cast for kmalloc return value.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "x86@kernel.org" <x86@kernel.org>
---
 arch/x86/platform/mrst/mrst.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index e31bcd8..a0a0a43 100644
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -356,8 +356,7 @@ static int __init sfi_parse_gpio(struct sfi_table_header *table)
 	num = SFI_GET_NUM_ENTRIES(sb, struct sfi_gpio_table_entry);
 	pentry = (struct sfi_gpio_table_entry *)sb->pentry;
 
-	gpio_table = (struct sfi_gpio_table_entry *)
-				kmalloc(num * sizeof(*pentry), GFP_KERNEL);
+	gpio_table = kmalloc(num * sizeof(*pentry), GFP_KERNEL);
 	if (!gpio_table)
 		return -1;
 	memcpy(gpio_table, pentry, num * sizeof(*pentry));
-- 
1.7.1

