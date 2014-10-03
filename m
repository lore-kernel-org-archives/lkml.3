Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbaJCOEo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 10:04:44 -0400
Received: from resqmta-po-09v.sys.comcast.net ([96.114.154.168]:54237 "EHLO
	resqmta-po-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751880AbaJCOEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 10:04:43 -0400
Date: Fri, 3 Oct 2014 09:04:40 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Richard Cochran <richardcochran@gmail.com>
cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: Why do we still have 32 bit counters? Interrupt counters overflow
 within 50 days
In-Reply-To: <20141003121731.GB6652@localhost.localdomain>
Message-ID: <alpine.DEB.2.11.1410030856250.9852@gentwo.org>
References: <alpine.DEB.2.11.1410030435260.8324@gentwo.org> <alpine.DEB.2.11.1410031231420.4383@nanos> <alpine.DEB.2.11.1410030653040.8496@gentwo.org> <20141003120345.GA6652@localhost.localdomain> <alpine.DEB.2.11.1410030706220.8990@gentwo.org>
 <20141003121731.GB6652@localhost.localdomain>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Fine, but the subject line sounded different.

Hmmm.... Found a bug. We need this patch on top

Subject: Fix allocpercpu

Must allocate unsigned long not int.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/kernel/irq/irqdesc.c
===================================================================
--- linux.orig/kernel/irq/irqdesc.c
+++ linux/kernel/irq/irqdesc.c
@@ -140,7 +140,7 @@ static struct irq_desc *alloc_desc(int i
 	if (!desc)
 		return NULL;
 	/* allocate based on nr_cpu_ids */
-	desc->kstat_irqs = alloc_percpu(unsigned int);
+	desc->kstat_irqs = alloc_percpu(unsigned long);
 	if (!desc->kstat_irqs)
 		goto err_desc;

