Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab3LJIRu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:17:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59225 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933Ab3LJIRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:17:45 -0500
Date: Tue, 10 Dec 2013 00:19:22 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Ethan Zhao <ethan.kernel@gmail.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        raghavendra.kt@linux.vnet.ibm.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen/debugfs: Check debugfs initialization before using it
Message-ID: <20131210081922.GA2475@kroah.com>
References: <20131208140100.GA22793@kroah.com>
 <CABawtvO5YxH8J3d9Ea2ya3UUCEwjPWBRJaCJJMfovgmtPPBcRQ@mail.gmail.com>
 <20131209082527.GA26950@kroah.com>
 <CABawtvOdjncv7Zo29GbdGPm-ATsPNTVZqfje2qXTYeBRX=0w9A@mail.gmail.com>
 <20131209085526.GB4125@kroah.com>
 <CABawtvPhE9enmt2NdSemVsDRp6ca38xyQSTO2mEujx0kikWtoA@mail.gmail.com>
 <20131209111747.GA6562@kroah.com>
 <CABawtvNUBwTVzFfR4UotCexARN4+As5wKEPyGmRzN7-xZ6J00w@mail.gmail.com>
 <20131209184050.GC28986@kroah.com>
 <CABawtvMbMUf-tj77m9t=t45R3-1e8gE--8QZ7neU-HuSjGcveA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABawtvMbMUf-tj77m9t=t45R3-1e8gE--8QZ7neU-HuSjGcveA@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 04:03:41PM +0800, Ethan Zhao wrote:
> On Tue, Dec 10, 2013 at 2:40 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Mon, Dec 09, 2013 at 09:42:23PM +0800, Ethan Zhao wrote:
> >> Greg,
> >>     I am the man who built a Xen dom0, but couldn't see debugfs
> >> directory and files as expected. there is no warning or tip for me to
> >> enable the CONFIG_DEBUG_FS=y in .config , it cost me minutes to figure
> >> out what's
> >> the matter. and I know should check defugfs config and initialization as
> >> zswap_debugfs, tracer_debugfs ,rproc_debugfs did. Is it useless ? if
> >> it could save me just 1 minute next time ?
> >
> > So you would want a "warning" showing up for every single part of the
> > kernel that uses debugfs for when it isn't enabled?  That doesn't make
> > too much sense now, does it?
> 
> No, It is nice and like sun light when someone is struggling with the
> bugs in darkness,
> if some tips or warning output to them.
> 
> You have forgotten the initial stage you met :)

So, you really want to see 20+ KERNEL WARNINGS in your system when you
boot without CONFIG_DEBUGFS enabled?  No, that's not ok at all, sorry,
that is not going to happen.

Running a kernel without debugfs is a valid state, you are treating it
as an error, which isn't ok.

greg k-h
