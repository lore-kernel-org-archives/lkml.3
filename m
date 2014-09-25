Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbaIYVeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 17:34:00 -0400
Received: from mail.kernel.org ([198.145.19.201]:42882 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817AbaIYVd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 17:33:57 -0400
From: Kevin Hilman <khilman@kernel.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC v2 04/12] PM / Domains: Add genpd attach/detach callbacks
References: <1410893339-6361-1-git-send-email-geert+renesas@glider.be>
	<1410893339-6361-5-git-send-email-geert+renesas@glider.be>
Date: Thu, 25 Sep 2014 14:33:55 -0700
In-Reply-To: <1410893339-6361-5-git-send-email-geert+renesas@glider.be> (Geert
	Uytterhoeven's message of "Tue, 16 Sep 2014 20:48:51 +0200")
Message-ID: <7h61gbbd18.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert+renesas@glider.be> writes:

> While a PM domain can enable PM runtime management of its devices' module
> clocks by setting
>
> 	genpd->dev_ops.stop = pm_clk_suspend;
> 	genpd->dev_ops.start = pm_clk_resume;
>
> this also requires registering the clocks with the pm_clk subsystem.
> In the legacy case, this is handled by the platform code, after
> attaching the device to its PM domain.
>
> When the devices are instantiated from DT, devices are attached to their
> PM domains by generic code, leaving no method for the platform-specific
> PM domain code to register their clocks.
>
> Add two callbacks, allowing a PM domain to perform platform-specific
> tasks when a device is attached to or detached from a PM domain.
>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Nice, I like this approach!

Acked-by: Kevin Hilman <khilman@linaro.org>

Kevin
