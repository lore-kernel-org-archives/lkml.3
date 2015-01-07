Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbbAGHsk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 02:48:40 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:51499 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbbAGHsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 02:48:39 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <linux@arm.linux.org.uk>, <mingo@redhat.com>, <x86@kernel.org>,
        <masami.hiramatsu.pt@hitachi.com>, <anil.s.keshavamurthy@intel.com>,
        <davem@davemloft.net>, <ananth@in.ibm.com>, <dave.long@linaro.org>,
        <tixy@linaro.org>
CC: <lizefan@huawei.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 11/11] kprobes: add CONFIG_EARLY_KPROBES option.
Date: Wed, 7 Jan 2015 15:42:13 +0800
Message-ID: <1420616533-43585-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1420616086-42692-1-git-send-email-wangnan0@huawei.com>
References: <1420616086-42692-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020205.54ACE496.0199,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 8b3211567c861867b23efb286d139e18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable early kprobes in Kconfig.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
---
 arch/Kconfig | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/Kconfig b/arch/Kconfig
index 05d7a8a..06dff4b 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -46,6 +46,18 @@ config KPROBES
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
 
+config EARLY_KPROBES
+	depends on KPROBES && OPTPROBES
+	def_bool y
+
+config NR_EARLY_KPROBES_SLOTS
+	int "Number of possible early kprobes"
+	range 1 64
+	default 16
+	depends on EARLY_KPROBES
+	help
+	  Number of early kprobes slots.
+
 config JUMP_LABEL
        bool "Optimize very unlikely/likely branches"
        depends on HAVE_ARCH_JUMP_LABEL
-- 
1.8.4

