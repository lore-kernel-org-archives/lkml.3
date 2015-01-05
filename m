Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbbAEQ11 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 11:27:27 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:54521 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751318AbbAEQ10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 11:27:26 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19aGHW9BXmcyvOXLKvIs+Hi
Date: Mon, 5 Jan 2015 08:23:34 -0800
From: Tony Lindgren <tony@atomide.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, lauraa@codeaurora.org,
        linus.walleij@linaro.org, drake@endlessm.com, loeliger@gmail.com,
        Mark Rutland <mark.rutland@arm.com>, nm@ti.com, khilman@linaro.org
Subject: Re: [PATCH v11 3/9] ARM: l2c: Refactor the driver to use commit-like
 interface
Message-ID: <20150105162332.GC4081@atomide.com>
References: <1420460348-20302-1-git-send-email-m.szyprowski@samsung.com>
 <1420460348-20302-4-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420460348-20302-4-git-send-email-m.szyprowski@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Marek Szyprowski <m.szyprowski@samsung.com> [150105 04:22]:
> From: Tomasz Figa <t.figa@samsung.com>
> 
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
> 
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> [mszyprow: rebased onto 'ARM: l2c: use l2c_write_sec() for restoring
>  latency and filter regs' patch]
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

This version seems to boot just fine on am437x here:

Acked-by: Tony Lindgren <tony@atomide.com>
