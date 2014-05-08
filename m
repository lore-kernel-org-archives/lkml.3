Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbaEHMyk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 08:54:40 -0400
Received: from www.linutronix.de ([62.245.132.108]:55103 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205AbaEHMyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 08:54:39 -0400
Date: Thu, 8 May 2014 14:54:52 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Anvin <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 29/32] genirq: Remove irq_reserve_irq[s]
In-Reply-To: <20140508121443.4E71CC40D85@trevor.secretlab.ca>
Message-ID: <alpine.DEB.2.02.1405081453560.6261@ionos.tec.linutronix.de>
References: <20140507153622.703412101@linutronix.de> <20140507154340.302183048@linutronix.de> <20140508121443.4E71CC40D85@trevor.secretlab.ca>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2014, Grant Likely wrote:

> On Wed, 07 May 2014 15:44:21 -0000, Thomas Gleixner <tglx@linutronix.de> wrote:
> > No more users. And it's not going to come back. If you need
> > hotplugable irq chips, use irq domains.
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> 
> The ironic thing is that irq_domain may end up bringing this function
> back in some form as an optimization for irq_domains that need a
> contiguous range, but don't want to allocate all the irq_descs
> immediately. But if that happens it will be a very private API and it
> doesn't nullify removing the function now.

Right. We can deal with it when the need arises, but that's a
completely core internal issue then which is not going to be usable
outside of kernel/irq.

Thanks,

	tglx
