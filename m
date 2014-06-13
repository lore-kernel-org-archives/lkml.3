Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbaFMS2H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 14:28:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48027 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489AbaFMS2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 14:28:04 -0400
Date: Fri, 13 Jun 2014 11:31:57 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Sascha Silbe <x-linux@infra-silbe.de>, Johan Hovold <jhovold@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: ftdi_sio: add GPIO support
Message-ID: <20140613183157.GA24644@kroah.com>
References: <1402320115-13171-1-git-send-email-x-linux@infra-silbe.de>
 <CACRpkdbiob-2d4sTmj8bZxo5GVZ0TvF5CT_W94BDsSNiEfB7kQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbiob-2d4sTmj8bZxo5GVZ0TvF5CT_W94BDsSNiEfB7kQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 09:25:07AM +0200, Linus Walleij wrote:
> On Mon, Jun 9, 2014 at 3:21 PM, Sascha Silbe <x-linux@infra-silbe.de> wrote:
> 
> > The chips can operate either in regular or in bitbang mode. Care was
> > taken to prevent using GPIOs if the serial device is in use and vice
> > versa.
> 
> Very interesting patch! I've seen USB-based GPIO things before
> but never a dual-mode thing.
> 
> There was already a comment to move the implementation to a
> separate file, which I won't repeat.
> 
> But I also want to bring the device model into question: normally
> when a mother device spawns children across different subsystems
> we model them as MFD devices (drivers/mfd) that instantiate
> children for the different subsystems. So you could spawn a
> serial and a GPIO device from a USB-based hub device there.
> 
> I do not know if that is really apropriate in this case. It seems the
> device is first and foremost FTDI.
> 
> But it could still spawn a child platform device for the GPIO stuff
> so that this can live as a separate driver under drivers/gpio/gpio-ftdi.c
> or similar.
> 
> You could then use something like:
> 
> struct platform_device *gdev;

Ick, no, it's a USB device, do not abuse the platform_device code any
more than it currently is (note, I HATE the platform device code,
someday I'll delete it entirely...  Well, I can dream...)

greg k-h
