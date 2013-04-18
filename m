Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967535Ab3DRQLr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 12:11:47 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59801 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966792Ab3DRQLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 12:11:45 -0400
Message-ID: <1366301504.2119.19.camel@joe-AO722>
Subject: Re: [PATCH] usb: storage: Add usb_stor_dbg, reduce object size
From: Joe Perches <joe@perches.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 18 Apr 2013 09:11:44 -0700
In-Reply-To: <Pine.LNX.4.44L0.1304181054340.1525-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1304181054340.1525-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-18 at 10:57 -0400, Alan Stern wrote:
> On Wed, 17 Apr 2013, Joe Perches wrote:
> 
> > On Wed, 2013-04-17 at 14:47 -0400, Alan Stern wrote:
> > > On Wed, 17 Apr 2013, Joe Perches wrote:
> > []
> > > > +int usb_stor_dbg(const struct us_data *us, const char *fmt, ...)
> > > > +{
> > > > +     struct va_format vaf;
> > > > +     va_list args;
> > > > +     int r;
> > > > +
> > > > +     va_start(args, fmt);
> > > > +
> > > > +     if (us && us->pusb_dev) {
> > > > +             r = dev_vprintk_emit(7, &us->pusb_dev->dev, fmt, args);
> > > 
> > > Isn't there a symbolic constant you can use instead of "7"?
> > 
> > Nope.
> > lib/dynamic_debug:__dynamic_dev_dbg() does the same thing.
> 
> This clearly is an omission in the logging API.
> 
> Kay, why doesn't the kernel have symbolic constants for the various
> logging facilities and levels?

Because they're so _very_ rarely used in decimal form.

printk.c, drivers/base/core.c, and net/core/dev.c
sensibly use - '0', and I think dynamic_debug is the
only other current user.

I suppose a new inline could be created something like

static inline int printk_get_level_decimal(const char *level)
{
	if (printk_get_level(level)) {
		switch (level[1]) {
			case '0' ... '7':
				return level[1] - '0';
		}
	}

	return -1;
}


