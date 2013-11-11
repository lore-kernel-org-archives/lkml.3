Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab3KKOX2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 09:23:28 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:52606 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979Ab3KKOXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 09:23:17 -0500
Date: Mon, 11 Nov 2013 15:23:14 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] lefover IRQ fixes from v3.12
Message-ID: <20131111142314.GA10282@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq-urgent-for-linus

   # HEAD: bbfe65c219c638e19f1da5adab1005b2d68ca810 genirq: Set the irq thread policy without checking CAP_SYS_NICE

Two (minor) fixlets that missed v3.12.

 Thanks,

	Ingo

------------------>
Randy Dunlap (1):
      irq: DocBook/genericirq.tmpl: Correct various typos

Thomas Pfaff (1):
      genirq: Set the irq thread policy without checking CAP_SYS_NICE


 Documentation/DocBook/genericirq.tmpl | 64 +++++++++++++++++------------------
 kernel/irq/manage.c                   |  2 +-
 2 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/Documentation/DocBook/genericirq.tmpl b/Documentation/DocBook/genericirq.tmpl
index d16d21b..46347f6 100644
--- a/Documentation/DocBook/genericirq.tmpl
+++ b/Documentation/DocBook/genericirq.tmpl
@@ -87,7 +87,7 @@
   <chapter id="rationale">
     <title>Rationale</title>
 	<para>
-	The original implementation of interrupt handling in Linux is using
+	The original implementation of interrupt handling in Linux uses
 	the __do_IRQ() super-handler, which is able to deal with every
 	type of interrupt logic.
 	</para>
@@ -111,19 +111,19 @@
 	</itemizedlist>
 	</para>
 	<para>
-	This split implementation of highlevel IRQ handlers allows us to
+	This split implementation of high-level IRQ handlers allows us to
 	optimize the flow of the interrupt handling for each specific
-	interrupt type. This reduces complexity in that particular codepath
+	interrupt type. This reduces complexity in that particular code path
 	and allows the optimized handling of a given type.
 	</para>
 	<para>
 	The original general IRQ implementation used hw_interrupt_type
 	structures and their ->ack(), ->end() [etc.] callbacks to
 	differentiate the flow control in the super-handler. This leads to
-	a mix of flow logic and lowlevel hardware logic, and it also leads
-	to unnecessary code duplication: for example in i386, there is a
-	ioapic_level_irq and a ioapic_edge_irq irq-type which share many
-	of the lowlevel details but have different flow handling.
+	a mix of flow logic and low-level hardware logic, and it also leads
+	to unnecessary code duplication: for example in i386, there is an
+	ioapic_level_irq and an ioapic_edge_irq IRQ-type which share many
+	of the low-level details but have different flow handling.
 	</para>
 	<para>
 	A more natural abstraction is the clean separation of the
@@ -132,23 +132,23 @@
 	<para>
 	Analysing a couple of architecture's IRQ subsystem implementations
 	reveals that most of them can use a generic set of 'irq flow'
-	methods and only need to add the chip level specific code.
+	methods and only need to add the chip-level specific code.
 	The separation is also valuable for (sub)architectures
-	which need specific quirks in the irq flow itself but not in the
-	chip-details - and thus provides a more transparent IRQ subsystem
+	which need specific quirks in the IRQ flow itself but not in the
+	chip details - and thus provides a more transparent IRQ subsystem
 	design.
 	</para>
 	<para>
-	Each interrupt descriptor is assigned its own highlevel flow
+	Each interrupt descriptor is assigned its own high-level flow
 	handler, which is normally one of the generic
