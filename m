Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab3LSSfk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 13:35:40 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:51361 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842Ab3LSSfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 13:35:38 -0500
X-Originating-IP: 173.246.103.110
Date: Thu, 19 Dec 2013 10:35:29 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: David Laight <David.Laight@ACULAB.COM>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Linux-Kernel <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Matthias Beyer <mail@beyermatthias.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        linux-usb <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 1/7] drivers: usb: Include appropriate header file in
 hcd.c
Message-ID: <20131219183529.GB17741@jtriplet-mobl1>
References: <0e0e74b4487edd341b66674333d734d5828c7e64.1387439261.git.rashika.kheria@gmail.com>
 <20131219163623.GB12255@kroah.com>
 <CAMpEsFGi7hj8EXUJ78zS0g6ZWRTW5FpGD5Q7tz1DgEJSNAWSZQ@mail.gmail.com>
 <20131219165802.GA27639@kroah.com>
 <AE90C24D6B3A694183C094C60CF0A2F6026B74B9@saturn3.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B74B9@saturn3.aculab.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 05:33:09PM -0000, David Laight wrote:
> > > These warning are non-default GCC warnings. These can be seen either
> > > by adding W=1 while running make (i.e. make W=1) or adding
> > > -Wmissing-prototypes in KBUILD_CFLAGS in the toplevel Makefile.
> > 
> > By default, we don't care about 'W=1' warnings, as no one sees them, and
> > they don't matter.
> 
> -Wmissing-prototypes really ought to be defined.

Yeah, that's the plan; this volume of patches should make it
sufficiently low-noise to allow turning it on by default.

> Some of the other warning are a little more pedantic, the most annoying
> is -Wsign-compare.  OTOH a lot of code out there is clean enough to build
> without any warnings and with a moderate amount of pedantry from the compiler.
> 
> OTOH just including extra headers isn't ideal - it can considerably
> slow down the compilation time. There are many subsystems that don't
> really separate their internal headers from their external ones.

There's a benefit to doing so, though: it ensures that the prototypes in
the header stay in sync with the definition.

- Josh Triplett
