Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbaKRIcX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 03:32:23 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:53127 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770AbaKRIcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 03:32:19 -0500
MIME-Version: 1.0
In-Reply-To: <7h61edyxkq.fsf@deeprootsystems.com>
References: <1415917702-6742-1-git-send-email-khilman@kernel.org>
	<6465990.KKns6W8hQE@vostro.rjw.lan>
	<7hioid3cqx.fsf@deeprootsystems.com>
	<1452958.d0yJE5gVgq@vostro.rjw.lan>
	<7h61edyxkq.fsf@deeprootsystems.com>
Date: Tue, 18 Nov 2014 09:32:17 +0100
X-Google-Sender-Auth: uz2ic79pL52672XxrtDP_OKgStc
Message-ID: <CAMuHMdW2o4HKfRei56ntT9h1wYAs+cyaW14C9wtBVXvooLbpsQ@mail.gmail.com>
Subject: Re: [PATCH] PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is selected
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kevin Hilman <khilman@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Linux PM list <linux-pm@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 4:52 AM, Kevin Hilman <khilman@kernel.org> wrote:
> "Rafael J. Wysocki" <rjw@rjwysocki.net> writes:
>
>> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>
>> The number of and dependencies between high-level power management
>> Kconfig options make life much harder than necessary.  Several
>> conbinations of them have to be tested and supported, even though
>> some of those combinations are very rarely used in practice (it
>> they are used in practice at all).  Moreover, the fact that we
>> have separate independent Kconfig options for runtime PM and
>> system suspend is a serious obscacle for integration between
>> the two frameworks.
>>
>> To overcome these difficulties, always select PM_RUNTIME if PM_SLEEP
>> is set.  Among other things, this will allow system suspend callbacks
>> provided by bus types and device drivers to rely on the runtime PM
>> framework regardless of the kernel configuration.
>>
>> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> ---
>>
>> As a follow up.
>>
>> Note that we won't need the patch making genpd select PM_RUNTIME with this,
>> because genpd already depends on PM.
>>
>> Thoughts, comments?
>
> Acked-by: Kevin Hilman <khilman@linaro.org>

This gets rid of

kernel/power/Kconfig:132:error: recursive dependency detected!
kernel/power/Kconfig:132: symbol PM_RUNTIME is selected by PM_GENERIC_DOMAINS
kernel/power/Kconfig:272: symbol PM_GENERIC_DOMAINS is selected by PM_RUNTIME

Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
