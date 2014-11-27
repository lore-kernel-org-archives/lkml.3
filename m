Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485AbaK0Vhw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 16:37:52 -0500
Received: from www.linutronix.de ([62.245.132.108]:58912 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbaK0Vhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 16:37:50 -0500
Date: Thu, 27 Nov 2014 22:37:44 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Thompson <daniel.thompson@linaro.org>
cc: Jason Cooper <jason@lakedaemon.net>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>,
        Tim Sander <tim@krieglstein.org>, Stephen Boyd <sboyd@codeaurora.org>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 3.18-rc4 v11 2/6] irqchip: gic: Optimize locking in
 gic_raise_softirq
In-Reply-To: <1417119024-22844-3-git-send-email-daniel.thompson@linaro.org>
Message-ID: <alpine.DEB.2.11.1411272231450.3961@nanos>
References: <1415968543-29469-1-git-send-email-daniel.thompson@linaro.org> <1417119024-22844-1-git-send-email-daniel.thompson@linaro.org> <1417119024-22844-3-git-send-email-daniel.thompson@linaro.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2014, Daniel Thompson wrote:

> Currently gic_raise_softirq() unconditionally takes and releases a lock
> whose only purpose is to synchronize with the b.L switcher.
> 
> Remove this lock if the b.L switcher is not compiled in.

I think the patches are in the wrong order. We optimize for the sane
use case first, i.e BL=n. So you want to make the locking of
irq_controller_lock in gic_raise_softirq() conditional in the first
place, which should have been done when this was introduced.

Once you have isolated that you can apply your split lock patch for
the BL=y nonsense.

Adding more locks first and then optimizing them out does not make any
sense.

Thanks,

	tglx
