Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab3ILMKd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 08:10:33 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:45534 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab3ILMKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 08:10:31 -0400
Message-ID: <5231AEFE.5000206@ti.com>
Date: Thu, 12 Sep 2013 17:39:34 +0530
From: Afzal Mohammed <afzal@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
        Paul Walmsley <paul@pwsan.com>, Benoit Cousson <bcousson@baylibre.com>,
        Russell King <linux@arm.linux.org.uk>,
        Ian Campbell <ian.campbell@citrix.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH RFC 0/6] ARM: OMAP2+: AM43x/AM335x prcm reset driver
References: <cover.1378129416.git.afzal@ti.com>  <1378375634.3948.10.camel@pizza.hi.pengutronix.de>  <5228A99D.4020702@ti.com> <1378717612.4151.6.camel@pizza.hi.pengutronix.de>
In-Reply-To: <1378717612.4151.6.camel@pizza.hi.pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

On Monday 09 September 2013 02:36 PM, Philipp Zabel wrote:

> So if I understand correctly, the only problem is that on OMAP the clock
> needs to be enabled to deassert the reset, but as long as the clock
> domain is in hardware supervised mode, it won't be enabled?

Yes, enabling clock with reset deassertion might not reset the module if
the clock domain is in hardware supervised mode.

> Would it be possible to create an internal API to switch the clock
> domain to software supervised mode, which can be used both by the code
> behind pm_runtime_get_sync and reset_control_deassert?

I will see if that is acceptable.

Another option that would have to be explored is invoking device_reset()
(taking care of clear, deassert & status checking as you suggested)
midway through pm_run_time_get_sync(), when the clockdomain is in
software supervised mode with reset driver taking care of any particular
sequence in the case of multiple reset signals, instead of the IP driver
requiring to take care of it.

Regards
Afzal

