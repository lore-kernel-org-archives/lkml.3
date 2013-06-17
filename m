Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab3FQXr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 19:47:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:23342 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737Ab3FQXr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 19:47:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,884,1363158000"; 
   d="scan'208";a="331170237"
Date: Tue, 18 Jun 2013 01:47:23 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Kevin Hilman <khilman@linaro.org>
Cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: twl4030: allow IRQ wake enable to succeed on
 subchip IRQs
Message-ID: <20130617234723.GZ7998@zurbaran>
References: <1370036694-26210-1-git-send-email-khilman@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370036694-26210-1-git-send-email-khilman@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

On Fri, May 31, 2013 at 02:44:54PM -0700, Kevin Hilman wrote:
> The genirq IRQ wake method will default to failure if the irq_chip
> does not provide a set_wake method.  However, for TWL4030 sub-chip
> IRQs, we want the wake enable to succeed even though we don't provide
> a set_wake method.  This allows sub-chip IRQs to still be flagged as
> wakeup capable, and allow them to wakeup from suspend (or abort
> suspend if they fire during suspend.)
> 
> To fix, use the IRQCHIP_SKIP_SET_WAKE flag in the irq_chip.
> 
> Signed-off-by: Kevin Hilman <khilman@linaro.org>
> ---
>  drivers/mfd/twl4030-irq.c | 1 +
>  1 file changed, 1 insertion(+)
Applied to mfd-next, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
