Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab3LSQlZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:41:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43605 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab3LSQlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:41:22 -0500
Date: Thu, 19 Dec 2013 08:41:09 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Boris BREZILLON <b.brezillon@overkiz.com>
Cc: Rob Landley <rob@landley.net>, Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Jiri Prchal <jiri.prchal@aksignal.cz>,
        Ben Gamari <bgamari.foss@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [RFC PATCH] gpio: add GPIO hogging mechanism
Message-ID: <20131219164109.GB27409@kroah.com>
References: <1387463671-1164-1-git-send-email-b.brezillon@overkiz.com>
 <1387463671-1164-2-git-send-email-b.brezillon@overkiz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387463671-1164-2-git-send-email-b.brezillon@overkiz.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 03:34:31PM +0100, Boris BREZILLON wrote:
> GPIO hogging is a way to request and configure specific GPIO without
> explicitly requesting it in the device driver.
> 
> The request and configuration procedure is handled in the core device
> driver code before the driver probe function is called.
> 
> It allows specific GPIOs to be configured without any driver specific code.
> 
> Particularly usefull when a external device is connected to a bus and the
> bus connections depends on an external switch controlled by a GPIO pin.
> Or when some GPIOs have to be exported to sysfs without any userspace
> intervention.
> 
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> ---
>  Documentation/devicetree/bindings/gpio/gpio.txt |   47 ++++++++
>  drivers/base/Makefile                           |    1 +
>  drivers/base/dd.c                               |    5 +
>  drivers/base/gpio.c                             |   59 ++++++++++

I don't understand what makes GPIO's "special" enough to get included in
the driver core like this, and called for each and every device that is
added to the system.

What's wrong with the generic device callbacks/notifiers we already
have?  Why does this need to be in the driver core?  And what exactly
are you doing all of this for in the first place?

greg k-h
