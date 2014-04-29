Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934038AbaD2Rz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 13:55:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63274 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932491AbaD2Rz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 13:55:26 -0400
From: Daniel Bristot de Oliveira <bristot@redhat.com>
To: linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH RT] netconsole: enable netconsole on PREEMPT_RT
Date: Tue, 29 Apr 2014 14:55:04 -0300
Message-Id: <31fa5b74f8e6267f9b7f906c791d1ddf7d550771.1398788759.git.bristot@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT Folks,

This patch enables the netconsole on PREEMPT_RT_FULL, netconsole
was disabled on commit:
cb7cb77 kconfig-disable-a-few-options-rt.patch

I tested the netconsole on three machines:

- Intel Core i5 (4 cpus) - Local network
- Intel Xeon (32 cpus)   - Remote network
- KVM VM (on a Core i7)  - Virtual network

On these machines I build the kernel 3.10.34-rt34 + netconsole
built as module. In order to execute some printks, I run a small
benchmark that runs as a module. To analyse the output I captured
the netconsole messages using Wireshark.

On all cases, the tests passed without any error:

- No error messages from the kernel
- No missed messages
- No out of order messages

I ran +1 hour tests on each machine. The test using the Xeon machine
ran by around 10 hours. On this test I received 317149 netconsole's
messages.

I also read the code and ran some traces (using the ftrace's
function_graph). In the traces that I read, the netconsole code never
broke the rt lock assumptions.

Signed-off-by: Daniel Bristot de Oliveira <bristot@redhat.com>
---
 drivers/net/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 096de88..3835321 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -164,7 +164,6 @@ config VXLAN
 
 config NETCONSOLE
 	tristate "Network console logging support"
-	depends on !PREEMPT_RT_FULL
 	---help---
 	If you want to log kernel messages over the network, enable this.
 	See <file:Documentation/networking/netconsole.txt> for details.
-- 
1.9.0

