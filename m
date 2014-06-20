Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935021AbaFTQap (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 12:30:45 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:57532 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754236AbaFTQan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 12:30:43 -0400
X-Sasl-enc: m6YEGM2wHucZncuTA2ge8e25i68I+wnXHLv13ubRNBo7 1403281838
Date: Fri, 20 Jun 2014 09:34:39 -0700
From: Greg KH <greg@kroah.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Andreas Noever <andreas.noever@gmail.com>, linux-kernel@vger.kernel.org,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH v5 01/15] thunderbolt: Add initial cactus ridge NHI
 support
Message-ID: <20140620163439.GB8526@kroah.com>
References: <1401825852-4745-1-git-send-email-andreas.noever@gmail.com>
 <1401825852-4745-2-git-send-email-andreas.noever@gmail.com>
 <1403250112.22857.7.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403250112.22857.7.camel@x220>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 09:41:52AM +0200, Paul Bolle wrote:
> On Tue, 2014-06-03 at 22:03 +0200, Andreas Noever wrote:
> > Thunderbolt hotplug is supposed to be handled by the firmware. But Apple
> > decided to implement thunderbolt at the operating system level. The
> > firmare only initializes thunderbolt devices that are present at boot
> > time. This driver enables hotplug of thunderbolt of non-chained
> > thunderbolt devices on Apple systems with a cactus ridge controller.
> > 
> > This first patch adds the Kconfig file as well the parts of the driver
> > which talk directly to the hardware (that is pci device setup, interrupt
> > handling and RX/TX ring management).
> > 
> > Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
> > ---
> 
> This patch landed in today's linux-next (next-20140620).
> 
> > [...]
> > --- /dev/null
> > +++ b/drivers/thunderbolt/Kconfig
> > @@ -0,0 +1,12 @@
> > +menuconfig THUNDERBOLT
> > +	tristate "Thunderbolt support for Apple devices"
> > +	default no
> 
> That should have been "default n". But "n" is the default anyway, so I'd
> say this line might as well be dropped. Should I draft the trivial patch
> to do that?
> 
> > +	help
> > +	  Cactus Ridge Thunderbolt Controller driver
> > +	  This driver is required if you want to hotplug Thunderbolt devices on
> > +	  Apple hardware.
> > +
> > +	  Device chaining is currently not supported.
> > +
> > +	  To compile this driver a module, choose M here. The module will be
> > +	  called thunderbolt.
> 
> (Naive question: is Thunderbolt relevant outside x86_64?)

It could be, if someone makes a board for it, I don't see anything on it
that is x86-specific.

greg k-h
