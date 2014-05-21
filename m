Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873AbaEURwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 13:52:34 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42682 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752605AbaEURwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 13:52:33 -0400
Date: Wed, 21 May 2014 13:52:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Dan Williams <dan.j.williams@intel.com>
cc: Greg KH <gregkh@linuxfoundation.org>, Takashi Iwai <tiwai@suse.de>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        USB list <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Holger Hans Peter Freyther <holger@moiji-mobile.com>,
        Oliver Neukum <oneukum@suse.de>
Subject: Re: [PATCH 02/10] xhci: 'noxhci_port_switch' kernel parameter
In-Reply-To: <CAA9_cmfTy73WxtcCp45eWK-d-ZDH2=EbmPxLVPvdL1p48kfv7g@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1405211350450.1300-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2014, Dan Williams wrote:

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

Does the port count change?  Maybe nothing needs to be unloaded or 
reloaded.  Has anyone tried it?

Alan Stern

