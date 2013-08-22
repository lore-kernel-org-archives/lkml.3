Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab3HVHut (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 03:50:49 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:48072 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338Ab3HVHur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 03:50:47 -0400
Message-ID: <1377157838.2633.67.camel@ThinkPad-T5421>
Subject: Re: [RFC PATCH next]module: Fix mod->mkobj.kobj potentially freed
 too early
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        linux-next list <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, rmk+kernel@arm.linux.org.uk
Date: Thu, 22 Aug 2013 15:50:38 +0800
In-Reply-To: <87vc2yciqi.fsf@rustcorp.com.au>
References: <1377078598.2709.25.camel@ThinkPad-T5421>
	 <20130821161819.GA14364@kroah.com> <87vc2yciqi.fsf@rustcorp.com.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082207-3864-0000-0000-000009B4BF4B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-22 at 16:30 +0930, Rusty Russell wrote:
> Greg KH <gregkh@linuxfoundation.org> writes:
> > On Wed, Aug 21, 2013 at 05:49:58PM +0800, Li Zhong wrote:
> > >  struct kobj_type module_ktype = {
> > > +	.release   =	module_kobj_release,
> > >  	.sysfs_ops =	&module_sysfs_ops,
> > >  };
> >
> > Wait, as there is no release function here for the kobject (a different
> > problem), why is the deferred release function causing any problems?
> > There is no release function to call, so what is causing the oops?
> 
> Because DEBUG_KOBJECT_RELEASE does the kobject_put() sometime later,
> which is what causes the oops.
> 
> Since kobjects don't have an owner field, AFAICT someone *could* grab
> one in a module which is unloading, then put it after unload.   So this
> fixes a real bug, albeit not one seen in the real world.
> 
> Applied,

Oh, thank you, Rusty. 

I just sent out another version... which fix it in another way as Greg
suggested, could you please also help to take a look at it?

Thanks, Zhong

> Rusty.
> 


