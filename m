Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284Ab3BOWzV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 17:55:21 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:59379 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588Ab3BOWzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 17:55:20 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH RESEND 4/6 v13] gpiolib: Fix default attributes for class
To: Roland Stigge <stigge@antcom.de>, gregkh@linuxfoundation.org,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, plagnioj@jcrosoft.com, highguy@gmail.com,
        broonie@opensource.wolfsonmicro.com, daniel-gl@gmx.net,
        rmallon@gmail.com, sr@denx.de, wg@grandegger.com,
        tru@work-microwave.de, mark.rutland@arm.com
Cc: Roland Stigge <stigge@antcom.de>
In-Reply-To: <1358250716-21986-5-git-send-email-stigge@antcom.de>
References: <1358250716-21986-1-git-send-email-stigge@antcom.de> <1358250716-21986-5-git-send-email-stigge@antcom.de>
Date: Fri, 15 Feb 2013 22:55:14 +0000
Message-Id: <20130215225514.8D54B3E15F8@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2013 12:51:54 +0100, Roland Stigge <stigge@antcom.de> wrote:
> There is a race condition between creating a gpio or gpiochip device and adding
> default attributes. This patch fixes this by defining the default attributes as
> dev_attrs of the class. For this, it was necessary to create a separate
> gpiochip_class besides gpio_class.
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Hi Roland,

Yup, that's a bug. Thanks for looking at this. Unfortunately creating a
new class creates a new problem because it changes the userspace ABI
(the gpiochip simlinks move to a different class directory).

Instead, I think the correct solution here is to use (struct device *)->groups
to add attributes to a device. Unfortunately that means that
create_device() won't work anymore. It does some useful setup work
though that I don't want to have to reproduce. You could create a
variant that also allows groups to be set, or you could factor out the
allocation/setup stuff so we can do an allocate/fixup/register sequence.

g.

