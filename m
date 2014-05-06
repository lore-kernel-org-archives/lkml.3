Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934383AbaEFHnd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 03:43:33 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:38611 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934229AbaEFHna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 03:43:30 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdUGdfF8x58dz46VWNsC4X0cmFng39Z2xSO_pXYqn9u=HA@mail.gmail.com>
References: <1398334403-26181-1-git-send-email-geert+renesas@glider.be>
	<1398334403-26181-4-git-send-email-geert+renesas@glider.be>
	<CAPDyKFpTwPDu9afhOjhhQ2PKGFB+hWsp=mcaYTq8OvuGF7yT3Q@mail.gmail.com>
	<CAMuHMdUGdfF8x58dz46VWNsC4X0cmFng39Z2xSO_pXYqn9u=HA@mail.gmail.com>
Date: Tue, 6 May 2014 09:43:30 +0200
Message-ID: <CAPDyKFoSOUfgvrKE8x3dih7xvm3VBoNZHjPxWCtFw_h-QALqvw@mail.gmail.com>
Subject: Re: [PATCH/RFC 3/4] of/clk: Register clocks suitable for Runtime PM
 with the PM core
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
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
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 May 2014 16:35, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> Hi Ulf,
>
> On Fri, May 2, 2014 at 10:56 AM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
>>> +static int of_clk_pm_runtime_suspend(struct device *dev)
>>> +{
>>> +       int ret;
>>> +
>>> +       ret = pm_generic_runtime_suspend(dev);
>>> +       if (ret)
>>> +               return ret;
>>> +
>>> +       ret = pm_clk_suspend(dev);
>>
>> What about slow clocks? Those aren't handled with pm_clk_suspend().
>
> How are slow clocks handled?

clk_prepare|unprepare - these functions may sleep.

Kind regards
Ulf Hansson

>
> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
