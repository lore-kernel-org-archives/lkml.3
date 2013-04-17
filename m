Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966694Ab3DQOjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 10:39:45 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:36103 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966466Ab3DQOjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 10:39:44 -0400
Message-ID: <1366209583.28609.35.camel@joe-AO722>
Subject: Re: [PATCH] usb: storage: Add usb_stor_dbg, reduce object size
From: Joe Perches <joe@perches.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        usb-storage <usb-storage@lists.one-eyed-alien.net>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 17 Apr 2013 07:39:43 -0700
In-Reply-To: <Pine.LNX.4.44L0.1304171012270.1623-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1304171012270.1623-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-17 at 10:14 -0400, Alan Stern wrote:
> On Tue, 16 Apr 2013, Joe Perches wrote:
> > Reduce the size of the objects by consolidating
> > the duplicated USB_STORAGE into a single function.
[]
> Is there any reasonable way to change this so that US_DEBUGP gets
> converted to a dev_dbg call instead of a printk call?  Not including
> the device identifier in the output can be a real problem if there are
> multiple mass-storage devices in the system.

No.

There's no standardized name of a struct device *.
struct us_data *us exists for most of them but not
all.  Some have a struct isd_200 *info available,
other don't have a struct device * at all.

Some or all US_DEBUGP calls would have to change
form.

Perhaps a good patch would be to convert US_DEBUGP
calls where a struct us_data * is available to
to us_stor_dbg(struct us_data *, const char *fmt, ...)



