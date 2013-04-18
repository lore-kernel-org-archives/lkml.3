Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936008Ab3DRNl3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 09:41:29 -0400
Received: from mail.active-venture.com ([67.228.131.205]:63122 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934480Ab3DRNl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 09:41:27 -0400
X-Originating-IP: 108.223.40.66
Date: Thu, 18 Apr 2013 06:41:45 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: CodingStyle
Message-ID: <20130418134145.GB2767@roeck-us.net>
References: <24DF37198A1E704D9811D8F72B87EB514191EABF@NB-EX-MBX02.diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24DF37198A1E704D9811D8F72B87EB514191EABF@NB-EX-MBX02.diasemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 10:48:06AM +0000, Opensource [Anthony Olech] wrote:
> > -----Original Message-----
> > From: Guenter Roeck [mailto:linux@roeck-us.net]
> > Sent: 18 April 2013 05:14
> > To: Opensource [Anthony Olech]
> > Cc: Jean Delvare; Mark Brown; Randy Dunlap; lm-sensors@lm-sensors.org;
> > LKML; David Dajun Chen
> > Subject: Re: [NEW DRIVER V5 6/7] drivers/hwmon: DA9058 HWMON driver
> > 
> [...]
> > > +	if (cell == NULL) {
> > > +		ret = -ENODEV;
> > > +		goto exit;
> > 
> > Just return -ENODEV is good enough here. See CodingStyle, chapter 7.
> > 
> [...]
> > > +exit:
> > > +	return ret;
> > > +}
> [...]
> 
> Hi Guenter,
> 
> I have read CodingStyle, chapter 7 and it seems to encourage a single exit point from functions.
> 
Yes, unless you can return directly. There is even an example.
It actually says "... and some common work such as cleanup has to be done".

> During development there was some logging done at the (single) exit point but that has been stripped out for submission.
> Whilst I can duplicate the logging and do an immediate 'return' at all those points, I am hesitant to do so when chapter 7 of the CodingStyle appears to say to use a single exit point. In addition I had thought that a single exit point from functions was a good thing.
> 
Not if you add a goto to a return statement. That defeats the purpose
of easy readability.

Guenter
