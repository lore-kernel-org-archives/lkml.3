Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbaKDSMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 13:12:42 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:55795 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751156AbaKDSMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 13:12:41 -0500
Date: Tue, 4 Nov 2014 18:12:19 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Hans de Goede <hdegoede@redhat.com>,
        linux-sunxi@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/6] clk: sunxi: Add support for sun9i a80 usb clocks and
 resets
Message-ID: <20141104181219.GJ4042@n2100.arm.linux.org.uk>
References: <1415074039-16590-1-git-send-email-wens@csie.org>
 <1415074039-16590-2-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415074039-16590-2-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 12:07:14PM +0800, Chen-Yu Tsai wrote:
> +	spin_lock_irqsave(data->lock, flags);
> +
> +	reg = readl(data->reg);
> +	writel(reg & ~BIT(id), data->reg);
> +
> +	spin_unlock_irqrestore(data->lock, flags);

Don't we have generic support for atomic modification of register
values?  Hmm, we have it for ARM only - atomic_io_modify() and
atomic_io_modify_relaxed().

I guess we should push for those to become cross-arch if we end up
with generic drivers shared between other architectures.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
