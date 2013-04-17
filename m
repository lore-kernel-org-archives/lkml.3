Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966769Ab3DQPGa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 11:06:30 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54474 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S966522Ab3DQPG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 11:06:29 -0400
Date: Wed, 17 Apr 2013 11:06:28 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Joe Perches <joe@perches.com>
cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        usb-storage <usb-storage@lists.one-eyed-alien.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: storage: Add usb_stor_dbg, reduce object size
In-Reply-To: <1366209583.28609.35.camel@joe-AO722>
Message-ID: <Pine.LNX.4.44L0.1304171105360.1623-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Apr 2013, Joe Perches wrote:

> On Wed, 2013-04-17 at 10:14 -0400, Alan Stern wrote:
> > On Tue, 16 Apr 2013, Joe Perches wrote:
> > > Reduce the size of the objects by consolidating
> > > the duplicated USB_STORAGE into a single function.
> []
> > Is there any reasonable way to change this so that US_DEBUGP gets
> > converted to a dev_dbg call instead of a printk call?  Not including
> > the device identifier in the output can be a real problem if there are
> > multiple mass-storage devices in the system.
> 
> No.
> 
> There's no standardized name of a struct device *.
> struct us_data *us exists for most of them but not
> all.  Some have a struct isd_200 *info available,
> other don't have a struct device * at all.
> 
> Some or all US_DEBUGP calls would have to change
> form.
> 
> Perhaps a good patch would be to convert US_DEBUGP
> calls where a struct us_data * is available to
> to us_stor_dbg(struct us_data *, const char *fmt, ...)

That would be an excellent start.

Alan Stern

