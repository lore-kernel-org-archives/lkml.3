Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbaDXBNO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 21:13:14 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:35518 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbaDXBNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 21:13:12 -0400
Message-ID: <1398301982.2805.57.camel@ThinkPad-T5421.cn.ibm.com>
Subject: Re: [RFC PATCH v5 2/2] Use kernfs_break_active_protection() for
 device online store callbacks
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        gregkh@linuxfoundation.org, rafael.j.wysocki@intel.com,
        toshi.kani@hp.com
Date: Thu, 24 Apr 2014 09:13:02 +0800
In-Reply-To: <7083319.XfqyEgH4Mt@vostro.rjw.lan>
References: <1397461649.12943.1.camel@ThinkPad-T5421.cn.ibm.com>
	 <24546121.zVbmBfcmRG@vostro.rjw.lan>
	 <1398217832.2805.33.camel@ThinkPad-T5421.cn.ibm.com>
	 <7083319.XfqyEgH4Mt@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042401-0342-0000-0000-00000889761A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-23 at 12:54 +0200, Rafael J. Wysocki wrote:
> On Wednesday, April 23, 2014 09:50:32 AM Li Zhong wrote:
> > On Tue, 2014-04-22 at 12:11 +0200, Rafael J. Wysocki wrote:
> > > On Tuesday, April 22, 2014 11:34:39 AM Li Zhong wrote:
> > > > On Mon, 2014-04-21 at 18:46 -0400, Tejun Heo wrote:
> > > > > Hello,
> > > > > 
> > > > > On Mon, Apr 21, 2014 at 05:23:50PM +0800, Li Zhong wrote:
> > > > > 
> > > > > Proper /** function comment would be nice.
> > > > 
> > > > Ok, will try to write some in next version.
> > > > 
> > > > > 
> > > > > > +struct kernfs_node *lock_device_hotplug_sysfs(struct device *dev,
> > > > > > +					       struct device_attribute *attr)
> > > > > 
> > > > > I can see why you did this but let's please not require the user of
> > > > > this function to see how the thing is working internally.  Let's
> > > > > return int and keep track of (or look up again) the kernfs_node
> > > > > internally.
> > > > 
> > > > Ok, it also makes the prototype of lock and unlock look more consistent
> > > > and comfortable. 
> > > > 
> > > > > 
> > > > > >  {
> > > > > ...
> > > > > > +	/*
> > > > > > +	 * We assume device_hotplug_lock must be acquired before removing
> > > > > 
> > > > > Is this assumption true?  If so, can we add lockdep assertions in
> > > > > places to verify and enforce this?  If not, aren't we just feeling
> > > > > good when the reality is broken?
> > > > 
> > > > It seems not true ... I think there are devices that don't have the
> > > > online/offline concept, we just need to add it, remove it, like ethernet
> > > > cards. 
> > > 
> > > Well, I haven't been following this closely (I was travelling, sorry), but
> > > there certainly are devices without online/offline.  That currently is only
> > > present for CPUs, memory blocks and ACPI containers (if I remember correctly).
> > > 
> > > > 
> > > > Maybe we could change the comments above, like:
> > > > 	/* We assume device_hotplug_lock must be acquired before 
> > > > 	 * removing devices, which have online/offline sysfs knob, 
> > > > 	 * and some locks are needed to serialize the online/offline
> > > > 	 * callbacks and device removing. ...
> > > > ? 
> > > 
> > > Lockdep assertions would be better than this in my opinion.
> > 
> > This is talking about the lock required in the other process, the device
> > removing process, e.g. that in remove_memory() below. So I guess no
> > lockdep assertions needed here. Or I misunderstand your point? 
> 
> I mean if you assume certain lock to be held somewhere, it is better to use
> lockdep annotations to express that assumption, because that will cause users
> to *see* the problem when it happens.

OK, I see, I think you were suggesting the same thing as Tejun, just I
misunderstood it. 

Thanks, Zhong

> 
> Thanks!
> 


