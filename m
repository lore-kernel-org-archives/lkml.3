Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966290Ab3E2N6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 09:58:19 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:50604 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966281Ab3E2N6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:58:17 -0400
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
        Haavard Skinnemoen <hskinnemoen@gmail.com>
Subject: [PATCH v6, part4 02/41] avr32: normalize global variables exported by vmlinux.lds
Date: Wed, 29 May 2013 21:57:20 +0800
Message-Id: <1369835879-23553-3-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369835879-23553-1-git-send-email-jiang.liu@huawei.com>
References: <1369835879-23553-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Normalize global variables exported by vmlinux.lds to conform usage
guidelines from include/asm-generic/sections.h.

Use _text to mark the start of the kernel image including the head text,
and _stext to mark the start of the .text section.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: linux-kernel@vger.kernel.org
---
 arch/avr32/kernel/setup.c       | 2 +-
 arch/avr32/kernel/vmlinux.lds.S | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/avr32/kernel/setup.c b/arch/avr32/kernel/setup.c
index b4247f4..209ae5a 100644
--- a/arch/avr32/kernel/setup.c
+++ b/arch/avr32/kernel/setup.c
@@ -555,7 +555,7 @@ void __init setup_arch (char **cmdline_p)
 {
 	struct clk *cpu_clk;
 
-	init_mm.start_code = (unsigned long)_text;
+	init_mm.start_code = (unsigned long)_stext;
 	init_mm.end_code = (unsigned long)_etext;
 	init_mm.end_data = (unsigned long)_edata;
 	init_mm.brk = (unsigned long)_end;
diff --git a/arch/avr32/kernel/vmlinux.lds.S b/arch/avr32/kernel/vmlinux.lds.S
index 9cd2bd9..a458917 100644
--- a/arch/avr32/kernel/vmlinux.lds.S
+++ b/arch/avr32/kernel/vmlinux.lds.S
@@ -23,7 +23,7 @@ SECTIONS
 {
 	. = CONFIG_ENTRY_ADDRESS;
 	.init		: AT(ADDR(.init) - LOAD_OFFSET) {
-		_stext = .;
+		_text = .;
 		__init_begin = .;
 			_sinittext = .;
 			*(.text.reset)
@@ -46,7 +46,7 @@ SECTIONS
 
 	.text		: AT(ADDR(.text) - LOAD_OFFSET) {
 		_evba = .;
-		_text = .;
+		_stext = .;
 		*(.ex.text)
 		*(.irq.text)
 		KPROBES_TEXT
-- 
1.8.1.2

