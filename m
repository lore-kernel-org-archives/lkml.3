Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab3LCM1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 07:27:25 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:56039 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab3LCM1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 07:27:21 -0500
MIME-Version: 1.0
In-Reply-To: <1386069328-22502-3-git-send-email-hanjun.guo@linaro.org>
References: <1386069328-22502-1-git-send-email-hanjun.guo@linaro.org>
	<1386069328-22502-3-git-send-email-hanjun.guo@linaro.org>
Date: Tue, 3 Dec 2013 13:27:21 +0100
Message-ID: <CACRpkdYeMOMQzDn5=XpDg7X9L_zMZczGg-5SBA8q_WvwFPnH7A@mail.gmail.com>
Subject: Re: [RFC part3 PATCH 2/2] ARM64 / clocksource: Use arch_timer_acpi_init()
From: Linus Walleij <linus.walleij@linaro.org>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 3, 2013 at 12:15 PM, Hanjun Guo <hanjun.guo@linaro.org> wrote:

> +       /* if can't be initialised from DT, try ACPI way */
> +       if (!arch_timer_get_rate())
> +               arch_timer_acpi_init();
> +
>         arch_timer_rate = arch_timer_get_rate();

This looks a bit fragile. Having a call like arch_timer_get_rate()
to check whether there is a DT node for the timer doesn't seem
right, can you refactor the code to provide some
has_arch_timer_node() or similar call instead, so it's a bit easier
to understand & maintain at least?

Yours,
Linus Walleij
