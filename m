Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757735AbaJ2XJR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 19:09:17 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:41076 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757279AbaJ2XJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 19:09:16 -0400
Date: Wed, 29 Oct 2014 18:09:12 -0500
From: Benoit Parrot <bparrot@ti.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: <linus.walleij@linaro.org>, <linux-gpio@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [RFC Patch] gpio: add GPIO hogging mechanism
Message-ID: <20141029230912.GF29965@ti.com>
References: <1413922198-29373-1-git-send-email-bparrot@ti.com>
 <20141029104559.GC21251@lukather>
 <20141029164122.GC29965@ti.com>
 <20141029164746.GD21251@lukather>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141029164746.GD21251@lukather>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maxime Ripard <maxime.ripard@free-electrons.com> wrote on Wed [2014-Oct-29 17:47:46 +0100]:
> On Wed, Oct 29, 2014 at 11:41:22AM -0500, Benoit Parrot wrote:
> > Maxime Ripard <maxime.ripard@free-electrons.com> wrote on Wed [2014-Oct-29 11:45:59 +0100]:
> > > Hi,
> > > 
> > > On Tue, Oct 21, 2014 at 03:09:58PM -0500, Benoit Parrot wrote:
> > > > Based on Boris Brezillion work this is a reworked patch
> > > > of his initial GPIO hogging mechanism.
> > > > This patch provides a way to initally configure specific GPIO
> > > > when the gpio controller is probe.
> > > > 
> > > > The actual DT scanning to collect the GPIO specific data is performed
> > > > as part of the gpiochip_add().
> > > > 
> > > > The purpose of this is to allows specific GPIOs to be configured
> > > > without any driver specific code.
> > > > This particularly usueful because board design are getting
> > > > increassingly complex and given SoC pins can now have upward
> > > > of 10 mux values a lot of connections are now dependent on
> > > > external IO muxes to switch various modes and combination.
> > > > 
> > > > Specific drivers should not necessarily need to be aware of
> > > > what accounts to a specific board implementation. This board level
> > > > "description" should be best kept as part of the dts file.
> > > > 
> > > > Signed-off-by: Benoit Parrot <bparrot@ti.com>
> > > 
> > > I've been thinking about this for quite some time, it's good to see
> > > some progress on that :)
> > > 
> > > However, I have a slightly different use case for it: the Allwinner
> > > SoCs have a vdd pin coming in for every gpio bank. Nothing out of the
> > > ordinary so far, except that some of the boards are using a
> > > GPIO-controlled regulator to feed another bank vdd. That obviously
> > > causes a chicken-egg issue, since for the gpio-regulator driver to
> > > probe, it needs to gpio driver, and for the gpio driver to probe, it
> > > needs the regulator driver.
> > 
> > Unless the gpio controlling the vdd pin is from the same bank your
> > trying to power up I do not see the issue here.
> 
> Not the same bank, but the same driver.

How are you currently working around this issue?

> 
> -- 
> Maxime Ripard, Free Electrons
> Embedded Linux, Kernel and Android engineering
> http://free-electrons.com


