Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab3FRNWn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 09:22:43 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:32931 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440Ab3FRNWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 09:22:42 -0400
Date: Tue, 18 Jun 2013 14:22:35 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, srinidhi.kasagar@stericsson.com
Subject: Re: [PATCH 2/3] ARM: ux500: Correct the EN_3v3 regulator's on/off
 GPIO
Message-ID: <20130618132235.GB31320@laptop>
References: <1371545519-27119-1-git-send-email-lee.jones@linaro.org>
 <1371545519-27119-3-git-send-email-lee.jones@linaro.org>
 <201306181512.58546.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201306181512.58546.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Jun 2013, Arnd Bergmann wrote:

> On Tuesday 18 June 2013, Lee Jones wrote:
> > -                gpios = <&gpio0 26  0x4>; // 26
> > -                startup-delay-us = <5000>;
> > -                enable-active-high;
> > +               regulator-name = "en-3v3-fixed-supply";
> > +               regulator-min-microvolt = <3300000>;
> > +               regulator-max-microvolt = <3300000>;
> > +               /* AB8500 GPIOs start from 1 - offset 25 is GPIO26. */
> > +               gpio = <&ab8500_gpio 25 0x4>;
> 
> Is it intentional that you had "gpios" before and "gpio" after the change
> as the property name?

Yes, it's intentional. See: drivers/regulator/fixed.c

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
