Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab3A1Kka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 05:40:30 -0500
Received: from smtp1.goneo.de ([212.90.139.80]:46866 "EHLO smtp1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638Ab3A1Kk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 05:40:27 -0500
X-Spam-Flag: NO
X-Spam-Score: -1.418
From: Lars Poeschel <poeschel@lemonage.de>
To: Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH RFC] misc/at24: distinguish between eeprom and fram chips
Date: Mon, 28 Jan 2013 11:40:15 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-4-amd64; KDE/4.8.4; x86_64; ; )
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org
References: <201212041758.38600.poeschel@lemonage.de> <201212071114.29034.poeschel@lemonage.de> <20130124072701.GG8364@nekote.pengutronix.de>
In-Reply-To: <20130124072701.GG8364@nekote.pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301281140.15289.poeschel@lemonage.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 January 2013 at 08:27:01, Wolfram Sang wrote:
> > > > > > I wanted to use a fm24c04 i2c fram chip with linux. I grepped
> > > > > > the source and found nothing. I later found that my chip can be
> > > > > > handled by at24 eeprom driver. It creates a sysfs file called
> > > > > > eeprom to read from and write to the chip. Userspace has no
> > > > > > chance to distinguish if it is writing an eeprom or a fram
> > > > > > chip.
> > > > > 
> > > > > Why should it?
> > > > 
> > > > Because writes are much faster and it doesn't have to take care on
> > > > erase cycles. It could use other write strategies on such devices
> > > > and update informations that have to survive power downs more
> > > > often.
> > > 
> > > I agree. I think that a seperate attribute named e.g. 'page_size'
> > > would be more helpful than renaming the binary file to fram?
> > 
> > Yes, this is a much better solution! Adding a seperate sysfs file
> > page_size and a file for the type of device which would read eeprom,
> > fram, etc then. If you also think this is the way to go, I would spent
> > one of my next free timeslots to this.
> 
> Oops, this mail seems to have dropped off :(

Luckily I did not have a free timeslot to invest yet. ;)

> I am all for the 'page_size' attribute, but still not convinced what
> gain the 'type' attribute would allow. For FRAM, the page size will be
> large. Isn't this enough information?

Yes, this would be enough information and I think this is the way we should 
go.
I set this on my todo list. Although the change will be quite simple, I think 
I will not find the time to hit the upcoming merge window.

Lars
