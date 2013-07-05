Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab3GEGaq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 02:30:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:43288 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab3GEGap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 02:30:45 -0400
Date: Fri, 5 Jul 2013 08:30:47 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH] clocksource/cadence_ttc: Reuse clocksource as
 sched_clock
In-Reply-To: <1372888216-10726-1-git-send-email-soren.brinkmann@xilinx.com>
Message-ID: <alpine.DEB.2.02.1307050819000.11637@ionos.tec.linutronix.de>
References: <1372888216-10726-1-git-send-email-soren.brinkmann@xilinx.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Jul 2013, Soren Brinkmann wrote:

> Reuse the TTC clocksource timer as sched clock, too. Since only a single
> sched clock is supported in Linux, this feature optional and can be
> selected through Kconfig.

This changelog doesn't make sense.

There can be only one active sched_clock, but that does no mean, that
you cannot have different implementations compiled in.

So if you disable this config which sched_clock is your kernel using?
And if you enable it, how is guaranteed that you end up with the ttc
sched_clock as the active one? Just due to initcall ordering?

Thanks,

	tglx
