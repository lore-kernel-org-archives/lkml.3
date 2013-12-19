Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab3LSQ6D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:58:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43704 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629Ab3LSQ6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:58:00 -0500
Date: Thu, 19 Dec 2013 08:58:02 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Matthias Beyer <mail@beyermatthias.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        linux-usb <linux-usb@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH 1/7] drivers: usb: Include appropriate header file in
 hcd.c
Message-ID: <20131219165802.GA27639@kroah.com>
References: <0e0e74b4487edd341b66674333d734d5828c7e64.1387439261.git.rashika.kheria@gmail.com>
 <20131219163623.GB12255@kroah.com>
 <CAMpEsFGi7hj8EXUJ78zS0g6ZWRTW5FpGD5Q7tz1DgEJSNAWSZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMpEsFGi7hj8EXUJ78zS0g6ZWRTW5FpGD5Q7tz1DgEJSNAWSZQ@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 10:11:45PM +0530, Rashika Kheria wrote:
> On Thu, Dec 19, 2013 at 10:06 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Thu, Dec 19, 2013 at 03:36:00PM +0530, Rashika Kheria wrote:
> >> Include appropriate header file include/linux/usb/otg.h in core/hcd.c
> >> because function usb_bus_start_enum() has its prototype declaration in
> >> include/linux/usb/otg.h.
> >>
> >> This eliminates the following warning in core/hcd.c:
> >> drivers/usb/core/hcd.c:2295:5: warning: no previous prototype for ‘usb_bus_start_enum’ [-Wmissing-prototypes]
> >
> > What is generating this warning?  I don't see it here on my machines,
> > nor do I see any of the other warnings you have fixed in this series.
> > How do I duplicate them?
> >
> > thanks,
> >
> > greg k-h
> 
> Hi Greg,
> 
> These warning are non-default GCC warnings. These can be seen either
> by adding W=1 while running make (i.e. make W=1) or adding
> -Wmissing-prototypes in KBUILD_CFLAGS in the toplevel Makefile.

By default, we don't care about 'W=1' warnings, as no one sees them, and
they don't matter.

Now if you were to see these issues with 'sparse' or just a "normal"
build, then that might be worth fixing up.

greg k-h
