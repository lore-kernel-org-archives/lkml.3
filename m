Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035AbaJ2Ixw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 04:53:52 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:62091 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942AbaJ2Ixu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 04:53:50 -0400
Subject: Re: [RFC Patch] gpio: add GPIO hogging mechanism
Mime-Version: 1.0 (Mac OS X Mail 8.0 \(1990.1\))
Content-Type: text/plain; charset=utf-8
From: Pantelis Antoniou <pantelis.antoniou@gmail.com>
In-Reply-To: <1413922198-29373-1-git-send-email-bparrot@ti.com>
Date: Wed, 29 Oct 2014 10:53:44 +0200
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-gpio@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <3D00ADB3-00B3-40A8-8263-444BCADDAC33@gmail.com>
References: <1413922198-29373-1-git-send-email-bparrot@ti.com>
To: Benoit Parrot <bparrot@ti.com>
X-Mailer: Apple Mail (2.1990.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit,

> On Oct 21, 2014, at 23:09 , Benoit Parrot <bparrot@ti.com> wrote:
> 
> Based on Boris Brezillion work this is a reworked patch
> of his initial GPIO hogging mechanism.
> This patch provides a way to initally configure specific GPIO
> when the gpio controller is probe.
> 
> The actual DT scanning to collect the GPIO specific data is performed
> as part of the gpiochip_add().
> 
> The purpose of this is to allows specific GPIOs to be configured
> without any driver specific code.
> This particularly usueful because board design are getting
> increassingly complex and given SoC pins can now have upward
> of 10 mux values a lot of connections are now dependent on
> external IO muxes to switch various modes and combination.
> 
> Specific drivers should not necessarily need to be aware of
> what accounts to a specific board implementation. This board level
> "description" should be best kept as part of the dts file.
> 

This look like it’s going to the right direction. I have a few general
comments at first.

1) It relies on dubious DT binding of having sub-nodes of the
gpio device implicitly defining hogs.

2) There is no way for having hogs inserted dynamically as far as I can tell, and
no way to remove a hog either.

3) I’m not very fond of having this being part of the gpio controller. This
configuration conceptually has little to do with the gpio controller per se,
it is more of a board specific thing. Why not come up with a gpio-hog driver that
references GPIOs? That way with a single gpio-hog driver instance you could setup
all the GPIO-hogging configuration for all GPIOs on the board, even one that
lie on different GPIO controllers.


> Signed-off-by: Benoit Parrot <bparrot@ti.com>
> ---
> Documentation/devicetree/bindings/gpio/gpio.txt | 33 +++++++++
> drivers/gpio/gpiolib-of.c                       | 99 +++++++++++++++++++++++++
> drivers/gpio/gpiolib.c                          | 81 ++++++++++++++++++++
> include/linux/of_gpio.h                         | 11 +++
> 4 files changed, 224 insertions(+)
> 

Regards

— Pantelis

