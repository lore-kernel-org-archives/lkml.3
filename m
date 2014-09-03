Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbaICPib (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 11:38:31 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:50743 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756172AbaICPi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 11:38:29 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Wed, 3 Sep 2014 17:37:07 +0200
From: Johan Hovold <johan@kernel.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: Johan Hovold <johan@kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, wsa@the-dreams.de,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-usb@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        linux-gpio@vger.kernel.org, linux-i2c@vger.kernel.org,
        Daniel Baluta <daniel.baluta@intel.com>,
        Laurentiu Palcu <laurentiu.palcu@intel.com>
Subject: Re: [PATCH v2 1/3] mfd: add support for Diolan DLN-2 devices
Message-ID: <20140903153707.GC4894@localhost>
References: <CAE1zot+T6eq0jrL6_Qh=5nihNOgGEaWe5RCDk7_1XS8ZWaWKqA@mail.gmail.com>
 <20140901113949.GP7374@lee--X1>
 <CAE1zotKNBTEMX8DDYwdwOcq0qZgqxZWazE60TUQeiOmD0a4xbA@mail.gmail.com>
 <20140901154626.GH8796@lee--X1>
 <CAE1zotL-cjHqrdymzYhZq24zx+0qGY8-4JnrVZf-TGXDf5Sm3w@mail.gmail.com>
 <20140901175453.GR4894@localhost>
 <20140902080010.GD17117@lee--X1>
 <CAE1zotJzFL0bZvNo4mHK3+EhURarhTPDE5n+SdNzof8Nc-CFew@mail.gmail.com>
 <20140902152311.GY4894@localhost>
 <CAE1zotLnBZ83O23kaDz_xVhhSpPW6YyOQmkaTfZaicmf6MfOdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE1zotLnBZ83O23kaDz_xVhhSpPW6YyOQmkaTfZaicmf6MfOdQ@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 04:39:48PM +0300, Octavian Purdila wrote:
> On Tue, Sep 2, 2014 at 6:23 PM, Johan Hovold <johan@kernel.org> wrote:

> > That should be possible using the regmap bus read and write operations.
> 
> I took a closer look on the regmap bus read/write operations and I
> think they are not fit for what we need in the driver. The driver uses
> a request/response model which, IMHO, does not fit well with a
> register read/write API. Yes, maybe we can emulate it, but why do
> that?
> 
> >> (Also creating a regmap class for a particular device seems over
> >> engineering since nobody else is going to use it)
> >
> > Possibly, but it would allow subdrivers to be implemented using a
> > standard interface and also provide register caching for free.
> 
> Using a standard interface is nice, but I think that using the right
> interface type is more important. This hardware does not use registers
> but a messages to communicate with the OS.

You might be right, and as I mentioned, I haven't looked that closely at
the protocol yet. I'll take a look at your updated I/O interface and how
you use it.

Johan
