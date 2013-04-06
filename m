Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423092Ab3DFOmQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 10:42:16 -0400
Received: from mail-da0-f44.google.com ([209.85.210.44]:48612 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423040Ab3DFOmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 10:42:13 -0400
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
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Subject: [PATCH v4, part3 02/41] avr32: normalize global variables exported by vmlinux.lds
Date: Sat,  6 Apr 2013 22:32:01 +0800
Message-Id: <1365258760-30821-3-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365258760-30821-1-git-send-email-jiang.liu@huawei.com>
References: <1365258760-30821-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Normalize global variables exported by vmlinux.lds to conform usage
guidelines from include/asm-generic/sections.h.

Use _text to mark the start of the kernel image including the head text,
and _stext to mark the start of the .text section.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: linux-kernel@vger.kernel.org
---
 arch/avr32/kernel/setup.c       |    2 +-
 arch/avr32/kernel/vmlinux.lds.S |    4 ++--
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
1.7.9.5

