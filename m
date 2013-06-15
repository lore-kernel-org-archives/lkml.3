Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab3FOTs0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 15:48:26 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:53131 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226Ab3FOTsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 15:48:25 -0400
MIME-Version: 1.0
In-Reply-To: <201306152010175395748@gmail.com>
References: <1371047193-14228-1-git-send-email-gabriel.fernandez.st@gmail.com>
	<201306131043366877997@gmail.com>
	<CACRpkdbe+9Bgv+8Lfm2=i=Rd+x08ZdmBwy35NE1JgXOCnqwgWw@mail.gmail.com>
	<201306152010175395748@gmail.com>
Date: Sat, 15 Jun 2013 21:48:25 +0200
Message-ID: <CACRpkdYhGFtX781sqGWV_s93_+BUPCzZJrtx_LmtKOmSFw91vg@mail.gmail.com>
Subject: Re: Re: pinctrl:when two device use the same pin
From: Linus Walleij <linus.walleij@linaro.org>
To: xulinuxkernel <xulinuxkernel@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 15, 2013 at 2:10 PM, xulinuxkernel <xulinuxkernel@gmail.com> wrote:

> In my company,on the chip, the spi nor flash and nand flash use the same
> four pins.In this case,it must be different devices and different drivers.
> In the "Runtime pinmuxing", I think it is one device has two different
> state.

This does not sound like runtime pin muxing.

This sounds like you have *either* a NOT flash *or* a NAND
flash connected to your chip, not both NOR and NAND at the
same time.

Just do not register the device nor add the pinctrl tables
for the one that is not used on a certain target system.
Atleast do not add the pinctrl tables for NOR when using
NAND and vice versa.

> when spi flash use the pin.then nand request the pin it will fail,I just add
> the current(nand) process in an wait queue,after the spi flash pinctl_put,
> spi will wake_up the wait queue.
>
> when nand use the pin,if spi request fail, I add the spi process on the same
> wait queue,when nand release the pin,nand will wake up the wait queue.
> Is that ok?

This sounds like a horribly complicated hack to do something
very simple. Look at the problem from a higher level.

Why do you do this? Obviously you have either NOR or NAND
connected? Don't you know from the system board file or
device tree which one it is?

Yours,
Linus Walleij
