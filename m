Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003Ab3I1SsK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 14:48:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908Ab3I1SsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 14:48:08 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH] mn10300/PCI: Remove pci_mem_start
To: dhowells@redhat.com, yasutake.koichi@jp.panasonic.com, bhelgaas@google.com
Cc: linux-am33-list@redhat.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 28 Sep 2013 11:59:56 -0600
Message-ID: <20130928175956.8752.50967.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused 'pci_mem_start' variable.

CC: David Howells <dhowells@redhat.com>
CC: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 arch/mn10300/include/asm/pci.h |    1 -
 arch/mn10300/kernel/setup.c    |    3 ---
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/mn10300/include/asm/pci.h b/arch/mn10300/include/asm/pci.h
index 6f31cc0..1663238 100644
--- a/arch/mn10300/include/asm/pci.h
+++ b/arch/mn10300/include/asm/pci.h
@@ -44,7 +44,6 @@ extern void unit_pci_init(void);
 #define pcibios_assign_all_busses()	0
 #endif
 
-extern unsigned long pci_mem_start;
 #define PCIBIOS_MIN_IO		0xBE000004
 #define PCIBIOS_MIN_MEM		0xB8000000
 
diff --git a/arch/mn10300/kernel/setup.c b/arch/mn10300/kernel/setup.c
index ebac9c1..2ad7f32 100644
--- a/arch/mn10300/kernel/setup.c
+++ b/arch/mn10300/kernel/setup.c
@@ -35,9 +35,6 @@
 
 struct mn10300_cpuinfo boot_cpu_data;
 
-/* For PCI or other memory-mapped resources */
-unsigned long pci_mem_start = 0x18000000;
-
 static char __initdata cmd_line[COMMAND_LINE_SIZE];
 char redboot_command_line[COMMAND_LINE_SIZE] =
 	"console=ttyS0,115200 root=/dev/mtdblock3 rw";

