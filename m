Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab3LSSe3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 13:34:29 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:36094 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679Ab3LSSe1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 13:34:27 -0500
X-Originating-IP: 173.246.103.110
Date: Thu, 19 Dec 2013 10:34:18 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rashika Kheria <rashika.kheria@gmail.com>,
        Linux-Kernel <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Matthias Beyer <mail@beyermatthias.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        linux-usb <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 1/7] drivers: usb: Include appropriate header file in
 hcd.c
Message-ID: <20131219183418.GA17741@jtriplet-mobl1>
References: <0e0e74b4487edd341b66674333d734d5828c7e64.1387439261.git.rashika.kheria@gmail.com>
 <20131219163623.GB12255@kroah.com>
 <CAMpEsFGi7hj8EXUJ78zS0g6ZWRTW5FpGD5Q7tz1DgEJSNAWSZQ@mail.gmail.com>
 <20131219165802.GA27639@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131219165802.GA27639@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 08:58:02AM -0800, Greg Kroah-Hartman wrote:
> On Thu, Dec 19, 2013 at 10:11:45PM +0530, Rashika Kheria wrote:
> > On Thu, Dec 19, 2013 at 10:06 PM, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > > On Thu, Dec 19, 2013 at 03:36:00PM +0530, Rashika Kheria wrote:
> > >> Include appropriate header file include/linux/usb/otg.h in core/hcd.c
> > >> because function usb_bus_start_enum() has its prototype declaration in
> > >> include/linux/usb/otg.h.
> > >>
> > >> This eliminates the following warning in core/hcd.c:
> > >> drivers/usb/core/hcd.c:2295:5: warning: no previous prototype for ‘usb_bus_start_enum’ [-Wmissing-prototypes]
> > >
> > > What is generating this warning?  I don't see it here on my machines,
> > > nor do I see any of the other warnings you have fixed in this series.
> > > How do I duplicate them?
> > >
> > > thanks,
> > >
> > > greg k-h
> > 
> > Hi Greg,
> > 
> > These warning are non-default GCC warnings. These can be seen either
> > by adding W=1 while running make (i.e. make W=1) or adding
> > -Wmissing-prototypes in KBUILD_CFLAGS in the toplevel Makefile.
> 
> By default, we don't care about 'W=1' warnings, as no one sees them, and
> they don't matter.
> 
> Now if you were to see these issues with 'sparse' or just a "normal"
> build, then that might be worth fixing up.

Code that generates warnings with gcc -Wmissing-prototypes will also
generate warnings with Sparse's (on by default) -Wdecl.  (-Wdecl also
warns about data, which gcc doesn't.)

- Josh Triplett
