Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbaLWRI5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 12:08:57 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:37942 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaLWRIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 12:08:54 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/JbwIPhsj+V7RP60IzEgfm
Date: Tue, 23 Dec 2014 09:06:13 -0800
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
Subject: Re: [PATCH v10 2/8] ARM: l2c: Refactor the driver to use commit-like
 interface
Message-ID: <20141223170613.GM23854@atomide.com>
References: <1419331716-8972-1-git-send-email-m.szyprowski@samsung.com>
 <1419331716-8972-3-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419331716-8972-3-git-send-email-m.szyprowski@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Marek Szyprowski <m.szyprowski@samsung.com> [141223 02:51]:
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

The first patch of the series applied things boot with no problem.
But after applying this one I get the following on am437x:

Unhandled fault: imprecise external abort (0xc06) at 0xb6f33884

Probably the same issue Nishanth mentioned.

Regards,

Tony
