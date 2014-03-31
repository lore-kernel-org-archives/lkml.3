Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbaCaLEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 07:04:16 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:62862 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbaCaLEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 07:04:15 -0400
Date: Mon, 31 Mar 2014 13:04:11 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/acpi change for v3.15
Message-ID: <20140331110411.GA8280@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-acpi-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-acpi-for-linus

   # HEAD: 896dc5064083063981954f142e43548765199792 x86, acpi: Fix bug in associating hot-added CPUs with corresponding NUMA node

A single NUMA CPU hotplug fix.

 Thanks,

	Ingo

------------------>
Jiang Liu (1):
      x86, acpi: Fix bug in associating hot-added CPUs with corresponding NUMA node


 arch/x86/kernel/acpi/boot.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 1dac942..9f46f2b 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -613,10 +613,10 @@ static void acpi_map_cpu2node(acpi_handle handle, int cpu, int physid)
 	int nid;
 
 	nid = acpi_get_node(handle);
-	if (nid == -1 || !node_online(nid))
-		return;
-	set_apicid_to_node(physid, nid);
-	numa_set_node(cpu, nid);
+	if (nid != -1) {
+		set_apicid_to_node(physid, nid);
+		numa_set_node(cpu, nid);
+	}
 #endif
 }
 
