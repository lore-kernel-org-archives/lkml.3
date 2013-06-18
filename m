Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab3FRPRO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 11:17:14 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:39323 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755921Ab3FRPRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 11:17:13 -0400
MIME-Version: 1.0
In-Reply-To: <1371555182-12418-2-git-send-email-mathias.nyman@linux.intel.com>
References: <1371555182-12418-1-git-send-email-mathias.nyman@linux.intel.com>
	<1371555182-12418-2-git-send-email-mathias.nyman@linux.intel.com>
Date: Tue, 18 Jun 2013 17:17:12 +0200
Message-ID: <CACRpkdb2M-TBHbZf=hQE_0ihc4L5amdoFw5QQg2OSFXaMrH8mA@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] pinctrl: add Intel BayTrail GPIO/pinctrl support
From: Linus Walleij <linus.walleij@linaro.org>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 1:33 PM, Mathias Nyman
<mathias.nyman@linux.intel.com> wrote:

> Add support for gpio on Intel BayTrail platforms. BayTrail supports 3 banks
> of gpios called SCORE, NCORE ans SUS with 102, 28 and 44 gpio pins.
> Supports gpio interrupts and ACPI gpio events
>
> Pins may be muxed to alternate function instead of gpio by firmware.
> This driver does not touch the pin muxing and expect firmare
> to set pin muxing and pullup/down properties properly.
>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>

I have a feeling this driver will evolve quite a bit and eventually
register a pure pinctrl interface as well (currently it's only using
the ranges as some data container...)

Anyway, it's a good starting point and obviously (I guess?)
gets your hardware up an ticking, so let's take this as a
starting point.

So patch applied.

This thing only seems to use gpiolib-acpi.c for the basic
device matching and IRQ handling backend, is that correct?

What I'm thinking of moving forward is that I have seen
ACPI fragments with things like "PullUp" etc, which is pinctrl
domain, so we may come to need some generic ACPI helpers
inside drivers/pinctrl as well sooner or later.

Yours,
Linus Walleij
