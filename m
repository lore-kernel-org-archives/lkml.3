Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbaHBWJ5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 18:09:57 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:34024 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750995AbaHBWJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 18:09:55 -0400
Date: Sat, 2 Aug 2014 23:09:40 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tomasz Figa <t.figa@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>, lauraa@codeaurora.org,
        linux-omap@vger.kernel.org, linus.walleij@linaro.org,
        santosh.shilimkar@ti.com, tony@atomide.com, drake@endlessm.com,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, loeliger@gmail.com
Subject: Re: [PATCH v3 1/7] ARM: l2c: Refactor the driver to use
	commit-like interface
Message-ID: <20140802220940.GW3705@n2100.arm.linux.org.uk>
References: <1405615142-21426-1-git-send-email-t.figa@samsung.com> <1405615142-21426-2-git-send-email-t.figa@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405615142-21426-2-git-send-email-t.figa@samsung.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 06:38:56PM +0200, Tomasz Figa wrote:
> Certain implementations of secure hypervisors (namely the one found on
> Samsung Exynos-based boards) do not provide access to individual L2C
> registers. This makes the .write_sec()-based interface insufficient and
> provoking ugly hacks.
> 
> This patch is first step to make the driver not rely on availability of
> writes to individual registers. This is achieved by refactoring the
> driver to use a commit-like operation scheme: all register values are
> prepared first and stored in an instance of l2x0_regs struct and then a
> single callback is responsible to flush those values to the hardware.

This isn't going to work very well...

> +static const struct l2c_init_data *l2x0_data;

So you keep a pointer to the init data...

> +static void l2c_resume(void)
> +{
> +	l2x0_data->enable(l2x0_base, l2x0_saved_regs.aux_ctrl,
> +				l2x0_data->num_lock);

which you dereference at resume time...

>  static const struct l2c_init_data l2c210_data __initconst = {

but the structures which get assigned to the pointer are marked __initconst.

That's not going to work very well.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
