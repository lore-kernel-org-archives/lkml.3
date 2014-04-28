Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975AbaD1BzQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:55:16 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:60750 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbaD1BzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:55:12 -0400
Message-ID: <1398650100.3046.64.camel@ThinkPad-T5421>
Subject: Re: [PATCH] USB: serial: fix sysfs-attribute removal deadlock
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tejun Heo <tj@kernel.org>, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        rafael.j.wysocki@intel.com
Date: Mon, 28 Apr 2014 09:55:00 +0800
In-Reply-To: <Pine.LNX.4.44L0.1404250953090.1140-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1404250953090.1140-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042801-0342-0000-0000-000008928F12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-25 at 09:54 -0400, Alan Stern wrote:
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

Yes, I know that. What I said above is for the case when
try_module_get() detects the driver is NOT being unloaded, and increases
the reference counter. 

Thanks, Zhong
> 
> Alan Stern
> 


