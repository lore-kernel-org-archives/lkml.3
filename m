Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934374AbaJ2Qet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 12:34:49 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51744 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933750AbaJ2Qer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 12:34:47 -0400
Date: Wed, 29 Oct 2014 11:34:45 -0500
From: Benoit Parrot <bparrot@ti.com>
To: Pantelis Antoniou <pantelis.antoniou@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>, <linux-gpio@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [RFC Patch] gpio: add GPIO hogging mechanism
Message-ID: <20141029163445.GB29965@ti.com>
References: <1413922198-29373-1-git-send-email-bparrot@ti.com>
 <3D00ADB3-00B3-40A8-8263-444BCADDAC33@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3D00ADB3-00B3-40A8-8263-444BCADDAC33@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pantelis,

Thanks for the feedback.

Pantelis Antoniou <pantelis.antoniou@gmail.com> wrote on Wed [2014-Oct-29 10:53:44 +0200]:
> Hi Benoit,
> 
> > On Oct 21, 2014, at 23:09 , Benoit Parrot <bparrot@ti.com> wrote:
> > 
> > Based on Boris Brezillion work this is a reworked patch
> > of his initial GPIO hogging mechanism.
> > This patch provides a way to initally configure specific GPIO
> > when the gpio controller is probe.
> > 
> > The actual DT scanning to collect the GPIO specific data is performed
> > as part of the gpiochip_add().
> > 
> > The purpose of this is to allows specific GPIOs to be configured
> > without any driver specific code.
> > This particularly usueful because board design are getting
> > increassingly complex and given SoC pins can now have upward
> > of 10 mux values a lot of connections are now dependent on
> > external IO muxes to switch various modes and combination.
> > 
> > Specific drivers should not necessarily need to be aware of
> > what accounts to a specific board implementation. This board level
> > "description" should be best kept as part of the dts file.
> > 
> 
> This look like it’s going to the right direction. I have a few general
> comments at first.
> 
> 1) It relies on dubious DT binding of having sub-nodes of the
> gpio device implicitly defining hogs.

I think in this instance the nodes are explicitly defining hogs.
Please clarify. What would you like to see here?
> 
> 2) There is no way for having hogs inserted dynamically as far as I can tell, and
> no way to remove a hog either.

The original patch was allowing that but, Linus's review comment suggested this feature be 
part of the gpio-controller's gpiochip_add() hook only.

> 
> 3) I’m not very fond of having this being part of the gpio controller. This
> configuration conceptually has little to do with the gpio controller per se,
> it is more of a board specific thing. Why not come up with a gpio-hog driver that
> references GPIOs? That way with a single gpio-hog driver instance you could setup
> all the GPIO-hogging configuration for all GPIOs on the board, even one that
> lie on different GPIO controllers.

Again this follows Linus's review comment.
I agree that it prevent a centralize spot where all hog would be defined but it has the advantages of not relying on PROBE_DEFER.
I mean since all "gpio-hogs" would be defined in a single board dts file it would not be that hard to figure out the big picture anyways.

> 
> 
> > Signed-off-by: Benoit Parrot <bparrot@ti.com>
> > ---
> > Documentation/devicetree/bindings/gpio/gpio.txt | 33 +++++++++
> > drivers/gpio/gpiolib-of.c                       | 99 +++++++++++++++++++++++++
> > drivers/gpio/gpiolib.c                          | 81 ++++++++++++++++++++
> > include/linux/of_gpio.h                         | 11 +++
> > 4 files changed, 224 insertions(+)
> > 
> 
> Regards
> 
> — Pantelis
> 

Regards,
Benoit
