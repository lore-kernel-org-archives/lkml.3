Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760782Ab3K0CBH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 21:01:07 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43080 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760762Ab3K0CA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 21:00:56 -0500
Subject: [PATCH v7 2/2] Documentation, x86, apic,
 kexec: Add disable_cpu_apicid kernel parameter
To: hpa@linux.intel.com, ebiederm@xmission.com, vgoyal@redhat.com
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, bp@alien8.de,
        akpm@linux-foundation.org, fengguang.wu@intel.com, jingbai.ma@hp.com
Date: Wed, 27 Nov 2013 11:00:53 +0900
Message-ID: <20131127020053.1493.54092.stgit@localhost6.localdomain6>
In-Reply-To: <20131127020006.1493.86091.stgit@localhost6.localdomain6>
References: <20131127020006.1493.86091.stgit@localhost6.localdomain6>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add disable_cpu_apicid kernel parameter to disable the CPU with the
specified number of initial APIC ID, mostly used for the kdump 2nd
kernel to disable BSP to wake up multiple CPUs without causing system
reset or hang due to sending INIT from AP to BSP.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---
 Documentation/kernel-parameters.txt |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 50680a5..dd77bec 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -774,6 +774,15 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	disable=	[IPV6]
 			See Documentation/networking/ipv6.txt.
 
+	disable_cpu_apicid= [X86,APIC,KEXEC,SMP]
+			Format: <int>
+			The number of initial APIC ID for the
+			corresponding CPU to be disabled at boot,
+			mostly used for the kdump 2nd kernel to
+			disable BSP to wake up multiple CPUs without
+			causing system reset or hang due to sending
+			INIT from AP to BSP.
+
 	disable_ddw     [PPC/PSERIES]
 			Disable Dynamic DMA Window support. Use this if
 			to workaround buggy firmware.

