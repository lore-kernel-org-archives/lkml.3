Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbaB0K7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 05:59:19 -0500
Received: from www.linutronix.de ([62.245.132.108]:51805 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbaB0K7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 05:59:18 -0500
Date: Thu, 27 Feb 2014 11:59:15 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: James Hogan <james.hogan@imgtec.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        metag <linux-metag@vger.kernel.org>
Subject: Re: [patch 06/26] metag: Use irq_set_affinity instead of homebrewn
 code
In-Reply-To: <1649567.LUiB1QnacO@radagast>
Message-ID: <alpine.DEB.2.02.1402271158170.4174@ionos.tec.linutronix.de>
References: <20140223212703.511977310@linutronix.de> <530B47FD.80608@imgtec.com> <alpine.DEB.2.02.1402241432360.21251@ionos.tec.linutronix.de> <1649567.LUiB1QnacO@radagast>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Feb 2014, James Hogan wrote:
> > You need that irq-metag part in any case as the user space interface
> > does not filter out stuff. Assume you offlined core 1 and user changes
> > affinity from 0xf to 0xe. So your selector will pick core 1 which is
> > offline....
> 
> ... crap, you're absolutely right. Thanks for spotting that. I'll apply the 
> irqchip hunks for v3.14.
> 
> As for the rest, I'll take this patch (with the irq.c hunk below)
> through the metag tree if it's okay with you so I can make sure it
> goes after the irqchip fixes (otherwise cpu0 hotplug blows up too).

Fine with me.

Thanks,

	tglx
