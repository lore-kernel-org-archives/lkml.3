Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423296Ab3FUH5P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 03:57:15 -0400
Received: from www.linutronix.de ([62.245.132.108]:37396 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422804Ab3FUH5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 03:57:14 -0400
Date: Fri, 21 Jun 2013 09:57:10 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Vrabel <david.vrabel@citrix.com>
cc: xen-devel@lists.xen.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/4] time: add a notifier chain for when the system time
 is stepped
In-Reply-To: <1371755792-25962-3-git-send-email-david.vrabel@citrix.com>
Message-ID: <alpine.DEB.2.02.1306210953480.4013@ionos.tec.linutronix.de>
References: <1371755792-25962-1-git-send-email-david.vrabel@citrix.com> <1371755792-25962-3-git-send-email-david.vrabel@citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jun 2013, David Vrabel wrote:

> From: David Vrabel <david.vrabel@citrix.com>
> 
> The high resolution timer code gets notified of step changes to the
> system time with clock_was_set() or clock_was_set_delayed() calls.  If
> other parts of the kernel require similar notification there is no
> clear place to hook into.

You fail to explain why any other part of the kernel requires a
notification.
 
We went great length to confine timekeeping inside the core code and
now you add random notifiers along with totally ugly tasklet
constructs. What for?

Without a reasonable explanation of the problem you are trying to
solve this is going nowhere near the tree.

Thanks,

	tglx
