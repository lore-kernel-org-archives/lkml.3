Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbaJEX53 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 19:57:29 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:48066 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbaJEX5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 19:57:16 -0400
Message-ID: <1412553433.11091.27.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: Why do we still have 32 bit counters? Interrupt counters
 overflow within 50 days
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2014 16:57:13 -0700
In-Reply-To: <alpine.DEB.2.11.1410051824190.3424@gentwo.org>
References: <alpine.DEB.2.11.1410030435260.8324@gentwo.org>
	 <alpine.DEB.2.11.1410031231420.4383@nanos>
	 <alpine.DEB.2.11.1410030653040.8496@gentwo.org>
	 <20141003120345.GA6652@localhost.localdomain>
	 <alpine.DEB.2.11.1410030706220.8990@gentwo.org>
	 <alpine.DEB.2.11.1410052331420.4383@nanos>
	 <alpine.DEB.2.11.1410051824190.3424@gentwo.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-10-05 at 18:24 -0500, Christoph Lameter wrote:
> Subject: Increase irq counters to 64 bit V2


> -unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
> +u64 kstat_irqs_cpu(unsigned int irq, int cpu)
>  {
>  	struct irq_desc *desc = irq_to_desc(irq);

Well, this can not safely work on 32bit hosts.

Hint : include/linux/u64_stats_sync.h

Or simply use 'unsigned long' as you did in your first patch,
really I don't feel 32bit hosts should care of this.



