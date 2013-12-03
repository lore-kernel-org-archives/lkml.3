Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab3LCNwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 08:52:54 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:62595 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab3LCNww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 08:52:52 -0500
Message-ID: <529DE21E.4080707@linaro.org>
Date: Tue, 03 Dec 2013 21:52:30 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>,
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
Subject: Re: [RFC part3 PATCH 2/2] ARM64 / clocksource: Use arch_timer_acpi_init()
References: <1386069328-22502-1-git-send-email-hanjun.guo@linaro.org> <1386069328-22502-3-git-send-email-hanjun.guo@linaro.org> <CACRpkdYeMOMQzDn5=XpDg7X9L_zMZczGg-5SBA8q_WvwFPnH7A@mail.gmail.com>
In-Reply-To: <CACRpkdYeMOMQzDn5=XpDg7X9L_zMZczGg-5SBA8q_WvwFPnH7A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年12月03日 20:27, Linus Walleij wrote:
> On Tue, Dec 3, 2013 at 12:15 PM, Hanjun Guo <hanjun.guo@linaro.org> wrote:
>
>> +       /* if can't be initialised from DT, try ACPI way */
>> +       if (!arch_timer_get_rate())
>> +               arch_timer_acpi_init();
>> +
>>          arch_timer_rate = arch_timer_get_rate();
> This looks a bit fragile. Having a call like arch_timer_get_rate()
> to check whether there is a DT node for the timer doesn't seem
> right, can you refactor the code to provide some
> has_arch_timer_node() or similar call instead, so it's a bit easier
> to understand & maintain at least?

Good point, thanks for the guidance.
I will introduce has_arch_timer_node() as you said and use
it as follows:

if (has_arch_timer_node())
clocksource_of_init();
esle
arch_timer_acpi_init(); /* try ACPI way */

Is this make sense to you?

Thanks
Hanjun
