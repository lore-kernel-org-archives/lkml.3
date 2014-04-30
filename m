Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946095AbaD3WGM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 18:06:12 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:38272 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422662AbaD3WGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 18:06:09 -0400
MIME-Version: 1.0
In-Reply-To: <2068296.FXWLXn1mqR@avalon>
References: <1398334403-26181-1-git-send-email-geert+renesas@glider.be>
	<1398334403-26181-4-git-send-email-geert+renesas@glider.be>
	<CAPDyKFr02yyhGNncYX2AgBXTA3Sc0AGQcExjtLvQ5QU0_=YJwg@mail.gmail.com>
	<2068296.FXWLXn1mqR@avalon>
Date: Thu, 1 May 2014 00:06:07 +0200
X-Google-Sender-Auth: 8BsliExv1Frq-zE7eiDC-osu6EU
Message-ID: <CAMuHMdUz9bOx3AMfCQuk8nhW3A_xm1Y8DYi9-yg30iu_j94Vzw@mail.gmail.com>
Subject: Re: [PATCH/RFC 3/4] of/clk: Register clocks suitable for Runtime PM
 with the PM core
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Felipe Balbi <balbi@ti.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Tomasz Figa <tomasz.figa@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Wed, Apr 30, 2014 at 11:23 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Thursday 24 April 2014 15:11:24 Ulf Hansson wrote:
>> On 24 April 2014 12:13, Geert Uytterhoeven <geert+renesas@glider.be> wrote:
>> > When adding a device from DT, check if its clocks are suitable for Runtime
>> > PM, and register them with the PM core.
>> > If Runtime PM is disabled, just enable the clock.
>> >
>> > This allows the PM core to automatically manage gate clocks of devices for
>> > Runtime PM.
>>
>> Normally I don't think it's a good idea to "automatically" manage
>> clocks from PM core or any other place but from the driver (and
>> possibly the subsystem).
>>
>> The reason is simply that we hide things that normally is supposed to
>> be handled by the driver. Typically a cross SOC driver should work
>> fine both with and without a pm_domain. It should also not rely on
>> CONFIG_PM_RUNTIME.
>
> That's a very good point. Geert, what do you think should happen if
> CONFIG_PM_RUNTIME is not set ? I don't have a strong opinion (yet) on whether
> we could require CONFIG_PM_RUNTIME, but it would indeed be nice to support
> both cases. One option would be to keep the clocks enabled unconditionally in
> that case, as not setting CONFIG_PM_RUNTIME means that the user doesn't care
> (or cares less) about power consumption.

This is already handled by my patch. If CONFIG_PM_RUNTIME is disabled,
the clocks are enabled by calling clk_prepare_enabled().

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
