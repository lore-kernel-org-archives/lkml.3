Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946045AbaD3WRm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 18:17:42 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:37020 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422672AbaD3WRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 18:17:40 -0400
MIME-Version: 1.0
In-Reply-To: <4116377.A5MWbYX2Mh@avalon>
References: <1398334403-26181-1-git-send-email-geert+renesas@glider.be>
	<4116377.A5MWbYX2Mh@avalon>
Date: Thu, 1 May 2014 00:17:39 +0200
X-Google-Sender-Auth: yPtd-VIr0kUMZMDTME2LUKHQU90
Message-ID: <CAMuHMdVyQtJvC0G7i5DTYgW0eO3wuwqnvv0tSVA8BMzDkLG+zg@mail.gmail.com>
Subject: Re: [PATCH/RFC 0/4] of: Register clocks for Runtime PM with PM core
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Felipe Balbi <balbi@ti.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Wed, Apr 30, 2014 at 11:29 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Thursday 24 April 2014 12:13:19 Geert Uytterhoeven wrote:
>> On SoCs like ARM/SH-mobile, gate clocks are available for modules, allowing
>> Runtime PM for a device controlled by a gate clock.
>>
>> On legacy shmobile kernels, this is handled by the PM runtime code in
>> drivers/sh/pm_runtime.c, which installs a clock notifier for the platform
>> bus, registering the "NULL" clock of each platform device with the PM core.
>> This approach is also used on davinci, keystone, and omap1.
>
> This requires the device to have the MSTP clock defined as the first clock in
> its DT node. I'm not against that, but the requirement should be clearly
> documented, and we need to check existing DT bindings to make sure they comply
> with that.

Being the first clock is only required for the "NULL" clock. And that
is only done
for legacy shmobile kernels, not for multi-platform.

In this patch series, the clock would be chosen based on the presence of the
CLK_RUNTIME_PM flag, to be set by the clock driver. I.e. DT is not involved
directly (for a change... why does everybody think the whole world revolves
 around DT these days ? :-)

> I'd like to also take this as an opportunity to discuss how we should name
> clocks in DT bindings for Renesas devices. Most devices have a single MSTP
> clock, in which case we don't specify a name. Other devices need several
> clocks. Names for the non-MSTP clocks will obviously be device-dependent, but
> how should the MSTP clock be called in that time ? Should it have an empty
> name (a "" string in DT) ? Should it have a standard name ? Maybe "fck" for
> "functional clock" ?

Empty names should not be used if there can be multiple clocks, right?

Grepping in arch/*/boot/dts/, "fck" seems to be popular (only) for TI SoCs.

Stadardizing across SoCs and architectures would be nice, though.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
