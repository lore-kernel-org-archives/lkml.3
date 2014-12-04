Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446AbaLDNvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 08:51:23 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:50639 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091AbaLDNvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 08:51:21 -0500
MIME-Version: 1.0
In-Reply-To: <CAPDyKFogROGA+MtQcGNfa052wPKxcs9cpT43NcpcyeGVFCwPoQ@mail.gmail.com>
References: <1417614107-5985-1-git-send-email-geert+renesas@glider.be>
	<1417614107-5985-4-git-send-email-geert+renesas@glider.be>
	<CAPDyKFogROGA+MtQcGNfa052wPKxcs9cpT43NcpcyeGVFCwPoQ@mail.gmail.com>
Date: Thu, 4 Dec 2014 14:51:19 +0100
X-Google-Sender-Auth: pSoESXy9drYAdD13ETE4sYsqwlk
Message-ID: <CAMuHMdVsuCnqwEoP6k4iM0mnsdTiB=d7y4=EAicB_E_ZSec48Q@mail.gmail.com>
Subject: Re: [PATCH v6 3/7] ARM: shmobile: R-Mobile: Enable module clocks if !CONFIG_PM_RUNTIME
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kevin Hilman <khilman@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ulf,

On Thu, Dec 4, 2014 at 2:41 PM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
>> diff --git a/arch/arm/mach-shmobile/pm-rmobile.c b/arch/arm/mach-shmobile/pm-rmobile.c
>> index 168046c355fc8368..6d912ce801aa88bd 100644
>> --- a/arch/arm/mach-shmobile/pm-rmobile.c
>> +++ b/arch/arm/mach-shmobile/pm-rmobile.c
>> @@ -118,6 +118,14 @@ static int rmobile_pd_attach_dev(struct generic_pm_domain *domain,
>>                 goto fail;
>>         }
>>
>> +       if (!IS_ENABLED(CONFIG_PM_RUNTIME)) {
>
> This will require a fixup later on, since using genpd will always be
> done for CONFIG_PM_RUNTIME (or CONFIG_PM actually) ).

Indeed. But this is queued up in a branch that doesn't have the PM unification
yet.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
