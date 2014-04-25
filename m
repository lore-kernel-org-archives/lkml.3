Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752378AbaDYPN5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 11:13:57 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:58980 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbaDYPNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 11:13:55 -0400
Date: Fri, 25 Apr 2014 17:13:27 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>,
        Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        rafael.j.wysocki@intel.com
Subject: Re: [PATCH] USB: serial: fix sysfs-attribute removal deadlock
Message-ID: <20140425151327.GF2206@localhost>
References: <1398392134.2805.149.camel@ThinkPad-T5421.cn.ibm.com>
 <Pine.LNX.4.44L0.1404250953090.1140-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1404250953090.1140-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 09:54:33AM -0400, Alan Stern wrote:
> On Fri, 25 Apr 2014, Li Zhong wrote:
> 
> > > I don't get why try_module_get() matters here.  We can't call into
> > > ->store if the object at hand is already destroyed and the underlying
> > > module can't go away if the target device is still alive.
> > > try_module_get() doesn't actually protect the object.  Why does that
> > > matter?  This is self removal, right?  Can you please take a look at
> > > kernfs_remove_self()?
> > 
> > This is about one process writing something to driver attributes, and
> > one process trying to unload this driver. 
> > 
> > I think try_module_get() could detect whether the driver is being
> > unloaded, and if not, prevent it from being unloaded, so it could
> > protect the object here by not allow the driver to be unloaded.
> 
> That isn't how try_module_get() works.  If the module is being 
> unloaded, try_module_get() simply fails.  It does not prevent the 
> module from being unloaded -- that's why its name begins with "try".

Well, to be fair, if the try_module_get() *succeeds* it will prevent the
module from being unloaded (and otherwise the sysfs operation bails
out).

Johan
