Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845AbaBFVNN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 16:13:13 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:53596 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756551AbaBFVNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 16:13:10 -0500
Date: Thu, 6 Feb 2014 13:13:08 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@kernel.org>
cc: Michael Dalton <mwdalton@google.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [patch kvmtool] x86, kvmtool: Fix build when KVM_TOOL_TEST_ENABLE
 is set
Message-ID: <alpine.DEB.2.02.1402061307280.9567@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ab7db91705e9 ("virtio-net: auto-tune mergeable rx buffer size for 
improved performance") requires CONFIG_AVERAGE to be set, which is 
selected by CONFIG_VIRTIO_NET, otherwise the build fails:

drivers/built-in.o: In function `virtnet_poll':
virtio_net.c:(.text+0x11d51f): undefined reference to `ewma_add'
drivers/built-in.o: In function `virtnet_probe':
virtio_net.c:(.text+0x11e668): undefined reference to `ewma_init'

CONFIG_KVM_TOOL_TEST_ENABLE selects CONFIG_VIRTIO_NET but not 
CONFIG_AVERAGE so the build breaks when enabling it.

Select CONFIG_AVERAGE for CONFIG_KVMTOOL_TEST_ENABLE.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 Also affects tip/master.

 arch/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -615,6 +615,7 @@ config KVMTOOL_TEST_ENABLE
 	select VIRTIO_BLK
 	select VIRTIO_CONSOLE
 	select VIRTIO_NET
+	select AVERAGE
 	select 9P_FS
 	select NET_9P
 	select NET_9P_VIRTIO
