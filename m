Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570AbaAOVJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 16:09:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54518 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbaAOVJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:09:54 -0500
Date: Wed, 15 Jan 2014 13:09:35 -0800
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-5b4d1dbc24bb6fd7179ada0f47be34e27e64decb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, d.hatayama@jp.fujitsu.com, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, d.hatayama@jp.fujitsu.com
In-Reply-To: <20140115182511.GA22737@gmail.com>
References: <20140115182511.GA22737@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, apic:
  Make disabled_cpu_apicid static read_mostly, fix typos
Git-Commit-ID: 5b4d1dbc24bb6fd7179ada0f47be34e27e64decb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 15 Jan 2014 13:09:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5b4d1dbc24bb6fd7179ada0f47be34e27e64decb
Gitweb:     http://git.kernel.org/tip/5b4d1dbc24bb6fd7179ada0f47be34e27e64decb
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Wed, 15 Jan 2014 13:02:08 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 15 Jan 2014 13:02:08 -0800

x86, apic: Make disabled_cpu_apicid static read_mostly, fix typos

Make disabled_cpu_apicid static and read_mostly, and fix a couple of
typos.

Reported-by: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/r/20140115182511.GA22737@gmail.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---
 arch/x86/kernel/apic/apic.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index e78ab8c..7f26c9a 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -79,7 +79,7 @@ physid_mask_t phys_cpu_present_map;
  * disable_cpu_apicid=<int>, mostly used for the kdump 2nd kernel to
  * avoid undefined behaviour caused by sending INIT from AP to BSP.
  */
-unsigned int disabled_cpu_apicid = BAD_APICID;
+static unsigned int disabled_cpu_apicid __read_mostly = BAD_APICID;
 
 /*
  * Map cpu index to physical APIC ID
@@ -2124,7 +2124,7 @@ int generic_processor_info(int apicid, int version)
 	 * boot_cpu_physical_apicid is designed to have the apicid
 	 * returned by read_apic_id(), i.e, the apicid of the
 	 * currently booting-up processor. However, on some platforms,
-	 * it is temporarilly modified by the apicid reported as BSP
+	 * it is temporarily modified by the apicid reported as BSP
 	 * through MP table. Concretely:
 	 *
 	 * - arch/x86/kernel/mpparse.c: MP_processor_info()
@@ -2145,7 +2145,7 @@ int generic_processor_info(int apicid, int version)
 	    disabled_cpu_apicid == apicid) {
 		int thiscpu = num_processors + disabled_cpus;
 
-		pr_warning("ACPI: Disabling requested cpu."
+		pr_warning("APIC: Disabling requested cpu."
 			   " Processor %d/0x%x ignored.\n",
 			   thiscpu, apicid);
 
