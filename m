Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab3DZWAi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 18:00:38 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:54039 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab3DZWAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 18:00:36 -0400
Date: Fri, 26 Apr 2013 15:00:33 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch for-3.8-rc8] usb, chipidea: fix link error when
 USB_EHCI_HCD is a module
Message-ID: <20130426220033.GA27963@kroah.com>
References: <alpine.DEB.2.02.1304261323060.17754@chino.kir.corp.google.com>
 <20130426203345.GA25959@kroah.com>
 <alpine.DEB.2.02.1304261448350.25408@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1304261448350.25408@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 02:50:56PM -0700, David Rientjes wrote:
> On Fri, 26 Apr 2013, Greg Kroah-Hartman wrote:
> 
> > I think you mean "3.9" in your subject: right?
> > 
> 
> It's your subsystem, if you want to release a kernel with a known-broken 
> config, that's your call.

As you point out, it's been "known broken" since 3.7, no rush now to fix
it, especially so late in the merge window. :)

> > On Fri, Apr 26, 2013 at 01:25:01PM -0700, David Rientjes wrote:
> > > Fixes link error when USB_EHCI_HCD=m and USB_CHIPIDEA_HOST=y:
> > > 
> > > 	drivers/built-in.o: In function `ci_hdrc_host_init':
> > > 	drivers/usb/chipidea/host.c:104: undefined reference to `ehci_init_driver'
> > > 
> > > as a result of commit 09f6ffde2ece ("USB: EHCI: fix build error by making
> > > ChipIdea host a normal EHCI driver").
> > > 
> > > Cc: stable@vger.kernel.org [v3.7+]
> > > Signed-off-by: David Rientjes <rientjes@google.com>
> > > ---
> > >  drivers/usb/chipidea/Kconfig | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > There have been a ton of chipidea changes recently in linux-next.  This
> > really just looks like you got the configuration wrong, nothing that is
> > needed at this point in the release cycle, right?
> > 
> 
> This happens in both linux-next as well as Linus's tree, and has since 
> 3.7.

The chipidea maintainer has a big update all queued up in my trees for
3.10-rc1, if you could verify that linux-next fixes your problem, I
would appreciate it.

If not, please let us know.

thanks,

greg k-h
