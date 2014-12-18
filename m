Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718AbaLRWmN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 17:42:13 -0500
Received: from www.linutronix.de ([62.245.132.108]:60490 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaLRWmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 17:42:12 -0500
Date: Thu, 18 Dec 2014 23:42:03 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jesse Brandeburg <jesse.brandeburg@intel.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] genirq: fix symbol export for __irq_set_affinity
In-Reply-To: <20141218223031.23847.86103.stgit@jbrandeb-cp2.jf.intel.com>
Message-ID: <alpine.DEB.2.11.1412182340300.17382@nanos>
References: <20141218223031.23847.86103.stgit@jbrandeb-cp2.jf.intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Dec 2014, Jesse Brandeburg wrote:

> The function __irq_set_affinity is referenced by interrupt.h
> with static inlines, but if you try to use one of the inlines
> in interrupt.h (for instance to call irq_set_affinity) then
> compile fails due to a missing symbol, when building modules.
> 
> Enabling this function means that kernel drivers can include
> an initial affinity setting for the interrupt, instead of all
> interrupts starting out life on CPU0.  It seems to have just
> been an oversight that it was not included.
> 
> This function and the helpers that call it from interrupt.h were
> already in the kernel API, but if used would then fail to compile
> due to the lack of an export even though already defined via extern.

And why needs this to be called from modules? Just because or is there
a legitimate reason? IOW, you forgot to describe the actual usecase.

Thanks,

	tglx
