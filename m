Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab3HFUb2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 16:31:28 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:57702 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751824Ab3HFUb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 16:31:27 -0400
Message-ID: <1375821085.7303.33.camel@x61.thuisdomein>
Subject: Re: Can we drop __must_check from driver_for_each_device()?
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Date: Tue, 06 Aug 2013 22:31:25 +0200
In-Reply-To: <20130802003157.GA11584@kroah.com>
References: <1375306513.8170.33.camel@x61.thuisdomein>
	 <20130802003157.GA11584@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 06 Aug 2013 20:31:25.0930 (UTC) FILETIME=[EC41F4A0:01CE92E3]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-02 at 08:31 +0800, Greg Kroah-Hartman wrote:
> On Wed, Jul 31, 2013 at 11:35:13PM +0200, Paul Bolle wrote:
> > 2) Please note that if the callback always returns zero,
> > driver_for_each_device() can still return -EINVAL, but only if it was
> > provided a NULL "drv" (a struct device_driver). It sure seems odd to do
> > so. Can that actually happen?
> 
> Possibly.

So driver_for_each_device() really should be NULL "drv" safe. But
wouldn't it therefor be better to make sure the callback functions do
not return -EINVAL themselves, so -EINVAL will always only indicate the
NULL "drv" case?

> > 3) So to me it looks the __must_check attribute of
> > driver_for_each_device() can be dropped. Do you agree?
> 
> Nope, it should be making people think about the return value of the
> function.  If they use it or not might be a problem, but I would argue
> that those call-sites must be fixed, as you point out above.

I see. I guess I should try to submit patches that do just that.

> Is this somehow causing a problem that removing the marking would solve
> for you?

The, rather trivial, issue I'd like to fix is this (long standing)
warning:
    drivers/isdn/hardware/mISDN/hfcpci.c:2298:2: warning: \
    ignoring return value of ‘driver_for_each_device’, \
    declared with attribute warn_unused_result [-Wunused-result]

I've submitted a patch to silence that warning about a year ago (see
https://lkml.org/lkml/2012/9/21/138 ). Dave Miller was pretty clear that
that approach wouldn't do. (I've added Dave to the CC, just because I
mentioned him here.)

So, since this warning is still there, I'm looking for another way to
get rid of it.

Thanks!


Paul Bolle

