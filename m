Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab3BLWw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 17:52:29 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:65206 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab3BLWw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 17:52:27 -0500
Date: Tue, 12 Feb 2013 14:52:27 -0800
From: Olof Johansson <olof@lixom.net>
To: Rob Herring <robherring2@gmail.com>
Cc: Doug Anderson <dianders@chromium.org>, arm@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH] ARM: exynos: move exynos4210-combiner to drivers/irqchip
Message-ID: <20130212225227.GA24096@quad.lixom.net>
References: <1360706692-13622-1-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360706692-13622-1-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 04:04:52PM -0600, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> Exynos boot is broken with commit 0529e315 (ARM: use common irqchip_init
> for GIC init). This commit split the irqchip initialization into 2 calls
> to of_irq_init. This does not work because of_irq_init requires interrupt
> parents to be in the match list.
> 
> Rather than reverting exynos changes, make it do the proper thing by using
> IRQCHIP_DECLARE. This requires moving the combiner code to drivers/irqchip.
> 
> Reported-by: Doug Anderson <dianders@chromium.org>
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: linux-samsung-soc@vger.kernel.org
> ---
> 
> I thought there may be other platforms broken in the same way, but I
> checked and exynos is the only one.
> 
> This is based on my gic/vic irqchip branch in arm-soc.

Applied to next/cleanup.

I guess this answers whether anyone boots linux-next regularly on Exynos
hardware. :(


-Olof
