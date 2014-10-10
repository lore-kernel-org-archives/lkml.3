Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbaJJQRa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 12:17:30 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:50897 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbaJJQR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 12:17:27 -0400
Date: Fri, 10 Oct 2014 17:17:18 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Muthu Mani <muth@cypress.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Wolfram Sang <wsa@the-dreams.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajaram Regupathy <rera@cypress.com>, Johan Hovold <johan@kernel.org>
Subject: Re: [PATCH v3 1/3] mfd: add support for Cypress CYUSBS234 USB Serial
 Bridge controller
Message-ID: <20141010161718.GA8767@lee--X1>
References: <1412606587-3323-1-git-send-email-muth@cypress.com>
 <20141009074029.GL20647@lee--X1>
 <db79d07038e44d428f8ca6d82508d4ad@BN1PR06MB069.namprd06.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <db79d07038e44d428f8ca6d82508d4ad@BN1PR06MB069.namprd06.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > -----Original Message-----
> > From: Lee Jones [mailto:lee.jones@linaro.org]
> > Sent: Thursday, October 09, 2014 1:10 PM
> > To: Muthu Mani
> > Cc: Samuel Ortiz; Wolfram Sang; Linus Walleij; Alexandre Courbot;
> > gregkh@linuxfoundation.org; linux-i2c@vger.kernel.org; linux-
> > gpio@vger.kernel.org; linux-usb@vger.kernel.org; linux-
> > kernel@vger.kernel.org; Rajaram Regupathy; Johan Hovold
> > Subject: Re: [PATCH v3 1/3] mfd: add support for Cypress CYUSBS234 USB
> > Serial Bridge controller

Why is this in here?

> > > +     cyusbs->usb_dev = usb_get_dev(interface_to_usbdev(interface));
> > 
> > Can you do this last?  Then you can remove the 'error' error path.
> 
> mfd_add_devices would utlimately invoke the cell drivers' probe before returning and cell drivers use usb_dev in their probe.
> So, leaving it as such.

Can you move it down to just about mfd_add_devices() then.  That way
can you at least return directly in the other error paths.

[...]

> > > +MODULE_AUTHOR("Rajaram Regupathy <rera@cypress.com>");
> > > +MODULE_AUTHOR("Muthu Mani <muth@cypress.com>");
> > > +MODULE_DESCRIPTION("Cypress CYUSBS23x mfd core driver");
> > 
> > s/mfd/MFD/
> 
> Is there a typo?

Yes mfd should be MFD, as I sed (spelt this way on purpose).

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
