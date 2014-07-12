Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbaGKX7i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 19:59:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42444 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbaGKX7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 19:59:36 -0400
Date: Fri, 11 Jul 2014 17:04:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Gavin Guo <gavin.guo@canonical.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        "Nyman, Mathias" <mathias.nyman@intel.com>, linux-usb@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>, YK <yk@canonical.com>,
        Anthony Wong <anthony.wong@canonical.com>,
        Gerald Yang <gerald.yang@canonical.com>
Subject: Re: [PATCH 0/1] Fixes to the USB 3.0 detection as 2.0 on AMD platform
Message-ID: <20140712000404.GA16602@kroah.com>
References: <1405059756-11983-1-git-send-email-gavin.guo@canonical.com>
 <CA+eFSM0z5hUwCNHt9Qv15JJLXsrKfQSXCCCpPrtWYs+3d8gCvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+eFSM0z5hUwCNHt9Qv15JJLXsrKfQSXCCCpPrtWYs+3d8gCvQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2014 at 07:32:34AM +0800, Gavin Guo wrote:
> Hi all,
> 
> On Fri, Jul 11, 2014 at 2:22 PM, Gavin Guo <gavin.guo@canonical.com> wrote:
> > Hi Sarah and Mathias,
> >
> > As the discussion in http://comments.gmane.org/gmane.linux.usb.general/107011,
> > I found that [AMD] FCH USB XHCI Controller [1022:7814] the USB 3.0 disk
> > can't work in SuperSpeed after several times of hotplug. After doing some
> > experiments and bisection, I found the bug is caused by
> > 41e7e056cdc662f704fa9262e5c6e213b4ab45dd (USB: Allow USB 3.0 ports to be
> > disabled.). And the bug can be fixed by not executing the
> > hub_usb3_port_disable() function. I also found that the port status is
> > already in RxDetect before setting the port to Disabled in
> > hub_usb3_port_disable() function. So, there are 2 ways to fix the bug:
> >
> > 1) Check if the Vendor/Device id is [1022:7814] at the beginning of
> > hub_usb3_port_disable() function. If yes, return without executing the
> > remaining code.
> >
> > 2) Check if the port status is already in RxDetect, if yes, return without
> > executing the remaining code.
> >
> > The second method seems more reasonable, so the patch is the implementation
> > of the second one. But it will affect more platforms and I don't know if
> > there'll be any negative result. Otherwise, if the first one is correct,
> > I can reimplement a new one.
> >
> > I'm appreciated if you can give me some advice, or if there is any thing I missed.
> >
> > Thanks,
> > Gavin
> >
> > Gavin Guo (1):
> >   usb: Check if port status is equal to RxDetect
> >
> >  drivers/usb/core/hub.c | 19 +++++++++++++++++++
> >  1 file changed, 19 insertions(+)
> >
> > --
> > 2.0.0
> >
> 
> Add Greg k-h to the list.

Why?  Mathias can handle this just fine, right?

And I read all linux-usb@vger email anyway...

greg k-h
