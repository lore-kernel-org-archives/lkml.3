Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab3C0Jkc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 05:40:32 -0400
Received: from www.linutronix.de ([62.245.132.108]:33670 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab3C0Jkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 05:40:31 -0400
Date: Wed, 27 Mar 2013 10:40:28 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mike Turquette <mturquette@linaro.org>
cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4] clk: allow reentrant calls into the clk framework
In-Reply-To: <1364368183-24420-1-git-send-email-mturquette@linaro.org>
Message-ID: <alpine.LFD.2.02.1303270941320.22263@ionos>
References: <1364368183-24420-1-git-send-email-mturquette@linaro.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Mar 2013, Mike Turquette wrote:

> Reentrancy into the clock framework from the clk.h api is necessary
> for clocks that are prepared and unprepared via i2c_transfer (which
> includes many PMICs and discrete audio chips) as well as for several
> other use cases.

That explanation sucks.

Why does an i2c clock need reentrancy? Just because it's i2c or what?

What exactly are the "several other use cases"?

Why do you need the spinlock side reentrant? If a clock is handled by
i2c it hardly can hold the spinlock over a i2c transfer.

A few pointers to code which needs this would be nice as well.

I'm refraining from reviewing the horrible implementation until I get
proper answers to the above questions.

Thanks,

	tglx
