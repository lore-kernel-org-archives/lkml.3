Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab3C1N2W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 09:28:22 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33639 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414Ab3C1N2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 09:28:21 -0400
Date: Thu, 28 Mar 2013 14:28:07 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Jonathan Austin <jonathan.austin@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2] irqchip: Add support for ARMv7-M's NVIC
Message-ID: <20130328132807.GA6565@pengutronix.de>
References: <alpine.LFD.2.02.1303122150490.22263@ionos>
 <1363612826-15623-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1363612826-15623-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas,

On Mon, Mar 18, 2013 at 02:20:26PM +0100, Uwe Kleine-König wrote:
> This interrupt controller is found on Cortex-M3 and Cortex-M4 machines.
> 
> Support for this controller appeared in Catalin's Cortex tree based on
> 2.6.33 but was nearly completely rewritten.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
> Hello,
> 
> changes since v1:
> 
>  - fixed base address to match documentation
>    So reading ICTR (which isn't in the nvic's address range) uses a new #define
>    in asm/v7m.h which isn't in mainline yet. That's ugly but I don't have a
>    better idea how to solve it without platform code.
>  - s/NVIC_IPRI/NVIC_IPR/ to match documentation
>  - use pr_warn instead of WARN/WARN_ON
>  - do proper error handling, don't use IS_ERR_VALUE
>  - drop the wrong skipping of the 16 system exceptions. They are not counted in
>    ICTR_INTLINESNUM.
>  - dynamically allocate chip data
>  - drop the irq_domain* member from chip data as it's only used in the probe
>    callback
>  - change compatible string to arm,armv7m-nvic
>  - drop a few unused #includes, use some linux/ #includes instead of asm/ ones
>  - change indention to please tglx' eyes
> 
> A failure to probe the nvic makes the machine unresponsive. Does this 
> have any implications on how the driver should behave when something
> goes wrong? Another issue is that up to now the exception handling
> simply calls asm_do_IRQ(16, ..) for the first nvic interrupt. So there
> is a mismatch if irq_alloc_descs_from(16, ...) doesn't return 16. I
> added error handling for that assuming that's fine for now, but in the long run
> a better fix would be nice. What is the preferred approach to fix that? Use a
> global variable that holds the irq_base? Or should I use a mapping function
> instead?
I didn't hear back from you since I sent out v2. Do you still have some
concerns?

I intend to put the Cortex-M3 stuff into next. Assuming it's just lack
of time on your side that stops you from commenting, would you mind if I
put this patch into next, too?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