-	implementations. (This highlevel flow handler implementation also
+	implementations. (This high-level flow handler implementation also
 	makes it simple to provide demultiplexing handlers which can be
 	found in embedded platforms on various architectures.)
 	</para>
 	<para>
 	The separation makes the generic interrupt handling layer more
 	flexible and extensible. For example, an (sub)architecture can
-	use a generic irq-flow implementation for 'level type' interrupts
+	use a generic IRQ-flow implementation for 'level type' interrupts
 	and add a (sub)architecture specific 'edge type' implementation.
 	</para>
 	<para>
@@ -172,9 +172,9 @@
     <para>
 	There are three main levels of abstraction in the interrupt code:
 	<orderedlist>
-	  <listitem><para>Highlevel driver API</para></listitem>
-	  <listitem><para>Highlevel IRQ flow handlers</para></listitem>
-	  <listitem><para>Chiplevel hardware encapsulation</para></listitem>
+	  <listitem><para>High-level driver API</para></listitem>
+	  <listitem><para>High-level IRQ flow handlers</para></listitem>
+	  <listitem><para>Chip-level hardware encapsulation</para></listitem>
 	</orderedlist>
     </para>
     <sect1 id="Interrupt_control_flow">
@@ -189,16 +189,16 @@
 	which are assigned to this interrupt.
 	</para>
 	<para>
-	Whenever an interrupt triggers, the lowlevel arch code calls into
-	the generic interrupt code by calling desc->handle_irq().
-	This highlevel IRQ handling function only uses desc->irq_data.chip
+	Whenever an interrupt triggers, the low-level architecture code calls
+	into the generic interrupt code by calling desc->handle_irq().
+	This high-level IRQ handling function only uses desc->irq_data.chip
 	primitives referenced by the assigned chip descriptor structure.
 	</para>
     </sect1>
     <sect1 id="Highlevel_Driver_API">
-	<title>Highlevel Driver API</title>
+	<title>High-level Driver API</title>
 	<para>
-	  The highlevel Driver API consists of following functions:
+	  The high-level Driver API consists of following functions:
 	  <itemizedlist>
 	  <listitem><para>request_irq()</para></listitem>
 	  <listitem><para>free_irq()</para></listitem>
@@ -216,7 +216,7 @@
 	</para>
     </sect1>
     <sect1 id="Highlevel_IRQ_flow_handlers">
-	<title>Highlevel IRQ flow handlers</title>
+	<title>High-level IRQ flow handlers</title>
 	<para>
 	  The generic layer provides a set of pre-defined irq-flow methods:
 	  <itemizedlist>
@@ -228,7 +228,7 @@
 	  <listitem><para>handle_edge_eoi_irq</para></listitem>
 	  <listitem><para>handle_bad_irq</para></listitem>
 	  </itemizedlist>
-	  The interrupt flow handlers (either predefined or architecture
+	  The interrupt flow handlers (either pre-defined or architecture
 	  specific) are assigned to specific interrupts by the architecture
 	  either during bootup or during device initialization.
 	</para>
@@ -297,7 +297,7 @@ desc->irq_data.chip->irq_unmask();
 		<para>
 		handle_fasteoi_irq provides a generic implementation
 		for interrupts, which only need an EOI at the end of
-		the handler
+		the handler.
 		</para>
 		<para>
 		The following control flow is implemented (simplified excerpt):
@@ -394,7 +394,7 @@ if (desc->irq_data.chip->irq_eoi)
 	The generic functions are intended for 'clean' architectures and chips,
 	which have no platform-specific IRQ handling quirks. If an architecture
 	needs to implement quirks on the 'flow' level then it can do so by
-	overriding the highlevel irq-flow handler.
+	overriding the high-level irq-flow handler.
 	</para>
 	</sect2>
 	<sect2 id="Delayed_interrupt_disable">
@@ -419,9 +419,9 @@ if (desc->irq_data.chip->irq_eoi)
 	</sect2>
     </sect1>
     <sect1 id="Chiplevel_hardware_encapsulation">
-	<title>Chiplevel hardware encapsulation</title>
+	<title>Chip-level hardware encapsulation</title>
 	<para>
-	The chip level hardware descriptor structure irq_chip
+	The chip-level hardware descriptor structure irq_chip
 	contains all the direct chip relevant functions, which
 	can be utilized by the irq flow implementations.
 	  <itemizedlist>
@@ -429,14 +429,14 @@ if (desc->irq_data.chip->irq_eoi)
 	  <listitem><para>irq_mask_ack() - Optional, recommended for performance</para></listitem>
 	  <listitem><para>irq_mask()</para></listitem>
 	  <listitem><para>irq_unmask()</para></listitem>
-	  <listitem><para>irq_eoi() - Optional, required for eoi flow handlers</para></listitem>
+	  <listitem><para>irq_eoi() - Optional, required for EOI flow handlers</para></listitem>
 	  <listitem><para>irq_retrigger() - Optional</para></listitem>
 	  <listitem><para>irq_set_type() - Optional</para></listitem>
 	  <listitem><para>irq_set_wake() - Optional</para></listitem>
 	  </itemizedlist>
 	These primitives are strictly intended to mean what they say: ack means
 	ACK, masking means masking of an IRQ line, etc. It is up to the flow
-	handler(s) to use these basic units of lowlevel functionality.
+	handler(s) to use these basic units of low-level functionality.
 	</para>
     </sect1>
   </chapter>
@@ -445,7 +445,7 @@ if (desc->irq_data.chip->irq_eoi)
      <title>__do_IRQ entry point</title>
      <para>
 	The original implementation __do_IRQ() was an alternative entry
-	point for all types of interrupts. It not longer exists.
+	point for all types of interrupts. It no longer exists.
      </para>
      <para>
 	This handler turned out to be not suitable for all
@@ -468,11 +468,11 @@ if (desc->irq_data.chip->irq_eoi)
   <chapter id="genericchip">
      <title>Generic interrupt chip</title>
      <para>
-       To avoid copies of identical implementations of irq chips the
+       To avoid copies of identical implementations of IRQ chips the
        core provides a configurable generic interrupt chip
        implementation. Developers should check carefuly whether the
        generic chip fits their needs before implementing the same
-       functionality slightly different themself.
+       functionality slightly differently themselves.
      </para>
 !Ekernel/irq/generic-chip.c
   </chapter>
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 514bcfd..3e59f95 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -956,7 +956,7 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 			goto out_mput;
 		}
 
-		sched_setscheduler(t, SCHED_FIFO, &param);
+		sched_setscheduler_nocheck(t, SCHED_FIFO, &param);
 
 		/*
 		 * We keep the reference to the task struct even if
