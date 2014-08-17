Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbaHQCFv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 22:05:51 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:51113 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbaHQCFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 22:05:49 -0400
Date: Sun, 17 Aug 2014 10:05:36 +0800
From: Wang YanQing <udknight@gmail.com>
To: Johan Hovold <johan@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, gregkh@linuxfoundation.org,
        jhovold@gmail.com, andi@lisas.de, dforsi@gmail.com,
        gnomes@lxorguk.ukuu.org.uk, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7] usb:serial:pl2303: add GPIOs interface on PL2303
Message-ID: <20140817020536.GA2509@localhost.localdomain>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	gregkh@linuxfoundation.org, jhovold@gmail.com, andi@lisas.de,
	dforsi@gmail.com, gnomes@lxorguk.ukuu.org.uk,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20140809052828.GA28307@udknight>
 <20140812144625.GB9799@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140812144625.GB9799@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johan Hovold.

Another two questions.
	
On Tue, Aug 12, 2014 at 04:46:25PM +0200, Johan Hovold wrote:
> 
> > +	int (*gpio_startup)(struct usb_serial *serial);
> > +	void (*gpio_release)(struct usb_serial *serial);
> 
> This isn't the right place for this abstraction. Most of the setup code
> would be common for any device type with GPIOs.

I assume you mean any pl2303 variant, not any device type, because
no device in drivers/gpio has common setup code except many of them
use struct gpio_chip.

> 
> Just keep the generic gpio_startup and release from v6, and verify that
> ngpio > 0. Any further abstraction should only be added once we know how
> the other types handles GPIOs.

Instead of assume code works for all situation firstly,  test and write
code for only one type device, and make code become generic when we find
it works for others' type.

I don't known which way is better.

Thanks very much for your patient review !!
