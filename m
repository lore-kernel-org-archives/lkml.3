Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452AbaIZMCL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 08:02:11 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:43870 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753792AbaIZMCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 08:02:09 -0400
Date: Fri, 26 Sep 2014 13:02:01 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Chenhui Zhao <chenhui.zhao@freescale.com>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, leoli@freescale.com,
        Jason.Jin@freescale.com, Zhuoyu.Zhang@freescale.com
Subject: Re: [PATCH 2/3] pm: add FSM configuration for deep sleep
Message-ID: <20140926120201.GN5182@n2100.arm.linux.org.uk>
References: <1411730703-25836-1-git-send-email-chenhui.zhao@freescale.com> <1411730703-25836-3-git-send-email-chenhui.zhao@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411730703-25836-3-git-send-email-chenhui.zhao@freescale.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 07:25:02PM +0800, Chenhui Zhao wrote:
> +void fsm_write32(void __iomem *addr, u32 val)
> +{
> +#ifdef __arm__
> +	iowrite32be(val, addr);
> +#endif
> +
> +#ifdef __powerpc__
> +	out_be32(addr, val);
> +#endif

The idea of iowrite* is that it should be able to address MMIO or IO
memory irrespective of the platform.  Why is PowerPC not implementing
this accessor, or why can't it be used for PowerPC?

This should just use iowrite32be(), and if it doesn't work on PowerPC,
PowerPC needs to be fixed.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
