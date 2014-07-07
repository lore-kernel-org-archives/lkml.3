Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbaGGKoa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 06:44:30 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:47672 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbaGGKo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 06:44:28 -0400
MIME-Version: 1.0
In-Reply-To: <20140613183157.GA24644@kroah.com>
References: <1402320115-13171-1-git-send-email-x-linux@infra-silbe.de>
	<CACRpkdbiob-2d4sTmj8bZxo5GVZ0TvF5CT_W94BDsSNiEfB7kQ@mail.gmail.com>
	<20140613183157.GA24644@kroah.com>
Date: Mon, 7 Jul 2014 12:44:28 +0200
Message-ID: <CACRpkdYRm1gE5ai05TK17T3bVHKSVEkXeL5Qci8G=Lpt+UYsug@mail.gmail.com>
Subject: Re: [PATCH] USB: ftdi_sio: add GPIO support
From: Linus Walleij <linus.walleij@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sascha Silbe <x-linux@infra-silbe.de>, Johan Hovold <jhovold@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 8:31 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Fri, Jun 13, 2014 at 09:25:07AM +0200, Linus Walleij wrote:

>> But I also want to bring the device model into question: normally
>> when a mother device spawns children across different subsystems
>> we model them as MFD devices (drivers/mfd) that instantiate
>> children for the different subsystems. So you could spawn a
>> serial and a GPIO device from a USB-based hub device there.
>>
>> I do not know if that is really apropriate in this case. It seems the
>> device is first and foremost FTDI.
>>
>> But it could still spawn a child platform device for the GPIO stuff
>> so that this can live as a separate driver under drivers/gpio/gpio-ftdi.c
>> or similar.
>>
>> You could then use something like:
>>
>> struct platform_device *gdev;
>
> Ick, no, it's a USB device, do not abuse the platform_device code any
> more than it currently is (note, I HATE the platform device code,
> someday I'll delete it entirely...  Well, I can dream...)

Haha yeah :-)

However is the MFD cell approach acceptable?

Now MFD cells are platform_devices mind you, but it's
in principle just how that got implemented, MFD cells could
be device-something else.

Yours,
Linus Walleij
