Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968199Ab3DRKpk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 06:45:40 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33719 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967157Ab3DRKpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 06:45:39 -0400
Date: Thu, 18 Apr 2013 11:45:23 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rabin Vincent <rabin@rab.in>, linus.walleij@stericsson.com,
        arnd@arndb.de, Vinod Koul <vinod.koul@intel.com>,
        Per Forlin <per.forlin@stericsson.com>, Dan Williams <djbw@fb.com>
Subject: Re: [PATCH 15/32] dmaengine: ste_dma40: Separate Logical Global
	Interrupt Mask (GIM) unmasking
Message-ID: <20130418104523.GN14496@n2100.arm.linux.org.uk>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org> <1366279934-30761-16-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366279934-30761-16-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 11:11:57AM +0100, Lee Jones wrote:
> +void d40_log_gim_unmask(u32 *src_cfg, u32 *dst_cfg) {
> +
> +	*src_cfg |= 1 << D40_SREG_CFG_LOG_GIM_POS;
> +	*dst_cfg |= 1 << D40_SREG_CFG_LOG_GIM_POS;

So, in patch 3, you started using the BIT() macro.  But here it's fine
not to because... ?

Use one notation or the other, don't mix them together.
