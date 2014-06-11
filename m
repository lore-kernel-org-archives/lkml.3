Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbaFKWPS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 18:15:18 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:60793 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbaFKWPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 18:15:16 -0400
Date: Wed, 11 Jun 2014 15:15:13 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Dave Hansen <dave.hansen@intel.com>,
        Zhang Zhen <zhenzhang.zhang@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, laijs@cn.fujitsu.com,
        sjenning@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Wang Nan <wangnan0@huawei.com>
Subject: [patch] mm, hotplug: probe interface is available on several
 platforms
In-Reply-To: <alpine.DEB.2.02.1406111503050.27885@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1406111511450.27885@chino.kir.corp.google.com>
References: <53981D81.5060708@huawei.com> <alpine.DEB.2.02.1406111503050.27885@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation/memory-hotplug.txt incorrectly states that the memory driver 
"probe" interface is only supported on powerpc and is vague about its 
application on x86.  Clarify the platforms that make this interface 
available if memory hotplug is enabled.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 Documentation/memory-hotplug.txt | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/Documentation/memory-hotplug.txt b/Documentation/memory-hotplug.txt
--- a/Documentation/memory-hotplug.txt
+++ b/Documentation/memory-hotplug.txt
@@ -209,15 +209,12 @@ If memory device is found, memory hotplug code will be called.
 
 4.2 Notify memory hot-add event by hand
 ------------
-On powerpc, the firmware does not notify a memory hotplug event to the kernel.
-Therefore, "probe" interface is supported to notify the event to the kernel.
-This interface depends on CONFIG_ARCH_MEMORY_PROBE.
-
-CONFIG_ARCH_MEMORY_PROBE is supported on powerpc only. On x86, this config
-option is disabled by default since ACPI notifies a memory hotplug event to
-the kernel, which performs its hotplug operation as the result. Please
-enable this option if you need the "probe" interface for testing purposes
-on x86.
+On some architectures, the firmware may not notify the kernel of a memory
+hotplug event.  Therefore, the memory "probe" interface is supported to
+explicitly notify the kernel.  This interface depends on
+CONFIG_ARCH_MEMORY_PROBE and can be configured on powerpc, sh, and x86
+if hotplug is supported, although for x86 this should be handled by ACPI
+notification.
 
 Probe interface is located at
 /sys/devices/system/memory/probe
