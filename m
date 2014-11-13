Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbaKMTLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 14:11:22 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:47795 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbaKMTLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 14:11:19 -0500
MIME-Version: 1.0
In-Reply-To: <5464FBCC.7060307@ti.com>
References: <1415808047-23455-1-git-send-email-grygorii.strashko@ti.com>
	<2997289.NEH22PNoYM@vostro.rjw.lan>
	<5464FBCC.7060307@ti.com>
Date: Thu, 13 Nov 2014 20:11:17 +0100
X-Google-Sender-Auth: lWe4y9LltrhCCPN01_NGJU8DnU0
Message-ID: <CAMuHMdV2JdEhvMsOahaMH8RUO12sit_39AfcWUFD9eGCYCCKGA@mail.gmail.com>
Subject: Re: [PATCH] PM / Domains: restore calling of .suspend/resume_noirq() callbacks
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Linux PM list <linux-pm@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kevin Hilman <khilman@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Krzysztof_Koz=C5=82owski?= <k.kozlowski@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 7:43 PM, Grygorii Strashko
<grygorii.strashko@ti.com> wrote:
> On 11/13/2014 03:33 AM, Rafael J. Wysocki wrote:
>> On Wednesday, November 12, 2014 06:00:47 PM Grygorii Strashko wrote:
>>> Now .suspend/resume_noirq() callbacks will not be called during
>>> system wide suspend/resume for devices which belongs to some GPD.
>>> It seems, that this change was accidentally introduced by
>>> commit d23b9b00cdde ("PM / Domains: Rework system suspend callback
>>>   routines (v2)").
>>
>> I'm not sure if that was really accidentally.
>>
>> Can you describe the problem that the change below is attempting to
>> address, without going to much into the history?  IOW, what's that
>> doesn't work right now?
>
> There are no real issues - now in Kernel there are no users of GPD
> which use "noirq" callbacks.

Indeed.

But as the .suspend_noirq() and .resume_noirq() callbacks are not called
when using the generic PM domain, I had to manually handle interrupt
disable/enable in commit a00d91ea264f974b ("fbdev: sh_mobile_hdmi:
Re-init regs before irq re-enable on resume").

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
