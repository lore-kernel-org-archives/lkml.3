Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbaHVVn1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 17:43:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37103 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbaHVVn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 17:43:26 -0400
Date: Fri, 22 Aug 2014 16:42:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bryan Wu <cooloney@gmail.com>
Cc: Michal Sojka <sojka@merica.cz>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        michal.vokac@comap.cz, Richard Purdie <rpurdie@rpsys.net>,
        Felipe Balbi <balbi@ti.com>, lkml <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/2] leds: usb: Add LED trigger for USB gadget activity
Message-ID: <20140822214244.GA25922@kroah.com>
References: <1408708399-20423-1-git-send-email-sojka@merica.cz>
 <CAK5ve-LaGPgsAVMMMw3=EWpjom5NF29btu0Yxjg=6iwPpioQFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK5ve-LaGPgsAVMMMw3=EWpjom5NF29btu0Yxjg=6iwPpioQFg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 10:39:03AM -0700, Bryan Wu wrote:
> On Fri, Aug 22, 2014 at 4:53 AM, Michal Sojka <sojka@merica.cz> wrote:
> > With this patch, USB gadget activity can be signaled by blinking a LED.
> >
> > Since there is no generic code where to put the trigger for all USB
> > controllers, each USB controller needs to call the trigger individually.
> > This patch adds the call only for the musb controller where I can test
> > it.
> >
> 
> Generally I think one led trigger for both USB host and USB gadget
> activity is good enough. We don't need 2 same led trigger here.

What about systems that have both running at the same time?  Don't you
want individual control?

> And probably you can just put this code in drivers/usb subsystem,
> since this driver is quite simple to add to USB subsystem.

I have no objection to that, if the LED people don't mind it.

thanks,

greg k-h
