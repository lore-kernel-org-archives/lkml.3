Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbaFCJU7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 05:20:59 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:49046 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbaFCJU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 05:20:57 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v1] of/irq: do irq resolution in
 platform_get_irq_byname()
To: Kevin Hilman <khilman@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Chen-Yu Tsai <wens@csie.org>, Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>, Rob Herring <robh@kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Olof Johansson <olof@lixom.net>,
        Thierry Reding <thierry.reding@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <7h7g4zz7s4.fsf@paris.lan>
References: <1400582523-22684-1-git-send-email-grygorii.strashko@ti.com>
	<20140523080333.66720C4176E@trevor.secretlab.ca>
	<CAGa+x85mOHtNAj-UHgK2_z8zWAF=qwFcRcUgHTR-byNiX7heHA@mail.gmail.com>
	<CAL_JsqLm3wfVS+au+JUbhBhxz=LuVpepH6GxabCQhPowhbw77g@mail.gmail.com>
	<20140528071855.GJ4227@lee--X1>
	<CACRpkdYgkEOjLamYu5uKSgs3iTNJ-w5XkbeygKjRdR-bNdETfg@mail.gmail.com>
	<CAGb2v64f8Wju6dtVuVN2x=9YVGA-=RXozzhpJZNspKZ05f=jtA@mail.gmail.com>
	<CACxGe6ts-TcSKk2F0-XSxAxeTxVCiyDHgh-O12v+F2OjHUsPyg@mail.gmail.com>
	<5385B566.2050600@ti.com> <7h7g4zz7s4.fsf@paris.lan>
Date: Tue, 03 Jun 2014 10:20:50 +0100
Message-Id: <20140603092050.F0FD0C40D3B@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Jun 2014 07:48:59 -0700, Kevin Hilman <khilman@linaro.org> wrote:
> Grygorii Strashko <grygorii.strashko@ti.com> writes:
> 
> > Hi All,
> >
> > On 05/28/2014 12:03 PM, Grant Likely wrote:
> 
> [...]
> 
> >> The bisected patch causes platform_get_irq() to always parse the
> >> devicetree to obtain the irq instead of using a precalculated value in
> >> the platform_device. There are two possible scenarios for this problem
> >> that I can think of:
> >> 1) Platform_get_irq() is getting called multiple times (which would
> >> happen on a deferred probe) but the setup code isn't handling it
> >> properly, like trying to request the GPIO more than once
> >> 2) the platform_device was preloaded with an irq number that differs
> >> from what is determined when parsing the tree. This would happen if a
> >> platform_device was created manually.
> >>
> >
> > Could anyone try attached patch? It has to improve situation, but it
> > might not fix all problems (see my previous e-mail).
> 
> I can confirm it makes the STE Snowball boot again on top of next-20150602.
> 
> > From 4a41912dba648c935982274966426fa430fd5aa4 Mon Sep 17 00:00:00 2001
> > From: Grygorii Strashko <grygorii.strashko@ti.com>
> > Date: Wed, 28 May 2014 12:53:34 +0300
> > Subject: [PATCH] mfd: ab8500: fix dt irq mapping
> >
> > The AD8500 defines itself as interrupt-controller in DT,
> > but it doesn't assign DT node to IRQ domain when creates it.
> > As result, of_irq_xx() helpers don't work because they can't
> > find necessary IRQ domain.
> >
> > Hence, fix it by assigning AD8500 core device DT node to IRQ
> > domain when it's created.
> >
> > Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> 
> Tested-by: Kevin Hilman <khilman@linaro.org>

So is that it, or were there other problems? If it is then you can add
my acked-by when applying.

Acked-by: Grant Likely <grant.likely@linaro.org>

