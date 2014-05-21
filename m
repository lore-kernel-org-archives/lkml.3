Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706AbaEUV7j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 17:59:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49873 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673AbaEUV7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 17:59:37 -0400
Date: Thu, 22 May 2014 06:59:26 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Takashi Iwai <tiwai@suse.de>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        USB list <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Holger Hans Peter Freyther <holger@moiji-mobile.com>,
        Oliver Neukum <oneukum@suse.de>
Subject: Re: [PATCH 02/10] xhci: 'noxhci_port_switch' kernel parameter
Message-ID: <20140521215926.GA15454@kroah.com>
References: <20140520010137.GA8146@kroah.com>
 <537B24B8.9050303@linux.intel.com>
 <s5ha9acbwwo.wl%tiwai@suse.de>
 <CAPcyv4gg164u8Dz0RtV4KjXkDyCMvuC92j6VopqTbA1Shp_3QA@mail.gmail.com>
 <20140520203432.GB30178@kroah.com>
 <CAPcyv4i4jTMMbZWWdb79bJ2f5OUaSin4BN_ukWmVcv7JCiup3g@mail.gmail.com>
 <20140521002720.GC997@kroah.com>
 <CAPcyv4h-F=Qmvne4BTPsHm7gk03efitR-kHaED9GFDTM8NA4tA@mail.gmail.com>
 <20140521063138.GA5952@kroah.com>
 <CAA9_cmfTy73WxtcCp45eWK-d-ZDH2=EbmPxLVPvdL1p48kfv7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA9_cmfTy73WxtcCp45eWK-d-ZDH2=EbmPxLVPvdL1p48kfv7g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 10:29:09AM -0700, Dan Williams wrote:
> On Tue, May 20, 2014 at 11:31 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Tue, May 20, 2014 at 11:21:03PM -0700, Dan Williams wrote:
> >> On Tue, May 20, 2014 at 5:27 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> >> >> Greg,
> >> >>
> >> >> Sorry, I don't think it is fair to users to force them to re-compile
> >> >> their kernel to get their device to work.
> >> >
> >> > I totally agree.
> >> >
> >> >> Granted, I'm new to USB
> >> >> development, but the rate of reports of endpoint devices that mess up
> >> >> and require quirks in the hcd-driver or usb-core seems un-ending to
> >> >> me.  So, I don't think it is fair to expect that the tide of quirky
> >> >> devices will be stemmed in any reasonable amount of time.  Having a
> >> >> "works with noxhci_port_switch" report from users is good data (hmm, I
> >> >> think a printk to tell users to file a report upstream if the option
> >> >> resolves their issue is needed).
> >> >
> >> > How about just adding a debugfs file instead?  That way, once you fix
> >> > this, we can then remove it and no one will care.
> >>
> >> The only thing stopping me from saying "deal." is that this darn
> >> things is presently a pci quirk.  So it happens well before the user
> >> has a chance to manually override it with a debugfs file.
> >
> > Then have the debugfs file disconnect the device and reconnect it.
> 
> We also need to reload the ehci hcd driver since it needs to know its
> port count at load time as well.  Which is more violent and error
> prone than I think we want.

Why is that a problem?

> >> Let me look into delaying the quirk until the driver loads, because
> >> ideally the right interface for this is "blacklist xhci_hcd" in
> >> /etc/modprobe.conf.
> >
> > Which really doesn't work for systems / distros that build the driver
> > into the kernel.
> 
> True.  I'm back to a kernel command line option as the only viable way
> forward, but let me try to wordsmith the description to make clear
> when to use this workaround and the obligation to report upstream when
> this workaround works so we can queue up the fix for xhci.

No, I really don't want a command line option if at all possible as you
will have to support it for forever.

greg k-h
