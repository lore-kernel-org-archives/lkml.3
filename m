Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab3F0JOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 05:14:36 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:55641 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882Ab3F0JOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 05:14:31 -0400
MIME-Version: 1.0
In-Reply-To: <a459c0b97ea41148af901fc73dbeff98778c7419.1372211451.git.dvhart@linux.intel.com>
References: <cover.1372211451.git.dvhart@linux.intel.com>
	<a459c0b97ea41148af901fc73dbeff98778c7419.1372211451.git.dvhart@linux.intel.com>
Date: Thu, 27 Jun 2013 11:14:30 +0200
Message-ID: <CACRpkda8QGdoAvjsUs7Uu+ukUu7ST63g=H9arA7SS7ceWmMTaQ@mail.gmail.com>
Subject: Re: [PATCH 4/8] minnowboard: Add base platform driver for the MinnowBoard
From: Linus Walleij <linus.walleij@linaro.org>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "peter.p.waskiewicz.jr" <peter.p.waskiewicz.jr@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        danders <danders@circuitco.com>,
        "vishal.l.verma" <vishal.l.verma@intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Grant Likely <grant.likely@linaro.org>,
        Richard Purdie <richard.purdie@linuxfoundation.org>,
        platform-driver-x86 <platform-driver-x86@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 3:53 AM, Darren Hart <dvhart@linux.intel.com> wrote:

> Provide a minimal public interface:
>         minnow_detect()
>         minnow_lvds_detect()
>         minnow_hwid()
>         minnow_phy_reset()

So instead of these calling drivers issueing gpio_request() themselves
to obtain a resource, they make a function call to this proxy that issue
gpio_request() for them.

This is generally not how we do things. A driver should request its
GPIO just as it requests its regulator or clock or IRQ line or anything
else. Centralizing resource handling is not a good idea IMO, it's better
that each driver request it's GPIO pin(s) and do the stuff it needs
with them.

This of course creates the problem of associating the GPIOs to a
driver and how it should look that up, which I guess ACPI can do,
isn't that what acpi_find_gpio() is for?

Yours,
Linus Walleij
