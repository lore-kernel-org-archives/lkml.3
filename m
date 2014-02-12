Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbaBLPqB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 10:46:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883AbaBLPp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 10:45:59 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 1/4] Clean asm/system.h from docs
From: David Howells <dhowells@redhat.com>
To: akpm@linux-foundation.org
Cc: dhowells@redhat.com, linux-arch@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        arnd@arndb.de
Date: Wed, 12 Feb 2014 15:45:51 +0000
Message-ID: <20140212154551.2405.20935.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140212154544.2405.2992.stgit@warthog.procyon.org.uk>
References: <20140212154544.2405.2992.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean asm/system.h from docs as nothing should refer to that header anymore.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Ingo Molnar <mingo@redhat.com>
---

 Documentation/DocBook/kernel-hacking.tmpl |    2 +-
 Documentation/irqflags-tracing.txt        |    7 -------
 Documentation/scheduler/sched-arch.txt    |    2 +-
 3 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/Documentation/DocBook/kernel-hacking.tmpl b/Documentation/DocBook/kernel-hacking.tmpl
index d0758b2..b90959b 100644
--- a/Documentation/DocBook/kernel-hacking.tmpl
+++ b/Documentation/DocBook/kernel-hacking.tmpl
@@ -671,7 +671,7 @@ printk(KERN_INFO "my ip: %pI4\n", &amp;ipaddress);
 
   <sect1 id="routines-local-irqs">
    <title><function>local_irq_save()</function>/<function>local_irq_restore()</function>
-    <filename class="headerfile">include/asm/system.h</filename>
+    <filename class="headerfile">include/linux/irqflags.h</filename>
    </title>
 
    <para>
diff --git a/Documentation/irqflags-tracing.txt b/Documentation/irqflags-tracing.txt
index 67aa71e..f6da056 100644
--- a/Documentation/irqflags-tracing.txt
+++ b/Documentation/irqflags-tracing.txt
@@ -22,13 +22,6 @@ rather straightforward and risk-free manner.
 Architectures that want to support this need to do a couple of
 code-organizational changes first:
 
-- move their irq-flags manipulation code from their asm/system.h header
-  to asm/irqflags.h
-
-- rename local_irq_disable()/etc to raw_local_irq_disable()/etc. so that
-  the linux/irqflags.h code can inject callbacks and can construct the
-  real local_irq_disable()/etc APIs.
-
 - add and enable TRACE_IRQFLAGS_SUPPORT in their arch level Kconfig file
 
 and then a couple of functional changes are needed as well to implement
diff --git a/Documentation/scheduler/sched-arch.txt b/Documentation/scheduler/sched-arch.txt
index 9290de7..a2f27bb 100644
--- a/Documentation/scheduler/sched-arch.txt
+++ b/Documentation/scheduler/sched-arch.txt
@@ -8,7 +8,7 @@ Context switch
 By default, the switch_to arch function is called with the runqueue
 locked. This is usually not a problem unless switch_to may need to
 take the runqueue lock. This is usually due to a wake up operation in
-the context switch. See arch/ia64/include/asm/system.h for an example.
+the context switch. See arch/ia64/include/asm/switch_to.h for an example.
 
 To request the scheduler call switch_to with the runqueue unlocked,
 you must `#define __ARCH_WANT_UNLOCKED_CTXSW` in a header file

