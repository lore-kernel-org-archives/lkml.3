Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761370Ab3LISkB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 13:40:01 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:45455 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761325Ab3LISj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 13:39:58 -0500
Date: Mon, 9 Dec 2013 10:37:43 -0800
From: Olof Johansson <olof@lixom.net>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Jon Masters <jonathan@jonmasters.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Patch Tracking <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>
Subject: Re: [RFC part3 PATCH 2/2] ARM64 / clocksource: Use
 arch_timer_acpi_init()
Message-ID: <20131209183743.GA27562@quad.lixom.net>
References: <1386069328-22502-1-git-send-email-hanjun.guo@linaro.org>
 <1386069328-22502-3-git-send-email-hanjun.guo@linaro.org>
 <CACRpkdYeMOMQzDn5=XpDg7X9L_zMZczGg-5SBA8q_WvwFPnH7A@mail.gmail.com>
 <529DE21E.4080707@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <529DE21E.4080707@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 09:52:30PM +0800, Hanjun Guo wrote:
> On 2013年12月03日 20:27, Linus Walleij wrote:
> >On Tue, Dec 3, 2013 at 12:15 PM, Hanjun Guo <hanjun.guo@linaro.org> wrote:
> >
> >>+       /* if can't be initialised from DT, try ACPI way */
> >>+       if (!arch_timer_get_rate())
> >>+               arch_timer_acpi_init();
> >>+
> >>         arch_timer_rate = arch_timer_get_rate();
> >This looks a bit fragile. Having a call like arch_timer_get_rate()
> >to check whether there is a DT node for the timer doesn't seem
> >right, can you refactor the code to provide some
> >has_arch_timer_node() or similar call instead, so it's a bit easier
> >to understand & maintain at least?
> 
> Good point, thanks for the guidance.
> I will introduce has_arch_timer_node() as you said and use
> it as follows:
> 
> if (has_arch_timer_node())
> clocksource_of_init();
> esle
> arch_timer_acpi_init(); /* try ACPI way */
> 
> Is this make sense to you?

Even when we boot with ACPI, the boot stub will still create a minimal
DTB. We should just make sure that the clocksource (which will be
architectured timers anyway, I believe?) is described in that stub.

I would rather do that than have dual-path booting in the lowlevel setup, it
increases test requirements and makes it hard for someone without ACPI hardware
to check for regressions in this code, etc.


-Olof
