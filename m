Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263Ab3CGOAU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 09:00:20 -0500
Received: from www.linutronix.de ([62.245.132.108]:49047 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040Ab3CGOAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 09:00:18 -0500
Date: Thu, 7 Mar 2013 15:00:08 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stephen Boyd <sboyd@codeaurora.org>
cc: linux-arm-kernel@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH 01/10] clocksource: add generic dummy timer driver
In-Reply-To: <1362614646-24113-2-git-send-email-sboyd@codeaurora.org>
Message-ID: <alpine.LFD.2.02.1303071457300.22263@ionos>
References: <1362614646-24113-1-git-send-email-sboyd@codeaurora.org> <1362614646-24113-2-git-send-email-sboyd@codeaurora.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Mar 2013, Stephen Boyd wrote:

> +static int __init dummy_timer_register(void)
> +{
> +	int err = register_cpu_notifier(&dummy_timer_cpu_nb);
> +	if (err)
> +		return err;
> +
> +	/* We won't get a call on the boot CPU, so register immediately */
> +	dummy_timer_setup();
> +
> +	return 0;
> +}
> +device_initcall(dummy_timer_register);

Are you sure that you want that to be installed unconditionally? What
about multi-platform kernels?

Thanks,

	tglx
