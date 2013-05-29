Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966318Ab3E2N63 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 09:58:29 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:35075 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966298Ab3E2N6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:58:24 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, David Rientjes <rientjes@google.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        David Howells <dhowells@redhat.com>, Mark Salter <msalter@redhat.com>,
        Jianguo Wu <wujianguo@huawei.com>, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: [PATCH v6, part4 04/41] h8300: normalize global variables exported by vmlinux.lds
Date: Wed, 29 May 2013 21:57:22 +0800
Message-Id: <1369835879-23553-5-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369835879-23553-1-git-send-email-jiang.liu@huawei.com>
References: <1369835879-23553-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generate mandatory global variables __bss_start/__bss_stop in
file vmlinux.lds.

Also remove one unused declaration of _text.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: linux-kernel@vger.kernel.org
---
 arch/h8300/boot/compressed/misc.c | 1 -
 arch/h8300/kernel/vmlinux.lds.S   | 2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/h8300/boot/compressed/misc.c b/arch/h8300/boot/compressed/misc.c
index 51ab6cb..4a1e3dd 100644
--- a/arch/h8300/boot/compressed/misc.c
+++ b/arch/h8300/boot/compressed/misc.c
@@ -79,7 +79,6 @@ static void error(char *m);
 
 int puts(const char *);
 
-extern int _text;		/* Defined in vmlinux.lds.S */
 extern int _end;
 static unsigned long free_mem_ptr;
 static unsigned long free_mem_end_ptr;
diff --git a/arch/h8300/kernel/vmlinux.lds.S b/arch/h8300/kernel/vmlinux.lds.S
index 03d356d..3253fed 100644
--- a/arch/h8300/kernel/vmlinux.lds.S
+++ b/arch/h8300/kernel/vmlinux.lds.S
@@ -132,10 +132,12 @@ SECTIONS
         {
 	. = ALIGN(0x4) ;
 	__sbss = . ;
+	___bss_start = . ;
 		*(.bss*)
 	. = ALIGN(0x4) ;
 		*(COMMON)
 	. = ALIGN(0x4) ;
+	___bss_stop = . ;
 	__ebss = . ;
 	__end = . ;
 	__ramstart = .;
-- 
1.8.1.2

