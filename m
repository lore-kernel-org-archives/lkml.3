Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759974Ab3HNRCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 13:02:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52470 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab3HNRCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 13:02:38 -0400
Date: Wed, 14 Aug 2013 10:04:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Xenia Ragiadakou <burzalodowa@gmail.com>,
        Jason Baron <jbaron@akamai.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Dynamic debug on by default?
Message-ID: <20130814170410.GA7668@kroah.com>
References: <20130814164022.GA22934@xanatos>
 <1376499114.1949.81.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376499114.1949.81.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 09:51:54AM -0700, Joe Perches wrote:
> On Wed, 2013-08-14 at 09:40 -0700, Sarah Sharp wrote:
> > Hi Xenia,
> > 
> > I'm a bit confused.  I thought that debugging messages would be turned
> > off by default for a module if CONFIG_DYNAMIC_DEBUG was turned on.  When
> > I tested your patch to remove the CONFIG_USB_XHCI_HCD_DEBUGGING and just
> > use dev_dbg, the messages from the xHCI driver appeared in dmesg by
> > default.
> > 
> > That generates a lot of log spew.  We can have distros add a boot
> > parameter option to turn off debug messages, but that boot parameter is
> > limited to 1023 characters.  I'm concerned that if more drivers add
> > dynamic debugging, the distros will eventually run out of space in the
> > dynamic debugging boot parameter.  I know Greg was ripping out debugging
> > config options in other USB drivers, so this is a bit concerning.
> > 
> > Jason, is there a way within the xHCI driver to say that dynamic
> > debugging should be off by default?  I've looked through the
> > documentation, and I can't find anything like that documented.
> 
> #undefine DEBUG
> 
> > I've attached my .config file, in case I have something misconfigured.
> 
> Because of:
> 
> drivers/usb/host/Makefile:ccflags-$(CONFIG_USB_DEBUG) := -DDEBUG

Yes, that's the problem, I'm trying to get rid of the CONFIG_USB_DEBUG
flag, and I'm almost there.  There are some host controllers that still
use it for some things that I have not cleaned up fully yet.

thanks,

greg k-h
