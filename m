Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334AbaDXOJG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 10:09:06 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:55293 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757AbaDXOJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 10:09:01 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDyKFr02yyhGNncYX2AgBXTA3Sc0AGQcExjtLvQ5QU0_=YJwg@mail.gmail.com>
References: <1398334403-26181-1-git-send-email-geert+renesas@glider.be>
	<1398334403-26181-4-git-send-email-geert+renesas@glider.be>
	<CAPDyKFr02yyhGNncYX2AgBXTA3Sc0AGQcExjtLvQ5QU0_=YJwg@mail.gmail.com>
Date: Thu, 24 Apr 2014 16:09:00 +0200
X-Google-Sender-Auth: lak9z_qkksoYZTqiWSWaqGreojo
Message-ID: <CAMuHMdV=g13MnhhUDk9CFT+J5QPEryzO9HRSJFALJMfKi1Dn8w@mail.gmail.com>
Subject: Re: [PATCH/RFC 3/4] of/clk: Register clocks suitable for Runtime PM
 with the PM core
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
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

Hi Ulf,

On Thu, Apr 24, 2014 at 3:11 PM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
>> +static int of_clk_register(struct device *dev, struct clk *clk)
>> +{
>> +       int error;
>> +
>> +       if (!dev->pm_domain) {
>> +               error = pm_clk_create(dev);
>> +               if (error)
>> +                       return error;
>> +
>> +               dev->pm_domain = &of_clk_pm_domain;
>
> I am concerned about how this will work in conjunction with the
> generic power domain.
>
> A device can't reside in more than one pm_domain; thus I think it
> would be better to always use the generic power domain and not have a
> specific one for clocks. Typically the genpd should invoke
> pm_clk_resume|suspend from it's runtime PM callbacks.

On shmobile SoCs supporting power domains, the power domain is
overridden later by calling rmobile_add_devices_to_domains() and friends.

My patch doesn't change that: the code behaved the same in the
non-multi-platform case before: dev->pm_domain as set from
drivers/sh/pm_runtime.c was overridden later.

I'll have a deeper look into the power domain code later anyway.

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
