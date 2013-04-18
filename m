Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967460Ab3DRO5P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 10:57:15 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:60504 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S966221Ab3DRO5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 10:57:13 -0400
Date: Thu, 18 Apr 2013 10:57:12 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Joe Perches <joe@perches.com>, Kay Sievers <kay.sievers@vrfy.org>
cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: storage: Add usb_stor_dbg, reduce object size
In-Reply-To: <1366244319.28609.57.camel@joe-AO722>
Message-ID: <Pine.LNX.4.44L0.1304181054340.1525-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Apr 2013, Joe Perches wrote:

> On Wed, 2013-04-17 at 14:47 -0400, Alan Stern wrote:
> > On Wed, 17 Apr 2013, Joe Perches wrote:
> []
> > > +int usb_stor_dbg(const struct us_data *us, const char *fmt, ...)
> > > +{
> > > +     struct va_format vaf;
> > > +     va_list args;
> > > +     int r;
> > > +
> > > +     va_start(args, fmt);
> > > +
> > > +     if (us && us->pusb_dev) {
> > > +             r = dev_vprintk_emit(7, &us->pusb_dev->dev, fmt, args);
> > 
> > Isn't there a symbolic constant you can use instead of "7"?
> 
> Nope.
> lib/dynamic_debug:__dynamic_dev_dbg() does the same thing.

This clearly is an omission in the logging API.

Kay, why doesn't the kernel have symbolic constants for the various
logging facilities and levels?

Alan Stern

