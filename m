Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318AbaHEIkU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 04:40:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:14660 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757245AbaHEIkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 04:40:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,804,1400050800"; 
   d="scan'208";a="553877609"
Date: Tue, 5 Aug 2014 11:40:11 +0300
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Alex Elder <elder@linaro.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, david.daney@cavium.com,
        loic.poulain@intel.com, linux-serial@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: dw8250_set_termios() questions
Message-ID: <20140805084011.GA14504@xps8300>
References: <53BFDF22.1020302@linaro.org>
 <53CFB9D3.8030403@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53CFB9D3.8030403@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

On Wed, Jul 23, 2014 at 08:34:11AM -0500, Alex Elder wrote:
> Heikki, ping.

Sorry for the delay, just came back from vacation.

> On 07/11/2014 07:57 AM, Alex Elder wrote:
> > Heikki, I have not been a subscriber of the linux-serial
> > mailing list and didn't see this patch go by:
> >     serial: 8250_dw: clock rate handling for all ACPI platforms
> >     http://www.spinics.net/lists/linux-serial/msg12861.html
> > 
> > I had been working on doing something very similar for some
> > Broadcom device tree based devices and it might have been
> > helpful for me to have seen it.  What I ended up with was
> > *very* similar to what you did.  Here is the last version
> > of the patch I posted:
> >     https://lkml.org/lkml/2014/7/1/323
> > 
> > There *are* some differences, and I'd like to inquire about
> > them before I simply use the code you have for my purpose.
> > 
> > These first two relate to whether I can use your
> > code as-is:
> > - Why do you skip setting the clock if a null "old"
> >   pointer is supplied?

If there is no "old" the baud rate is not being changed.

> > - I don't believe it's necessary to surround the clock
> >   rate change with clk_disable_unprepare() and
> >   clk_prepare_enable().  Do you believe otherwise?

My clock has CLK_SET_RATE_GATE flag set, so I do need them.

> > This one is addressed to how your code is used now:
> > - Alan Cox had this question about my patch, and
> >   it seems to apply to your code as well:
> >     "This assumes an arbitarily configurable clock,
> >     which is not I think the usual case."
> >     https://lkml.org/lkml/2014/6/28/91
> >   His point is that the clock, if adjustable, may
> >   not support a rate that produces an acceptable
> >   signal rate.  Put another way, there may be a
> >   better frequency than what the clock framework
> >   selects that (in combination with the UART
> >   divisor latch registers) produces the best--or
> >   even a good--signal.  Is there any chance any
> >   ACPI platforms will suffer this problem?

No there is no such problems on any ACPI platforms. On all platforms
where the Designware UART is enumerated from ACPI we have adjustable
fractional divider generating the clock for it.

I understand the problem, but I think for now we can just limit this
solution to the platforms that we know it works with, like I do by
only using it with ACPI.


Thanks,

-- 
heikki
