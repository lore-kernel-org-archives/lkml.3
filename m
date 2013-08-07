Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007Ab3HGFug (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 01:50:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59876 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756459Ab3HGFuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 01:50:35 -0400
Date: Wed, 7 Aug 2013 14:51:54 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: Can we drop __must_check from driver_for_each_device()?
Message-ID: <20130807055154.GA5304@kroah.com>
References: <1375306513.8170.33.camel@x61.thuisdomein>
 <20130802003157.GA11584@kroah.com>
 <1375821085.7303.33.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1375821085.7303.33.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 10:31:25PM +0200, Paul Bolle wrote:
> On Fri, 2013-08-02 at 08:31 +0800, Greg Kroah-Hartman wrote:
> > On Wed, Jul 31, 2013 at 11:35:13PM +0200, Paul Bolle wrote:
> > > 2) Please note that if the callback always returns zero,
> > > driver_for_each_device() can still return -EINVAL, but only if it was
> > > provided a NULL "drv" (a struct device_driver). It sure seems odd to do
> > > so. Can that actually happen?
> > 
> > Possibly.
> 
> So driver_for_each_device() really should be NULL "drv" safe.

Probably not, now that I think about it some more.  I don't see how that
could ever really happen, do you?

> But wouldn't it therefor be better to make sure the callback functions
> do not return -EINVAL themselves, so -EINVAL will always only indicate
> the NULL "drv" case?

I doubt it's a real need at all.

> > > 3) So to me it looks the __must_check attribute of
> > > driver_for_each_device() can be dropped. Do you agree?
> > 
> > Nope, it should be making people think about the return value of the
> > function.  If they use it or not might be a problem, but I would argue
> > that those call-sites must be fixed, as you point out above.
> 
> I see. I guess I should try to submit patches that do just that.
> 
> > Is this somehow causing a problem that removing the marking would solve
> > for you?
> 
> The, rather trivial, issue I'd like to fix is this (long standing)
> warning:
>     drivers/isdn/hardware/mISDN/hfcpci.c:2298:2: warning: \
>     ignoring return value of ‘driver_for_each_device’, \
>     declared with attribute warn_unused_result [-Wunused-result]
>
> I've submitted a patch to silence that warning about a year ago (see
> https://lkml.org/lkml/2012/9/21/138 ). Dave Miller was pretty clear that
> that approach wouldn't do. (I've added Dave to the CC, just because I
> mentioned him here.)

I agree with David, that patch is pointless.

> So, since this warning is still there, I'm looking for another way to
> get rid of it.

Fix it properly would be good to do, don't you think?

thanks,

greg k-h
