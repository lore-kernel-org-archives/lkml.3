Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965218AbaD3VXB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 17:23:01 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:50377 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965185AbaD3VW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 17:22:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Felipe Balbi <balbi@ti.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-sh@vger.kernel.org,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [PATCH/RFC 3/4] of/clk: Register clocks suitable for Runtime PM with the PM core
Date: Wed, 30 Apr 2014 23:23:11 +0200
Message-ID: <2068296.FXWLXn1mqR@avalon>
User-Agent: KMail/4.11.5 (Linux/3.12.13-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAPDyKFr02yyhGNncYX2AgBXTA3Sc0AGQcExjtLvQ5QU0_=YJwg@mail.gmail.com>
References: <1398334403-26181-1-git-send-email-geert+renesas@glider.be> <1398334403-26181-4-git-send-email-geert+renesas@glider.be> <CAPDyKFr02yyhGNncYX2AgBXTA3Sc0AGQcExjtLvQ5QU0_=YJwg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ulf and Geert,

On Thursday 24 April 2014 15:11:24 Ulf Hansson wrote:
> On 24 April 2014 12:13, Geert Uytterhoeven <geert+renesas@glider.be> wrote:
> > When adding a device from DT, check if its clocks are suitable for Runtime
> > PM, and register them with the PM core.
> > If Runtime PM is disabled, just enable the clock.
> > 
> > This allows the PM core to automatically manage gate clocks of devices for
> > Runtime PM.
> 
> Normally I don't think it's a good idea to "automatically" manage
> clocks from PM core or any other place but from the driver (and
> possibly the subsystem).
> 
> The reason is simply that we hide things that normally is supposed to
> be handled by the driver. Typically a cross SOC driver should work
> fine both with and without a pm_domain. It should also not rely on
> CONFIG_PM_RUNTIME.

That's a very good point. Geert, what do you think should happen if 
CONFIG_PM_RUNTIME is not set ? I don't have a strong opinion (yet) on whether 
we could require CONFIG_PM_RUNTIME, but it would indeed be nice to support 
both cases. One option would be to keep the clocks enabled unconditionally in 
that case, as not setting CONFIG_PM_RUNTIME means that the user doesn't care 
(or cares less) about power consumption.

> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

-- 
Regards,

Laurent Pinchart

