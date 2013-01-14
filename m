Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856Ab3ANLQ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 06:16:27 -0500
Received: from www.linutronix.de ([62.245.132.108]:58485 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623Ab3ANLQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 06:16:27 -0500
Date: Mon, 14 Jan 2013 12:16:24 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chuansheng Liu <chuansheng.liu@intel.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] genirq: Give warning when setup an already-setup non-shared
 irq
In-Reply-To: <1357833301.21958.10.camel@cliu38-desktop-build>
Message-ID: <alpine.LFD.2.02.1301141211500.7475@ionos>
References: <1357833301.21958.10.camel@cliu38-desktop-build>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jan 2013, Chuansheng Liu wrote:
> 
> Meet the case when the request_threaded_irq() with the same irq
> is called twice continually, get the below mismatch info:
> "IRQ handler type mismatch for IRQ 323"

I have no idea where you get that from. The mismatch is printed with:

        if (!(new->flags & IRQF_PROBE_SHARED)) {
	   pr_err("Flags mismatch irq %d. %08x (%s) vs. %08x (%s)\n",
                       irq, new->flags, new->name, old->flags, old->name);

And its only printed when IRQF_PROBE_SHARED is not set. Your change
would cause printouts where no printouts are due and it'd change the
return value from EBUSY to EINVAL.

Thanks,

	tglx
