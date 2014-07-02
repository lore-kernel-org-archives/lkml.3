Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101AbaGBRpU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 13:45:20 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49494 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756492AbaGBRpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 13:45:17 -0400
Date: Wed, 2 Jul 2014 13:45:16 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Stephen Warren <swarren@wwwdotorg.org>
cc: Tuomas Tynkkynen <ttynkkynen@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, Philipp Zabel <p.zabel@pengutronix.de>,
        <linux-usb@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <tuomas.tynkkynen@iki.fi>
Subject: Re: [PATCH 0/3] Tegra USB probe order issue fix
In-Reply-To: <53B430CE.5040905@wwwdotorg.org>
Message-ID: <Pine.LNX.4.44L0.1407021343480.874-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2014, Stephen Warren wrote:

> On 07/02/2014 10:09 AM, Alan Stern wrote:
> > On Wed, 2 Jul 2014, Stephen Warren wrote:
> > 
> >> On 07/02/2014 08:02 AM, Alan Stern wrote:
> >>> On Wed, 2 Jul 2014, Tuomas Tynkkynen wrote:
> >>>
> >>>> Hi all,
> >>>>
> >>>> This series fixes a probe order issue with the Tegra EHCI driver.
> >>>> Basically, the register area of the 1st USB controller contains some
> >>>> registers that are global to all of the controllers, but that are also
> >>>> cleared when reset is asserted to the 1st controller. So if (say) the
> >>>> 3rd controller would be the first one to finish probing successfully,
> >>>> then the reset that happens during the 1st controller's probe would
> >>>> result in broken USB. So the before doing anything with the USB HW,
> >>>> we should reset the 1st controller once, and then never ever reset
> >>>> it again.
> >>>
> >>> This sounds very much like the sort of thing that ought to be described 
> >>> in DT.  It is a hardware dependence, and DT exists for the purpose of 
> >>> describing the hardware.
> >>
> >> DT is more about describing the HW, not how SW has to use the HW.
> > 
> > Tuomas wrote: "the register area of the 1st USB controller contains
> > some registers that are global to all of the controllers, but that are
> > also cleared when reset is asserted to the 1st controller."  That is
> > very much an attribute of the hardware and so DT should describe it.
> 
> So you want to add a Boolean DT property to the first USB controller
> node indicating that it has the "shared" reset?

Something like that, yes.

> That would be fine, but
> would only replace the content of tegra_find_usb1_node(); much of the
> rest of the patch would remain the same.

That's okay.  tegra_find_usb1_node() was the most objectionable part of
the patch.

> I guess in this case, it's fine to require DT changes to enable the new
> feature of fixing this issue, so long as the code continues to work the
> same as it currently does with old DTs. Due to the backwards
> compatibility requirement, the patch will end up slightly more complex,
> but hopefully not too bad.

Good.

Alan Stern

