Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325AbaJINCT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 09:02:19 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:48070 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757244AbaJINBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 09:01:42 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Thu, 9 Oct 2014 14:58:44 +0200
From: Johan Hovold <johan@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Johan Hovold <johan@kernel.org>, Muthu Mani <muth@cypress.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Wolfram Sang <wsa@the-dreams.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, gregkh@linuxfoundation.org,
        linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rajaram Regupathy <rera@cypress.com>
Subject: Re: [PATCH v3 1/3] mfd: add support for Cypress CYUSBS234 USB Serial
 Bridge controller
Message-ID: <20141009125844.GM1990@localhost>
References: <1412606587-3323-1-git-send-email-muth@cypress.com>
 <20141009074029.GL20647@lee--X1>
 <20141009081520.GJ1990@localhost>
 <20141009105950.GP20647@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141009105950.GP20647@lee--X1>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 11:59:50AM +0100, Lee Jones wrote:
> On Thu, 09 Oct 2014, Johan Hovold wrote:
> > On Thu, Oct 09, 2014 at 08:40:29AM +0100, Lee Jones wrote:
> > > On Mon, 06 Oct 2014, Muthu Mani wrote:

> > > > diff --git a/include/linux/mfd/cyusbs23x.h b/include/linux/mfd/cyusbs23x.h
> > 
> > > > +/* Serial interfaces (I2C, SPI, UART) differ in interface subclass */
> > > > +enum cy_scb_modes {
> > > > +	CY_USBS_SCB_DISABLED = 0,
> > > > +	CY_USBS_SCB_UART = 1,
> > > > +	CY_USBS_SCB_SPI = 2,
> > > > +	CY_USBS_SCB_I2C = 3
> > > 
> > > No need to number these.
> > 
> > As it's not an arbitrary enumeration, I think they should be initialised
> > explicitly.
> 
> No need.  You are protected by the C Standard:
> 
> 6.7.2.2 Enumeration specifiers
> 
> "If the first enumerator has no =, the value of its enumeration
> constant is 0. Each subsequent enumerator with no = defines its
> enumeration constant as the value of the constant expression obtained
> by adding 1 to the value of the previous enumeration constant."
> 
> There's nothing arbitrary about that.

I obviously wasn't suggesting that the definition of an enum (and the
values of its constants) in c was arbitrary.

My point was that the values of the USB interface subclasses (defined
through the enum) are not arbitrary. In this case they just happen to be
zero-based and consecutive. You cannot reorder, or remove an unused
item, without breaking the driver. By initialising each constant
explicitly this would become apparent.

Using preprocessor defines could be an alternative if you really do not
like initialised enumeration constants.

> > They could be defined in the mfd driver though, as they only
> > appear to be needed during probe.

Johan
