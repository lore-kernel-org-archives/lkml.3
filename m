Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794AbaGGR1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 13:27:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51579 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbaGGR1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 13:27:19 -0400
Date: Mon, 7 Jul 2014 10:31:42 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Sascha Silbe <x-linux@infra-silbe.de>, Johan Hovold <jhovold@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: ftdi_sio: add GPIO support
Message-ID: <20140707173142.GB8693@kroah.com>
References: <1402320115-13171-1-git-send-email-x-linux@infra-silbe.de>
 <CACRpkdbiob-2d4sTmj8bZxo5GVZ0TvF5CT_W94BDsSNiEfB7kQ@mail.gmail.com>
 <20140613183157.GA24644@kroah.com>
 <CACRpkdYRm1gE5ai05TK17T3bVHKSVEkXeL5Qci8G=Lpt+UYsug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYRm1gE5ai05TK17T3bVHKSVEkXeL5Qci8G=Lpt+UYsug@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 12:44:28PM +0200, Linus Walleij wrote:
> On Fri, Jun 13, 2014 at 8:31 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Fri, Jun 13, 2014 at 09:25:07AM +0200, Linus Walleij wrote:
> 
> >> But I also want to bring the device model into question: normally
> >> when a mother device spawns children across different subsystems
> >> we model them as MFD devices (drivers/mfd) that instantiate
> >> children for the different subsystems. So you could spawn a
> >> serial and a GPIO device from a USB-based hub device there.
> >>
> >> I do not know if that is really apropriate in this case. It seems the
> >> device is first and foremost FTDI.
> >>
> >> But it could still spawn a child platform device for the GPIO stuff
> >> so that this can live as a separate driver under drivers/gpio/gpio-ftdi.c
> >> or similar.
> >>
> >> You could then use something like:
> >>
> >> struct platform_device *gdev;
> >
> > Ick, no, it's a USB device, do not abuse the platform_device code any
> > more than it currently is (note, I HATE the platform device code,
> > someday I'll delete it entirely...  Well, I can dream...)
> 
> Haha yeah :-)
> 
> However is the MFD cell approach acceptable?

Yes it is.
