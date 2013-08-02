Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038Ab3HBHx7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 03:53:59 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:36034 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757858Ab3HBHx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 03:53:58 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18kjoQIUlTNFLJgo3leS9EX
Date: Fri, 2 Aug 2013 00:53:53 -0700
From: Tony Lindgren <tony@atomide.com>
To: Greg KH <greg@kroah.com>
Cc: ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [Ksummit-2013-discuss] [ATTEND] [ARM ATTEND] kernel data bloat
 and how to avoid it
Message-ID: <20130802075352.GY7656@atomide.com>
References: <20130731073802.GT7656@atomide.com>
 <20130731123351.GA30474@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130731123351.GA30474@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH <greg@kroah.com> [130731 05:39]:
> On Wed, Jul 31, 2013 at 12:38:03AM -0700, Tony Lindgren wrote:
> > Hi all,
> > 
> > Probably the biggest kernel data bloat issue is in the ARM land, but
> > it also seems that it's becoming a Linux generic issue too, so I
> > guess it could be discussed in either context.
> 
> Why is it specific to ARM?  What is so unique to ARM that causes it to
> "bloat"?

I think it has so far showed up on ARM because of no discoverable busses,
but chances are it will be more of a generic problem.

> And what exactly do you mean by "bloat"?

Stuffing data to kernel that should not be in the kernel at all. Or
if the data is needed by kernel, there should be only one set of the
data defined rather than multiple copies of the data built into the
kernel for each SoC or driver variant.

> > Basically the data bloat issue is there for the arch code and drivers
> > and may not show up initially until things have headed the wrong way for
> > too long.
> 
> What do you mean by this?  You seem to be very vague here.

People are unnecessarily defining registers in kernel for similar devices
over and over again for each new SoC at the arch level and now more and
more at the driver level.

One example of that are device tree based drivers that don't describe
the actual hardware, but instead have a binding that points to an index
of defined registers in the driver.

One way to avoid these kind of bloat issues is to allow drivers to load
data at multiple points: Only abtolutely minimal set of data should be
static, some should only come from the bootloader as a device tree or
ACPI tables, and some is best to be loaded after booting from /lib/firmware.

Regards,

Tony
