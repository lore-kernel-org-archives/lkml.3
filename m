Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab3KGByb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 20:54:31 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:47277 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab3KGBy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 20:54:28 -0500
Date: Wed, 6 Nov 2013 17:56:46 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: "tj@kernel.org" <tj@kernel.org>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] devres: Freeing the drs after all release() are called
Message-ID: <20131107015646.GA5942@kroah.com>
References: <1383720018.3650.37.camel@cliu38-desktop-build>
 <20131106085859.GB9487@kroah.com>
 <27240C0AC20F114CBF8149A2696CBE4A01B86696@SHSMSX101.ccr.corp.intel.com>
 <20131107002959.GA32200@mtj.dyndns.org>
 <27240C0AC20F114CBF8149A2696CBE4A01B866C7@SHSMSX101.ccr.corp.intel.com>
 <20131107005151.GB32200@mtj.dyndns.org>
 <27240C0AC20F114CBF8149A2696CBE4A01B867B8@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A01B867B8@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 01:18:54AM +0000, Liu, Chuansheng wrote:
> Hello,
> 
> > -----Original Message-----
> > From: Tejun Heo [mailto:htejun@gmail.com] On Behalf Of tj@kernel.org
> > Sent: Thursday, November 07, 2013 8:52 AM
> > To: Liu, Chuansheng
> > Cc: Greg KH; dmitry.torokhov@gmail.com; linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH] devres: Freeing the drs after all release() are called
> > 
> > Hello,
> > 
> > On Thu, Nov 07, 2013 at 12:36:56AM +0000, Liu, Chuansheng wrote:
> > > Yes, I knew I can put the code always like below:
> > > A = devm_kzalloc();
> > > C = devm_kzalloc();
> > > ...
> > > B= devm_request_threaded_irq(isr_handler);
> > >
> > > But, the above is just one simple coding prototype, if there are many calling:
> > > E -- > F -- > D -- >... then to devm_kzalloc().
> > >
> > > To be honest, it will make code too hard to always adapt the rule?
> > > And I trying to find out every potential devm_kzalloc() before irq requesting.
> > 
> > It isn't a good idea to paper over existing bugs from upper layer.
> > You realize that the above code sequence is already buggy during init
> > unless there's something explicitly blocking generation of irqs until
> > init is complete, right?  The right thing to do would be either
> > reordering the operations or wrapping the operation which unblocks irq
> > at the end of init with devres so that irq gets blocked before the
> > rest of release proceeds.
> > 
> > What we must *NOT* do is working around existing bugs in a half-assed
> > way from midlayer.  
> 
> Yes, doing the right order initialization is always right thing.
> But normally when we hit the panic during shutdown/reboot like below:
> PAGE FAULT XXX 0x12345678
> 
> It is really difficult to debug.
> So at least, could we have method to expose these hidden issues?

Have you enabled timer debugging?  I think there's an irq debugging
option as well.

We aren't going to paper over driver bugs by changing the kernel core,
sorry.  Consider this patch dropped.

greg k-h
