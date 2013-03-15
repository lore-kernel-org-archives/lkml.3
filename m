Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab3COJaS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 05:30:18 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:37093 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab3COJaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 05:30:15 -0400
Date: Fri, 15 Mar 2013 10:29:21 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Alan Stern <stern@rowland.harvard.edu>,
        linux-usb@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/6] TTY: port hangup and close fixes
Message-ID: <20130315092921.GC28843@localhost>
References: <51361724.4050107@suse.cz>
 <1362668153-10972-1-git-send-email-jhovold@gmail.com>
 <1363204232.25976.106.camel@thor.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363204232.25976.106.camel@thor.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 03:50:32PM -0400, Peter Hurley wrote:
> On Thu, 2013-03-07 at 15:55 +0100, Johan Hovold wrote:
> > These patches against 3.9-rc1 fix a few issues with tty-port hangup and
> > close.
> > 
> > The first and fifth patch are essentially clean ups.
> > 
> > The second and third patch fix the fact that DTR could get raised
> > (rather than dropped) at hangup if there are blocked opens. [ Note that
> > the second patch has been separated into its own patch and that the
> > third patch is new in v3 of this series. ]
> > 
> > The fourth patch makes sure DTR is dropped also on hangup and that DTR
> > is only dropped for initialised ports (where it could have been raised
> > in the first place).
> > 
> > The sixth and final patch, makes sure no tty callbacks are made from
> > tty_port_close_start when the port has not been initialised (successfully
> > opened). This was previously only done for wait_until_sent but there's
> > no reason to call flush_buffer or to honour port drain delay either.
> > The latter could cause a failed open to stall for up to two seconds.
> > 
> > As a side-effect, these patches also fix an issue in USB-serial where we
> > could get tty-port callbacks on an uninitialised port after having hung
> > up and unregistered a device after disconnect.
> > 
> > Johan
> > 
> > 
> > v3: 
> >  - amend series with fix of DTR sometimes being raised on hang-up
> >  - do not lower DTR on hangup if port tty is gone
> >  - make sure tty in call to shutdown is refcounted
> >  - use cflag-macros throughout
> 
> Other than the comments for patch 3/6, this series looks good. Thanks
> again for your work on this.

As I mentioned in my reply to 3/6, fixing bugs in other drivers not
using the tty-port implementation is all good but not the purpose of
this series.

Thanks,
Johan
