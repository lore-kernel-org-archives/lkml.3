Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542AbaHNETS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 00:19:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53622 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbaHNETR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 00:19:17 -0400
Date: Thu, 14 Aug 2014 12:18:34 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: falcon@meizu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] async: async device driver probing
Message-ID: <20140814041834.GA7727@kroah.com>
References: <1391857539-27782-1-git-send-email-falcon@meizu.com>
 <20140208182729.GB10892@kroah.com>
 <20140813172030.GA23628@core.coreip.homeip.net>
 <20140813220223.GD7908@kroah.com>
 <20140813221044.GA11620@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140813221044.GA11620@core.coreip.homeip.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 03:10:44PM -0700, Dmitry Torokhov wrote:
> On Thu, Aug 14, 2014 at 06:02:23AM +0800, Greg KH wrote:
> > On Wed, Aug 13, 2014 at 10:20:33AM -0700, Dmitry Torokhov wrote:
> > > Hi Greg,
> > > 
> > > On Sat, Feb 08, 2014 at 10:27:29AM -0800, Greg KH wrote:
> > 
> > February?  That's an old thread to dig up...
> 
> Well, yes ;)
> 
> > 
> > 
> > > > On Sat, Feb 08, 2014 at 07:05:38PM +0800, falcon@meizu.com wrote:
> > > > > From: Wu Zhangjin <wuzhangjin@gmail.com>
> > > > > 
> > > > > [*Note*: NOT applicable, only for comments.]
> > > > > 
> > > > > To async the slow driver probing function of some devices, the device probing
> > > > > support is modified to support async scheduling.
> > > > > 
> > > > > In order to async your driver probing function, please mask the async_probe
> > > > > flag to 1, and to make sure one asynced probing is executed before an specified
> > > > > point, please call async_synchronize_full() in that point..
> > > > > 
> > > > > Usage:
> > > > > 
> > > > > 	static struct i2c_driver test_driver = {
> > > > > 		.driver = {
> > > > > 			.name   = TEST_DEV_NAME,
> > > > > 			.owner  = THIS_MODULE,
> > > > > 	+               .async_probe = 1,
> > > > > 		},
> > > > 
> > > > Why is this needed, we have defered probing and the container stuff, so
> > > > what problem is this solving?
> > > 
> > > Deferred probing only helps if resources are not ready yet, but
> > > sometimes we have a slow(ish) device which initialization stalls probing
> > > the rest of the system. For example a touchpad can take up to a second
> > > to calibrate itself after reset. One could try scheduling reset
> > > asynchronously, or try to offload it to open(), but that is not always
> > > best:
> > > 
> > > 1. Manual async: what to do when reset fails? Ideally we do not want to
> > > leave driver half-way bound with device not operable, but much rather
> > > signal the rest of the system that binding of the device failed and
> > > release all resources.
> > > 
> > > 2. Offload to open: the same issue as with manually doing async reset,
> > > plus sometimes we do not know all parameters that we should create input
> > > device with until after we reset physical device and queried it for
> > > capabilities.
> > > 
> > > Marking a driver to tell device core to execute probe asynchronously [at
> > > boot time] seems like a very appealing feature from driver author POV.
> > > 
> > > What is the container stuff you mention?
> > 
> > drivers/base/container.c
> 
> I am not sure how that would help in the scenario described above, as it
> seems ACPI specific...

It is?  I thought the drm people were using it on ARM.  I really don't
know, sorry, don't have the chance to check it right now...

greg k-h
