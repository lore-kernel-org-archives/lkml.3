Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbaBDQYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 11:24:45 -0500
Received: from www.linutronix.de ([62.245.132.108]:47454 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbaBDQYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 11:24:44 -0500
Date: Tue, 4 Feb 2014 17:24:37 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
cc: santosh.shilimkar@ti.com, rob@landley.net, linux@arm.linux.org.uk,
        galak@codeaurora.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        daniel.lezcano@linaro.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, grygorii.strashko@ti.com
Subject: Re: [PATCH v4 1/3] clocksource: timer-keystone: introduce clocksource
 driver for Keystone
In-Reply-To: <1391513453-21140-2-git-send-email-ivan.khoronzhuk@ti.com>
Message-ID: <alpine.DEB.2.02.1402041715220.24986@ionos.tec.linutronix.de>
References: <1391513453-21140-1-git-send-email-ivan.khoronzhuk@ti.com> <1391513453-21140-2-git-send-email-ivan.khoronzhuk@ti.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Feb 2014, Ivan Khoronzhuk wrote:
> +	keystone_timer_writel(off, TCR);
> +	/* here we have to be sure the timer has been disabled */
> +	wmb();

We have explicit writew_relaxed and writew. Why open coding the
barriers?

Thanks,

	tglx
