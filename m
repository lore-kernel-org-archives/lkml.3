Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934529Ab3DIIqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 04:46:20 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:51714 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab3DIIqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 04:46:16 -0400
MIME-Version: 1.0
In-Reply-To: <1365441321-21952-3-git-send-email-kevin.strasser@linux.intel.com>
References: <1365441321-21952-1-git-send-email-kevin.strasser@linux.intel.com>
	<1365441321-21952-3-git-send-email-kevin.strasser@linux.intel.com>
Date: Tue, 9 Apr 2013 10:46:15 +0200
Message-ID: <CACRpkdYrGK_SPbiRssFUrg2vMvWbYO_iXsy+aZr99tyFtk88Uw@mail.gmail.com>
Subject: Re: [PATCH 3/4] gpio: Kontron PLD gpio driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Kevin Strasser <kevin.strasser@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Brunner <michael.brunner@kontron.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Wolfram Sang <wsa@the-dreams.de>,
        Ben Dooks <ben-linux@fluff.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        Darren Hart <dvhart@linux.intel.com>, Michael Brunner <mibru@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 8, 2013 at 7:15 PM, Kevin Strasser
<kevin.strasser@linux.intel.com> wrote:

> From: Michael Brunner <michael.brunner@kontron.com>
>
> Add gpio support for the on-board PLD found on some Kontron embedded
> modules.
>
> Signed-off-by: Michael Brunner <michael.brunner@kontron.com>
> Signed-off-by: Kevin Strasser <kevin.strasser@linux.intel.com>

This looks very generic, setting and clearing bits in bytesized
registers.

Can you please attempt to use generic GPIO for this?

drivers/gpio/gpio-generic.c
<linux/basic_mmio_gpio.h>

See for example:
gpio-ep93xx.c, gpio-sodaville.c ...

Since you don't even have IRQ support in this it will be even simpler.

Yours,
Linus Walleij
